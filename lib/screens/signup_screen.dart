import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:project_mobile/models/profile.dart';
import 'package:project_mobile/screens/home_screen.dart';
import 'package:project_mobile/screens/login_screen.dart';
import 'package:project_mobile/utils/colors.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final formKey = GlobalKey<FormState>();
  Profile profile = Profile(username: '', email: '', password: '');

  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
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
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              body: Center(
                child: Column(
                  children: [
                    Flexible(
                      flex: 2,
                      child: Container(),
                    ),

                    //  ***** title ********
                    const Text(
                      'SIGN UP',
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
                              // ***** username field ******
                              Container(
                                width: 267,
                                child: TextFormField(
                                  validator: RequiredValidator(
                                      errorText: "input your username."),
                                  onSaved: (String? username) {
                                    profile.username = username!;
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
                                        Icons.person,
                                        color: thirdColor,
                                      ),
                                      labelText: 'Username',
                                      labelStyle:
                                          const TextStyle(color: secondColor)),
                                ),
                              ),

                              const SizedBox(
                                height: 35,
                              ),

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

                              // ***** Sign up button *****
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
                                    'SIGN UP',
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
                                            .createUserWithEmailAndPassword(
                                                email: profile.email,
                                                password: profile.password)
                                            
                                            // when created account success
                                            .then((value) async {
                                          // สร้างโครงสร้างข้อมูลที่ต้องการเก็บลงใน Firestore
                                          Map<String, dynamic> userData = {
                                            'username': profile.username,
                                            'email': profile.email,
                                            // เพิ่มข้อมูลเพิ่มเติมตามต้องการ
                                          };

                                          // สร้าง reference ไปยังเอกสารของผู้ใช้งานใหม่ใน Firestore
                                          final userReference =
                                              FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(value.user!.uid);

                                          // ทำการเขียนข้อมูลลงใน Firestore
                                          await userReference.set(userData);

                                          // reset form field
                                          formKey.currentState!.reset();

                                          // alert message
                                          Fluttertoast.showToast(
                                              msg:
                                                  "สร้างบัญชีผู้ใช้เรียบร้อยแล้ว",
                                              gravity: ToastGravity.TOP);

                                          // go to HomeScreen 
                                          Navigator.pushReplacement(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return HomeScreen();
                                          }));
                                        });
                                      } on FirebaseAuthException catch (e) {
                                        print(e.code);
                                        String? message;
                                        if (e.code == 'email-already-in-use') {
                                          message =
                                              "มีอีเมลนี้ในระบบแล้วครับ โปรดใช้อีเมลอื่นแทน";
                                        } else if (e.code == 'weak-password') {
                                          message =
                                              "รหัสผ่านต้องมีความยาว 6 ตัวอักษรขึ้นไป";
                                        } else {
                                          message = e.message;
                                        }
                                        Fluttertoast.showToast(
                                            msg: message!,
                                            gravity: ToastGravity.CENTER);
                                      }
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        )),

                    Flexible(
                      flex: 2,
                      child: Container(),
                    ),

                    // ***** go to login screen *****
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "have an account?",
                          style: TextStyle(fontSize: 13),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) {
                                return LoginScreen();
                              }));
                            },
                            child: const Text(
                              'Sign in.',
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
