import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:project_mobile/screens/login_screen.dart';
import 'package:project_mobile/utils/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final auth = FirebaseAuth.instance;

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

          return Column(
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
                        width: 36,
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
                Container(
                  margin: const EdgeInsets.only(left: 48, right: 48, top: 75),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircleAvatar(backgroundColor: thirdColor, radius: 50,),
                      Text('$username'),
                      ElevatedButton(
                          onPressed: () {}, child: const Text('Edit Profile')),
                    ],
                  ),
                )
              ],
            );
          
        },
      ),
    );
  }
}
