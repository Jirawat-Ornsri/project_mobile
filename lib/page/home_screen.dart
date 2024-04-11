import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_mobile/utils/colors.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text("No data"));
          }

          // ดึงข้อมูลชื่อผู้ใช้จาก snapshot
          final username = snapshot.data!.get('username');
          

          return Column(
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
                      backgroundImage: NetworkImage('https://zultimate.com/wp-content/uploads/2019/12/default-profile.png'),
                      radius: 28,
                    )
                  ],
                ),
              ),

              // *** part circle water ***
              // *** part show drink ***
              // *** part add drink button ***
            ],
          );
        },
      ),
    );
  }
}
