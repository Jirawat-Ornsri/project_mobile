import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:project_mobile/animation/wave_animation.dart';
import 'package:project_mobile/models/drink.dart';
import 'package:project_mobile/models/profile.dart';
import 'package:project_mobile/models/reminder.dart';
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

  DateTime? selectedTime;

  // get drink model
  Drink drink = Drink(typeDrink: '', ml: 0, time: null);

  // get profile model
  Profile profile = Profile(
    username: '',
    email: '',
    password: '',
    imageBase64: '',
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
                    imageBase64: data['imageBase64'] ?? '',
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
                                  const Text(
                                    'Hello',
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
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                    'https://zultimate.com/wp-content/uploads/2019/12/default-profile.png'),
                                radius: 28,
                              )
                            ],
                          ),
                        ),

                        // *** part circle water ***
                        SizedBox(
                          height: 45,
                        ),

                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(119, 188, 188, 188), // สีพื้นหลัง
                            borderRadius: BorderRadius.circular(
                                20), // ความโค้งของมุม (radian)
                          ),
                          child: WaveProgress(
                            progress: total / waterCal(weight),
                            width: double.infinity,
                            height: double.infinity,
                            color: secondColor,
                            waterLevel: 0.5, // ระดับน้ำตรงกลาง
                          ),
                        ),

                        // Container(
                        //   width: 200,
                        //   height: 200,
                        //   decoration: BoxDecoration(
                        //     color: const Color.fromARGB(255, 188, 188, 188), // สีพื้นหลัง
                        //     borderRadius: BorderRadius.circular(
                        //         100), // ความโค้งของมุม (radian)
                        //   ),
                        //   child: Stack(
                        //     children: [
                        //       // Actual progress indicator
                        //       Positioned.fill(
                        //         child: Container(
                        //           width: 200,
                        //           height: 200,
                        //           child: CircularProgressIndicator(
                        //             value: total /
                        //                 waterCal(
                        //                     weight), // Value calculated from the total amount drank and the recommended amount
                        //             strokeWidth:
                        //                 8, // Thickness of the progress indicator
                        //             color: thirdColor, // Color of the progress indicator
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),

                        SizedBox(
                          height: 25,
                        ),

                        Text(
                          '$total/${waterCal(weight)} ml',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: fourColor),
                        ),

                        // *** part show drink ***
                        SizedBox(
                          height: 40,
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
                                      time: DateFormat('HH:mm')
                                          .format(drink.time!),
                                      ml: drink.ml)
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
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Form(
                                      key: formKey,
                                      child: AlertDialog(
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextFormField(
                                              validator: RequiredValidator(
                                                  errorText:
                                                      "input type drink."),
                                              decoration: InputDecoration(
                                                hintText: 'Type Drink',
                                              ),
                                              onSaved: (String? typeDrink) {
                                                drink.typeDrink = typeDrink!;
                                              },
                                            ),
                                            TextFormField(
                                              validator: MultiValidator([
                                                RequiredValidator(
                                                    errorText:
                                                        'input your weight.'),
                                                PatternValidator(r'^[0-9]+$',
                                                    errorText:
                                                        'input only numbers'),
                                              ]),
                                              decoration: InputDecoration(
                                                hintText: 'Water quantity',
                                              ),
                                              onSaved: (String? ml) {
                                                drink.ml = int.parse(ml!);
                                              },
                                            ),
                                            ListTile(
                                              title: Text(selectedTime != null
                                                  ? '${DateFormat('HH:mm').format(selectedTime!)}}'
                                                  : 'Select Time'),
                                              trailing: Icon(Icons.access_time),
                                              onTap: () async {
                                                final TimeOfDay? pickedTime =
                                                    await showTimePicker(
                                                  context: context,
                                                  initialTime:
                                                      TimeOfDay.fromDateTime(
                                                          selectedTime ??
                                                              DateTime.now()),
                                                );
                                                if (pickedTime != null) {
                                                  setState(() {
                                                    selectedTime =
                                                        DateTime.now();
                                                    selectedTime = DateTime(
                                                      selectedTime!.year,
                                                      selectedTime!.month,
                                                      selectedTime!.day,
                                                      pickedTime.hour,
                                                      pickedTime.minute,
                                                    );
                                                  });
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          Align(
                                            alignment: Alignment.center,
                                            child: Container(
                                              width: 86,
                                              height: 28,
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(fourColor),
                                                ),
                                                onPressed: () {
                                                  final user = FirebaseAuth
                                                      .instance.currentUser;
                                                  if (formKey.currentState!
                                                      .validate()) {
                                                    formKey.currentState!
                                                        .save();
                                                    if (selectedTime != null) {
                                                      setState(() {
                                                        profile.drinks
                                                            .add(Drink(
                                                          typeDrink:
                                                              drink.typeDrink,
                                                          ml: drink.ml,
                                                          time: selectedTime!,
                                                        ));
                                                      });
                                                      FirebaseFirestore.instance
                                                          .collection('users')
                                                          .doc(user?.uid)
                                                          .update({
                                                        'drinks': FieldValue
                                                            .arrayUnion([
                                                          {
                                                            'typeDrink':
                                                                drink.typeDrink,
                                                            'quantity':
                                                                drink.ml,
                                                            'time':
                                                                selectedTime!,
                                                          }
                                                        ])
                                                      }).then((value) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                                'Drink added'),
                                                            duration: Duration(
                                                                seconds: 2),
                                                          ),
                                                        );
                                                        formKey.currentState!
                                                            .reset();
                                                        selectedTime = null;
                                                        Navigator.pop(context);
                                                      }).catchError((error) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                                'Failed to add drink'),
                                                            duration: Duration(
                                                                seconds: 2),
                                                          ),
                                                        );
                                                      });
                                                    }
                                                  }
                                                },
                                                child: Text(
                                                  'Add',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: firstColor,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Row(
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
                  return Center(child: CircularProgressIndicator());
                }
              },
            );
          } else {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        });
  }
}
