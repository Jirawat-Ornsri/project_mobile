import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:project_mobile/screens/login_screen.dart';
import 'package:project_mobile/screens/mobile_screen.dart';
import 'package:project_mobile/utils/colors.dart';
import 'firebase_options.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialise app based on platform- web or mobile
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDcZSGnyVzCdnu9OwXLp-u5p-vcDFYrU4A",
        appId: "1:1032883481959:web:dd346ef580467c856753c2",
        messagingSenderId: "1032883481959",
        projectId: "wherewaterlogin",
        storageBucket: 'wherewaterlogin.appspot.com',
        measurementId: "G-ZQWC14M0R7"

      ),
    );
  } else {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // check user login ถ้า login อยู่แล้วให้ไปหน้า MobileScreen
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return MobileScreen();
            
            // check ถ้าเกิดข้อผิดพลาดให้แสดง error
            } else if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            }
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: thirdColor,
              ),
            );
          }
      
          return const LoginScreen();
        },
      ),
    );
  }
}
  