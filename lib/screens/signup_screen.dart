import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_field/image_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_mobile/models/profile.dart';
import 'package:project_mobile/screens/login_screen.dart';
import 'package:project_mobile/screens/mobile_screen.dart';
import 'package:project_mobile/utils/colors.dart';
import 'package:project_mobile/utils/pickImage.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // pick image
  Uint8List? _image;

  // form validation
  final formKey = GlobalKey<FormState>();

  // get porfile model
  Profile profile =
      Profile(username: '', email: '', password: '', imageUrl: '');

  // connect firebase
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  // function select image
  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          // if have error show error on screen
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
          // if connect success
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
                      height: 60,
                    ),

                    Form(
                        key: formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              // ***** profile pic *****
                              // ImageField(),
                              
                              Stack(
                                children: [
                                  _image != null
                                      ? CircleAvatar(
                                          backgroundImage: MemoryImage(_image!),
                                          radius: 74.5,
                                        )
                                      : const CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              'data:image/png;base64,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'),
                                          radius: 74.5,
                                        ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: thirdColor, // สีพื้นหลัง
                                        shape:
                                            BoxShape.circle, // กำหนดให้เป็นวงกบ
                                      ),
                                      padding: const EdgeInsets.all(
                                          1), // ขนาดขอบวงกบ
                                      child: IconButton(
                                        icon: const Icon(Icons.add_a_photo),
                                        color: firstColor, // สีไอคอน
                                        onPressed: () {
                                          selectImage();
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              ),

                              const SizedBox(
                                height: 60,
                              ),

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
                                            msg: "created account success.",
                                            gravity: ToastGravity.TOP,
                                            backgroundColor: firstColor,
                                          );

                                          // go to HomeScreen
                                          Navigator.pushReplacement(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return MobileScreen();
                                          }));
                                        });
                                      } on FirebaseAuthException catch (e) {
                                        print(e.code);
                                        String? message;
                                        if (e.code == 'email-already-in-use') {
                                          message =
                                              "This email is already. Please use another email.";
                                        } else if (e.code == 'weak-password') {
                                          message =
                                              "Password must be 6 or more charecters long.";
                                        } else {
                                          message = e.message;
                                        }
                                        Fluttertoast.showToast(
                                          msg: message!,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb:
                                              5, // ระยะเวลาในการแสดง toast สำหรับ iOS และ web
                                        );
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
