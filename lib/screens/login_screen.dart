import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:project_mobile/models/profile.dart';
import 'package:project_mobile/screens/mobile_screen.dart';
import 'package:project_mobile/screens/signup_screen.dart';
import 'package:project_mobile/utils/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  Profile profile = Profile(username: '', email: '', password: '', imageBase64: '', height: '', weight: 0, gender: '', reminders: [], drinks: []);

  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          // can't connect to firebase
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Error"),
              ),
              body: Center(
                child: Text("${snapshot.error}"),
              ),
            );
          }
          // connect to firebase success
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        
                        const SizedBox(height: 180,),
                  
                        //  ***** title ********
                        const Text(
                          'SIGN IN',
                          style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: fourColor),
                        ),
                  
                        const SizedBox(
                          height: 90,
                        ),
                  
                        Form(
                            key: formKey,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  // ***** email field ******
                                  Container(
                                    width: 267,
                                    child: TextFormField(
                                      validator: MultiValidator([
                                        RequiredValidator(
                                            errorText: "input your email."),
                                        EmailValidator(
                                            errorText: "email incorrect.")
                                      ]),
                                      keyboardType: TextInputType.emailAddress,
                                      onSaved: (String? email) {
                                        profile.email = email!;
                                      },
                                      obscureText: false,
                                      decoration: InputDecoration(
                                          filled: true,
                                          fillColor: firstColor,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                14), // เพิ่มความโค้งของ border
                                            borderSide: const BorderSide(
                                                color: firstColor,
                                                width: 2.0), // เปลี่ยนสีเส้นขอบ
                                          ),
                                          // *** on focus ***
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(14),
                                            borderSide: const BorderSide(
                                                color: secondColor,
                                                width:
                                                    2.0), // เส้นขอบเมื่อได้รับการ focus
                                          ),
                                          // *** on enable ***
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(14),
                                            borderSide: const BorderSide(
                                                color: firstColor,
                                                width:
                                                    2.0), // เส้นขอบเมื่อไม่ได้รับการ focus
                                          ),
                                          prefixIcon: const Icon(
                                            Icons.email,
                                            color: thirdColor,
                                          ),
                                          labelText: 'Email',
                                          labelStyle:
                                              const TextStyle(color: secondColor)),
                                    ),
                                  ),
                  
                                  const SizedBox(
                                    height: 35,
                                  ),
                  
                                  // ***** password field ******
                                  Container(
                                    width: 267,
                                    child: TextFormField(
                                      validator: RequiredValidator(
                                          errorText: "input your password."),
                                      onSaved: (String? password) {
                                        profile.password = password!;
                                      },
                                      obscureText: true,
                                      decoration: InputDecoration(
                                          filled: true,
                                          fillColor: firstColor,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                14), // เพิ่มความโค้งของ border
                                            borderSide: const BorderSide(
                                                color: firstColor,
                                                width: 2.0), // เปลี่ยนสีเส้นขอบ
                                          ),
                                          // *** on focus ***
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(14),
                                            borderSide: const BorderSide(
                                                color: secondColor,
                                                width:
                                                    2.0), // เส้นขอบเมื่อได้รับการ focus
                                          ),
                                          // *** on enable ***
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(14),
                                            borderSide: const BorderSide(
                                                color: firstColor,
                                                width:
                                                    2.0), // เส้นขอบเมื่อไม่ได้รับการ focus
                                          ),
                                          prefixIcon: const Icon(
                                            Icons.lock,
                                            color: thirdColor,
                                          ),
                                          labelText: 'Password',
                                          labelStyle:
                                              const TextStyle(color: secondColor)),
                                    ),
                                  ),
                  
                                  const SizedBox(
                                    height: 86,
                                  ),
                  
                                  // ***** Login button *****
                                  Container(
                                    width: 276,
                                    height: 45,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                fourColor), // เพิ่มสีพื้นหลัง
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                14), // เพิ่มความโค้งของ border
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        'LOGIN',
                                        style: TextStyle(
                                            color: secondColor,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16),
                                      ),
                                      onPressed: () async {
                                        if (formKey.currentState!.validate()) {
                                          formKey.currentState!.save();
                                          try {
                                            await FirebaseAuth.instance
                                                .signInWithEmailAndPassword(
                                                    email: profile.email,
                                                    password: profile.password)
                                                // when login success
                                                .then((value) {
                  
                                              // reset form field
                                              formKey.currentState!.reset();
                  
                                              // go to HomeScreen
                                              Navigator.pushReplacement(context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return MobileScreen();
                                              }));
                                            });
                                          } on FirebaseAuthException catch (e) {
                                            print(e.message);
                                            String? txt;
                                            if (e.message ==
                                                'The supplied auth credential is incorrect, malformed or has expired.') {
                                              txt = 'Email or password Incorrect.';
                                            } else {
                                              txt = e.message!;
                                            }
                                            Fluttertoast.showToast(
                                                msg: txt,
                                                gravity: ToastGravity.TOP);
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            )),

                        const SizedBox(height: 140,),
                  
                        // ***** go to sign up screen *****
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account?",
                              style: TextStyle(fontSize: 13),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) {
                                    return SignupScreen();
                                  }));
                                },
                                child: const Text(
                                  'Sign up.',
                                  style: TextStyle(fontSize: 13, color: fourColor),
                                ))
                          ],
                        ),
                  
                        const SizedBox(
                          height: 25,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
