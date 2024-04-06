import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project_mobile/screens/login_screen.dart';
import 'package:project_mobile/utils/box_info.dart';
import 'package:project_mobile/utils/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final auth = FirebaseAuth.instance;

  // fn calculate weight
  double waterCal(int weight) {
    double result;
    result = ((weight / 2) * 2.2 * 30) / 1000;
    return double.parse(result.toStringAsFixed(1));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(auth.currentUser?.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: Text('No data'),
            );
          }

          // ดึงข้อมูลชื่อผู้ใช้จาก snapshot
          final username = snapshot.data!.get('username');
          final email = snapshot.data!.get('email');
          final height = snapshot.data!.get('height');
          final weight = snapshot.data!.get('weight');
          final gender = snapshot.data!.get('gender');


          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 53,
                  ),
              
                  //  *** part title profile ***
                  Container(
                    margin: const EdgeInsets.only(left: 48, right: 48),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        const SizedBox(
                          width: 50,
                          height: 24,
                        ),
              
                        // text title
                        const Text(
                          'Profile',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: fourColor),
                        ),
              
                        // logout button
                        IconButton(
                            onPressed: () {
                              auth.signOut().then((value) {
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const LoginScreen();
                                }));
                              });
                            },
                            icon: const Icon(
                              Icons.logout,
                              size: 24,
                            )),
                      ],
                    ),
                  ),
              
                  // *** part profile picture ***
                  Stack(
                    children: [
                      Container(
                        width: 334,
                        height: 200,
                        margin: const EdgeInsets.only(left: 48, right: 48, top: 75),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.white,
                              width: 1,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(
                              24), // เพิ่ม border radius ที่คุณต้องการ
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
                      ),
                      const Positioned(
                        top: 20,
                        left: 0,
                        right: 0,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: CircleAvatar(
                            backgroundColor: thirdColor,
                            radius: 50,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 30,
                        left: 0,
                        right: 0,
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '$username',
                                style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: fourColor),
                              ),
                              const SizedBox(
                                height: 37,
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                child: const Text(
                                  'Edit Profile',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: firstColor),
                                ),
                                style: ButtonStyle(
                                    fixedSize: MaterialStateProperty.all<Size>(
                                        Size.fromHeight(33)),
                                    backgroundColor:
                                        MaterialStatePropertyAll<Color>(fourColor),
                                    shape: MaterialStatePropertyAll<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(18),
                                            side: BorderSide(width: 1)))),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
              
                  // *** part show email ***
                  Container(
                    width: 334,
                    height: 71,
                    margin: const EdgeInsets.only(left: 48, right: 48, top: 25),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.white, width: 1, style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(
                          24), // เพิ่ม border radius ที่คุณต้องการ
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(
                          Icons.email_outlined,
                          size: 30,
                          color: fourColor,
                        ),
                        Text('$email', style: const TextStyle(fontSize: 16, color: thirdColor, fontWeight: FontWeight.w700),)
                      ],
                    ),
                  ),
              
                  // *** part Info row 1 ***
                  Container(
                    margin: EdgeInsets.only(right: 48, left: 48, top: 27),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BoxInfo(text: 'Height', data: '$height', unit: 'cm', icon: Icons.person,),
                        BoxInfo(text: 'Weight', data: '$weight', unit: 'kg', icon: Icons.fitness_center,)
                      ],
                    ),
                  ),
              
                  // *** part Info row 2 ***
                  Container(
                    margin: EdgeInsets.only(right: 48, left: 48, top: 27),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BoxInfo(text: 'Gender', data: '$gender', unit: '', icon: Icons.transgender,),
                        BoxInfo(text: 'Daily', data: '${waterCal(weight)}', unit: 'lt', icon: Icons.water_drop,),
                      ],
                    ),
                  ),
            
                  const SizedBox(height: 30,)
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
