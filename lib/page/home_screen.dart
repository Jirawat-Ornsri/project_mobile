import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:project_mobile/animation/wave_animation.dart';
import 'package:project_mobile/models/drink.dart';
import 'package:project_mobile/models/profile.dart';
import 'package:project_mobile/models/reminder.dart';
import 'package:project_mobile/page/add_drink_screen.dart';
import 'package:project_mobile/utils/colors.dart';
import 'package:project_mobile/widgets/box_add_drink.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;

  // connect firebase
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  // form validation
  final formKey = GlobalKey<FormState>();

  // get drink model
  Drink drink = Drink(typeDrink: '', ml: 0, time: null, percen: 0);

  // get profile model
  Profile profile = Profile(
    username: '',
    email: '',
    password: '',
    photoUrl: '',
    height: '',
    weight: 0,
    gender: '',
    reminders: [],
    drinks: [],
  );

  // get current user
  final user = FirebaseAuth.instance.currentUser;

  // fn calculate weight
  int waterCal(int weight) {
    double result = (weight * 2.2 * (30 / 2));
    return result.toInt();
  }

  // fn real time say goodmorning goodafternoon goodevening
  String getGreeting() {
    var now = DateTime.now();
    var morningStart = DateTime(now.year, now.month, now.day, 5, 0, 0);
    var morningEnd = DateTime(now.year, now.month, now.day, 11, 59, 59);

    var afternoonStart = DateTime(now.year, now.month, now.day, 12, 0, 0);
    var afternoonEnd = DateTime(now.year, now.month, now.day, 17, 59, 59);

    var eveningStart = DateTime(now.year, now.month, now.day, 18, 0, 0);
    var eveningEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);

    if (now.isAfter(morningStart) && now.isBefore(morningEnd)) {
      return 'Good Morning';
    } else if (now.isAfter(afternoonStart) && now.isBefore(afternoonEnd)) {
      return 'Good Afternoon';
    } else if (now.isAfter(eveningStart) && now.isBefore(eveningEnd)) {
      return 'Good Evening';
    }

    return 'Good Night';
  }


  // ทำการเคลียร์ข้อมูลการดื่ม (drinks) ในโปรไฟล์ (Profile) ของผู้ใช้โดยอัตโนมัติทุกวันเที่ยงคืน
  void initState() {
    super.initState();
    // Schedule a function to clear drinks at midnight daily
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _clearDrinksAtMidnight();
      // Schedule this function to run again tomorrow at midnight
      await Future.delayed(Duration(days: 1) -
          DateTime.now().difference(DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)));
      initState(); // Call initState again to refresh data
    });
  }

  // clear field drinks when 00:00 am
  Future<void> _clearDrinksAtMidnight() async {
    // Check if it's midnight
    if (DateTime.now().hour == 0 && DateTime.now().minute == 0) {
      profile.drinks.clear();
      // Update data in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .update({'drinks': profile.drinks});
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user?.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.exists) {
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;
                  profile = Profile(
                    username: data['username'] ?? '',
                    email: data['email'] ?? '',
                    password: data['password'] ?? '',
                    photoUrl: data['photoUrl'] ?? '',
                    height: data['height'] ?? '',
                    weight: data['weight'] ?? 0,
                    gender: data['gender'] ?? '',
                    reminders: List.from(data['reminders'] ?? [])
                        .map((e) => Reminder(
                              title: e['title'] ?? '',
                              des: e['description'] ?? '',
                              time: (e['time'] as Timestamp?)?.toDate() ??
                                  DateTime.now(),
                            ))
                        .toList(),
                    drinks: List.from(data['drinks'] ?? [])
                        .map((e) => Drink(
                              typeDrink: e['typeDrink'] ?? '',
                              ml: e['quantity'] ?? '',
                              time: (e['time'] as Timestamp?)?.toDate() ??
                                  DateTime.now(),
                              percen: 0,
                            ))
                        .toList(),
                  );

                  // get data from collection
                  final username = snapshot.data!.get('username');
                  final weight = snapshot.data!.get('weight');

                  // sum quantity
                  var total = 0;
                  for (var quantity in profile.drinks) {
                    total += quantity.ml;
                  }

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 80,
                        ),

                        // *** part title name ***

                        Padding(
                          padding: const EdgeInsets.only(left: 48, right: 48),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // --- title username ---
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    getGreeting(),
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: thirdColor,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  Text(
                                    "$username",
                                    style: const TextStyle(
                                        fontSize: 32,
                                        color: fourColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),

                              // --- profile ---
                              profile.photoUrl.isNotEmpty
                                  ? CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(profile.photoUrl),
                                      radius: 27.5,
                                    )
                                  : const CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          'https://zultimate.com/wp-content/uploads/2019/12/default-profile.png'),
                                      radius: 27.5,
                                    ),
                            ],
                          ),
                        ),

                        // *** part circle water ***
                        const SizedBox(
                          height: 45,
                        ),

                        // water tank animation
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white,
                                width: 1,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ), // เพิ่ม border radius ที่คุณต้องการ
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(255, 204, 204, 204),
                                offset: const Offset(0, 1),
                                blurRadius: 10.0,
                                spreadRadius: 2.0,
                              ),
                              BoxShadow(
                                color: Colors.white,
                                offset: const Offset(0.0, 0.0),
                                blurRadius: 0.0,
                                spreadRadius: 0.0,
                              ),
                            ],
                          ),
                          // check condition if user input quantity grater than user weight
                          child: total > waterCal(weight)
                              ? WaveProgress(
                                  progress: 1.0,
                                  width: double.infinity,
                                  height: double.infinity,
                                  color: secondColor,
                                  waterLevel: 0.5, // ระดับน้ำตรงกลาง
                                )
                              : WaveProgress(
                                  progress: total / waterCal(weight),
                                  width: double.infinity,
                                  height: double.infinity,
                                  color: secondColor,
                                  waterLevel: 0.5, // ระดับน้ำตรงกลาง
                                ),
                        ),

                        SizedBox(
                          height: 25,
                        ),

                        Text(
                          '$total / ${waterCal(weight)} ml',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: fourColor),
                        ),

                        // show date time
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat('EEEE').format(DateTime.now()),
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: secondColor),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              DateFormat('dd:MM:yyyy').format(DateTime.now()),
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: secondColor),
                            ),
                          ],
                        ),

                        // *** part show drink ***
                        SizedBox(
                          height: 20,
                        ),

                        Container(
                          width: 363,
                          height: 220,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                for (var drink in profile.drinks)
                                  BoxDrink(
                                    typeDrink: drink.typeDrink,
                                    time:
                                        DateFormat('HH:mm').format(drink.time!),
                                    ml: drink.ml,
                                  )
                              ],
                            ),
                          ),
                        ),

                        // *** part add drink button ***
                        Container(
                          width: 150,
                          height: 42,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          thirdColor)),
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return AddDrinkScreen();
                                }));
                              },
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Add Drink',
                                    style: TextStyle(
                                        color: firstColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Icon(
                                    Icons.water_drop,
                                    color: secondColor,
                                    size: 18,
                                  )
                                ],
                              )),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            );
          } else {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        });
  }
}
