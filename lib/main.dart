import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:project_mobile/screens/login_screen.dart';

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
        storageBucket: 'wherewaterlogin.appspot.com'
      ),
    );
  } else {
    await Firebase.initializeApp();
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
      home: LoginScreen(),
    );
  }
}
  