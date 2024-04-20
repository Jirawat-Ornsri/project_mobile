import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:project_mobile/models/profile.dart';
import 'package:project_mobile/screens/login_screen.dart';
import 'package:project_mobile/screens/mobile_screen.dart';
import 'package:project_mobile/utils/colors.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // form validation
  final formKey = GlobalKey<FormState>();

  // get porfile model
  Profile profile = Profile(
      username: '',
      email: '',
      password: '',
      photoUrl: '',
      height: '',
      weight: 0,
      gender: '',
      reminders: [],
      drinks: []);

  // connect firebase
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  // image list picker
  List<String> imageUrls = [
    'https://image-cdn.hypb.st/https%3A%2F%2Fhypebeast.com%2Fimage%2F2021%2F10%2Fbored-ape-yacht-club-nft-3-4-million-record-sothebys-metaverse-1.jpg?cbr=1&q=90',
    'https://cdn.prod.www.spiegel.de/images/d2caafb1-70da-47e2-ba48-efd66565cde1_w1024_r0.9975262832405689_fpx44.98_fpy48.86.jpg',
    'https://i.nextmedia.com.au/Utils/ImageResizer.ashx?n=https%3A%2F%2Fi.nextmedia.com.au%2FNews%2Fbored_ape.png&w=480&c=0&s=1',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTwYBf4zImnvPVSdEVVWdqaMc4WLZk_iguxT7nAcGydropJpkUXb434xDJ9pEZtONCboG8&usqp=CAU',
    'https://i.guim.co.uk/img/media/ef8492feb3715ed4de705727d9f513c168a8b196/37_0_1125_675/master/1125.jpg?width=465&dpr=1&s=none',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSG_91tH8JiWpOQmYPWYa01MXwfJEdGMdsmDkDbONVbGOYGiUMxwXhsDCtbsSMO_ARcUAo&usqp=CAU',
    'https://forbes.com.br/wp-content/uploads/2022/04/bored.jpg',
    'https://comoinvestir.thecap.com.br/medias/2022/01/vendas-de-nfts-do-bored-ape-yacht-club-ultrapassam-us-1-bilhao.webp',
    'https://classic.exame.com/wp-content/uploads/2021/12/BAYCcortado.png',
  ];

  // get gender
  String? groupValue;

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
                              Stack(
                                children: [
                                  profile.photoUrl.isNotEmpty
                                      ? CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(profile.photoUrl),
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
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Container(
                                                height: 250,
                                                child: GridView.builder(
                                                  gridDelegate:
                                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 3,
                                                  ),
                                                  itemCount: imageUrls.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          profile.photoUrl =
                                                              imageUrls[index];
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                      child: Image.network(
                                                        imageUrls[index],
                                                        fit: BoxFit.cover,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          );
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
                                        Icons.accessibility,
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Gender',
                                        style: TextStyle(
                                            color: thirdColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    Row(
                                      children: [
                                        // male
                                        Radio<String>(
                                          activeColor: secondColor,
                                          value: 'Male',
                                          groupValue: groupValue,
                                          onChanged: (value) {
                                            setState(() {
                                              groupValue = value;
                                              profile.gender =
                                                  value!; // อัปเดตค่า gender ในโมเดล Profile
                                            });
                                          },
                                        ),
                                        const Text(
                                          'Male',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                              color: secondColor),
                                        ),

                                        // female
                                        Radio<String>(
                                          activeColor: secondColor,
                                          value: 'Female',
                                          groupValue: groupValue,
                                          onChanged: (value) {
                                            setState(() {
                                              groupValue = value;
                                              profile.gender =
                                                  value!; // อัปเดตค่า gender ในโมเดล Profile
                                            });
                                          },
                                        ),
                                        const Text(
                                          'Female',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                              color: secondColor),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Container(
                              //   width: 267,
                              //   child: TextFormField(
                              //     maxLength: 10,
                              //     validator: RequiredValidator(
                              //         errorText: "input your gender."),
                              //     onSaved: (String? gender) {
                              //       profile.gender = gender!;
                              //     },
                              //     obscureText: false,
                              //     decoration: InputDecoration(
                              //         counterText: '',
                              //         filled: true,
                              //         fillColor: firstColor,
                              //         border: OutlineInputBorder(
                              //           borderRadius: BorderRadius.circular(
                              //               14), // เพิ่มความโค้งของ border
                              //           borderSide: const BorderSide(
                              //               color: firstColor,
                              //               width: 2.0), // เปลี่ยนสีเส้นขอบ
                              //         ),
                              //         // *** on focus ***
                              //         focusedBorder: OutlineInputBorder(
                              //           borderRadius: BorderRadius.circular(14),
                              //           borderSide: const BorderSide(
                              //               color: secondColor,
                              //               width:
                              //                   2.0), // เส้นขอบเมื่อได้รับการ focus
                              //         ),
                              //         // *** on enable ***
                              //         enabledBorder: OutlineInputBorder(
                              //           borderRadius: BorderRadius.circular(14),
                              //           borderSide: const BorderSide(
                              //               color: firstColor,
                              //               width:
                              //                   2.0), // เส้นขอบเมื่อไม่ได้รับการ focus
                              //         ),
                              //         prefixIcon: const Icon(
                              //           Icons.transgender_sharp,
                              //           color: thirdColor,
                              //         ),
                              //         labelText: 'Gender',
                              //         labelStyle:
                              //             const TextStyle(color: secondColor)),
                              //   ),
                              // ),

                              const SizedBox(
                                height: 86,
                              ),

                              // ***** Sign up button *****
                              Container(
                                width: 267,
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
                                    // แสดงข้อความแจ้งเตือนเมื่อไม่มีการเลือก profile
                                    if (profile.photoUrl.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Please select image profile'),
                                          backgroundColor: Colors
                                              .red, // สีพื้นหลังของ SnackBar
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      );
                                      // แสดงข้อความแจ้งเตือนเมื่อไม่มีการเลือก gender
                                    } else if (groupValue == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text('Please select gender'),
                                          backgroundColor: Colors
                                              .red, // สีพื้นหลังของ SnackBar
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      );
                                    } else {
                                      if (formKey.currentState!.validate()) {
                                        // save input TextFormField
                                        formKey.currentState!.save();
                                        try {
                                          // ทำการสร้าง User ด้วย email และ password
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
                                              'password': profile.password,
                                              'height': profile.height,
                                              'weight': profile.weight,
                                              'gender': profile.gender,
                                              'reminders': [],
                                              'drinks': [],
                                              'photoUrl': profile.photoUrl,
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
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: const Text(
                                                    'account created successfully!!'),
                                                duration: const Duration(seconds: 2),
                                                backgroundColor: Colors.green,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            );

                                            // go to User info scre
                                            Navigator.pushReplacement(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return MobileScreen();
                                            }));
                                          });
                                          // ถ้าเกิดข้อผิดพลาด
                                        } on FirebaseAuthException catch (e) {
                                          //print(e.code);
                                          String? message;
                                          // ถ้ามี email ซ้ำให้ส่งแจ้งเตือน
                                          if (e.code ==
                                              'email-already-in-use') {
                                            message =
                                                "This email is already. Please use another email.";
                                            // ถ้า password ต่ำกว่า 6 ตัวส่งแจ้งเตือน
                                          } else if (e.code ==
                                              'weak-password') {
                                            message =
                                                "Password must be 6 or more charecters long.";
                                          } else {
                                            message = e.message;
                                          }
                                          // แจ้งเตือน
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(message!),
                                              duration: const Duration(seconds: 2),
                                              backgroundColor: Colors.red,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          );
                                        }
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
