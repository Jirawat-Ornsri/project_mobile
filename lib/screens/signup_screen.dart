import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  Profile profile = Profile(
      username: '',
      email: '',
      password: '',
      imageBase64: '',
      height: '',
      weight: 0,
      gender: '', 
      reminders: [], drinks: []
    );

  // connect firebase
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  // function select image
  void selectImage() async {
    Uint8List? im = await pickImage(ImageSource.gallery);

    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ImageFile -> Bytes -> String (Base64) -> FirebaseFirestore
    // Firestore -> String -> Bytes -> Image Widget

    // {
    //  id:
    // name:
    // imageBase64: String
    // }
    // Widget image = CircleAvatar();

    // if (_image != null) {
    //   image = CircleAvatar(backgroundImage: MemoryImage(_image!),);
    // }

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
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 45,
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
                                              'https://zultimate.com/wp-content/uploads/2019/12/default-profile.png'),
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
                                  maxLength: 10,
                                  validator: RequiredValidator(
                                      errorText: "input your username."),
                                  onSaved: (String? username) {
                                    profile.username = username!;
                                  },
                                  obscureText: false,
                                  decoration: InputDecoration(
                                      counterText: '',
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
                                height: 35,
                              ),

                              // ***** height field ******
                              Container(
                                width: 267,
                                child: TextFormField(
                                  maxLength: 3,
                                  validator: MultiValidator([
                                    RequiredValidator(
                                        errorText: 'input your height.'),
                                    PatternValidator(r'^[0-9]+$',
                                        errorText: 'input only numbers'),
                                  ]),
                                  onSaved: (String? height) {
                                    profile.height = height!;
                                  },
                                  obscureText: false,
                                  decoration: InputDecoration(
                                      counterText: '',
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
                                        Icons.animation,
                                        color: thirdColor,
                                      ),
                                      labelText: 'Height',
                                      labelStyle:
                                          const TextStyle(color: secondColor)),
                                ),
                              ),

                              const SizedBox(
                                height: 35,
                              ),

                              // ***** weight field ******
                              Container(
                                width: 267,
                                child: TextFormField(
                                  maxLength: 3,
                                  validator: MultiValidator([
                                    RequiredValidator(
                                        errorText: 'input your weight.'),
                                    PatternValidator(r'^[0-9]+$',
                                        errorText: 'input only numbers'),
                                  ]),
                                  onSaved: (String? weight) {
                                    profile.weight = int.parse(weight!);
                                  },
                                  obscureText: false,
                                  decoration: InputDecoration(
                                      counterText: '',
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
                                        Icons.fitness_center,
                                        color: thirdColor,
                                      ),
                                      labelText: 'Weight',
                                      labelStyle:
                                          const TextStyle(color: secondColor)),
                                ),
                              ),

                              const SizedBox(
                                height: 35,
                              ),

                              // ***** gender field ******
                              Container(
                                width: 267,
                                child: TextFormField(
                                  maxLength: 10,
                                  validator: RequiredValidator(
                                      errorText: "input your gender."),
                                  onSaved: (String? gender) {
                                    profile.gender = gender!;
                                  },
                                  obscureText: false,
                                  decoration: InputDecoration(
                                      counterText: '',
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
                                        Icons.transgender_sharp,
                                        color: thirdColor,
                                      ),
                                      labelText: 'Gender',
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
                                            'height': profile.height,
                                            'weight': profile.weight,
                                            'gender': profile.gender,
                                            'reminders': [],
                                            'drinks': [],
                                            'photoUrl': null,

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

                                          // go to User info scre
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
                                          gravity: ToastGravity.TOP,
                                          timeInSecForIosWeb:
                                              5, // ระยะเวลาในการแสดง toast สำหรับ iOS และ web
                                        );
                                      }
                                    }
                                  },
                                ),
                              ),
                            ],
                          )),

                      const SizedBox(
                        height: 30,
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
                                style:
                                    TextStyle(fontSize: 13, color: fourColor),
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
