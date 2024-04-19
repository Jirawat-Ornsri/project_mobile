import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:project_mobile/models/drink.dart';
import 'package:project_mobile/models/profile.dart';
import 'package:project_mobile/models/reminder.dart';
import 'package:project_mobile/utils/colors.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final auth = FirebaseAuth.instance;

  // connect firebase
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  // get current user
  final user = FirebaseAuth.instance.currentUser;

  // get profile model
  Profile profile = Profile(
    username: '',
    email: '',
    password: '',
    photoUrl: '',
    height: '',
    weight: 0,
    gender: '',
    reminders: [],
    drinks: [],
  );

  // form validation
  final formKey = GlobalKey<FormState>();

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

  // สร้างตัวแปร newPhotoUrl สำหรับเก็บ URL ของรูปใหม่
  String newPhotoUrl = '';

  // radio groupValue
  String? groupValue;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user?.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.exists) {
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;
                  profile = Profile(
                    username: data['username'] ?? '',
                    email: data['email'] ?? '',
                    password: data['password'] ?? '',
                    photoUrl: data['photoUrl'] ?? '',
                    height: data['height'] ?? '',
                    weight: data['weight'] ?? 0,
                    gender: data['gender'] ?? '',
                    reminders: List.from(data['reminders'] ?? [])
                        .map((e) => Reminder(
                              title: e['title'] ?? '',
                              des: e['description'] ?? '',
                              time: (e['time'] as Timestamp?)?.toDate() ??
                                  DateTime.now(),
                            ))
                        .toList(),
                    drinks: List.from(data['drinks'] ?? [])
                        .map((e) => Drink(
                              typeDrink: e['typeDrink'] ?? '',
                              ml: e['quantity'] ?? '',
                              time: (e['time'] as Timestamp?)?.toDate() ??
                                  DateTime.now(),
                              percen: 0,
                            ))
                        .toList(),
                  );

                  return Scaffold(
                    appBar: PreferredSize(
                      preferredSize: const Size.fromHeight(
                          kToolbarHeight), // กำหนดความสูงของ AppBar
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal:
                                16.0), // เพิ่ม padding ด้านซ้ายและด้านขวาของ AppBar
                        child: AppBar(
                          title: const Text(
                            'Edit Profile',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: fourColor),
                          ),
                          centerTitle: true,
                          leading: IconButton(
                            icon: const Icon(Icons.arrow_back_ios),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    ),
                    body: SingleChildScrollView(
                      child: Form(
                        key: formKey,
                        child: Center(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 40,
                              ),

                              // --- profile ---
                              Stack(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        newPhotoUrl.isNotEmpty
                                            ? newPhotoUrl
                                            : profile.photoUrl),
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
                                                          newPhotoUrl = imageUrls[
                                                              index]; // เก็บ URL รูปใหม่
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
                              // -- input form --
                              Container(
                                width: 430,
                                height: 521.25,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  color: fourColor,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(24),
                                    topRight: Radius.circular(24),
                                  ),
                                ),
                                child: SingleChildScrollView(
                                  child: Container(
                                    width: 276,
                                    child: Column(
                                      children: [
                                        // input user name
                                        const SizedBox(
                                          height: 40,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Username',
                                              style: TextStyle(
                                                  color: firstColor,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            TextFormField(
                                              maxLength: 10,
                                              validator: RequiredValidator(
                                                  errorText:
                                                      "input your username."),
                                              onSaved: (String? username) {
                                                profile.username = username!;
                                              },
                                              obscureText: false,
                                              initialValue: profile.username,
                                              decoration: InputDecoration(
                                                hintText: 'Input Username',
                                                counterText: '',
                                                filled: true,
                                                fillColor: firstColor,
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          14), // เพิ่มความโค้งของ border
                                                  borderSide: const BorderSide(
                                                      color: firstColor,
                                                      width:
                                                          2.0), // เปลี่ยนสีเส้นขอบ
                                                ),
                                                // *** on focus ***
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                  borderSide: const BorderSide(
                                                      color: firstColor,
                                                      width:
                                                          2.0), // เส้นขอบเมื่อได้รับการ focus
                                                ),
                                                // *** on enable ***
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                  borderSide: const BorderSide(
                                                      color: firstColor,
                                                      width:
                                                          2.0), // เส้นขอบเมื่อไม่ได้รับการ focus
                                                ),
                                                prefixIcon: const Icon(
                                                  Icons.person,
                                                  color: thirdColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        // input height
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text('Height',
                                                style: TextStyle(
                                                    color: firstColor,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextFormField(
                                              maxLength: 3,
                                              validator: MultiValidator([
                                                RequiredValidator(
                                                    errorText:
                                                        'input your height.'),
                                                PatternValidator(r'^[0-9]+$',
                                                    errorText:
                                                        'input only numbers'),
                                              ]),
                                              onSaved: (String? height) {
                                                profile.height = height!;
                                              },
                                              obscureText: false,
                                              initialValue: profile.height,
                                              decoration: InputDecoration(
                                                hintText: 'Input Height',
                                                counterText: '',
                                                filled: true,
                                                fillColor: firstColor,
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          14), // เพิ่มความโค้งของ border
                                                  borderSide: const BorderSide(
                                                      color: firstColor,
                                                      width:
                                                          2.0), // เปลี่ยนสีเส้นขอบ
                                                ),
                                                // *** on focus ***
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                  borderSide: const BorderSide(
                                                      color: firstColor,
                                                      width:
                                                          2.0), // เส้นขอบเมื่อได้รับการ focus
                                                ),
                                                // *** on enable ***
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                  borderSide: const BorderSide(
                                                      color: firstColor,
                                                      width:
                                                          2.0), // เส้นขอบเมื่อไม่ได้รับการ focus
                                                ),
                                                prefixIcon: const Icon(
                                                  Icons.accessibility,
                                                  color: thirdColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        // input weight
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text('Weight',
                                                style: TextStyle(
                                                    color: firstColor,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextFormField(
                                              maxLength: 3,
                                              validator: MultiValidator([
                                                RequiredValidator(
                                                     errorText:
                                                        'input your weight.'),
                                                PatternValidator(r'^[0-9]+$',
                                                    errorText:
                                                        'input only numbers'),
                                              ]),
                                              onSaved: (String? weight) {
                                                profile.weight =
                                                    int.parse(weight!);
                                              },
                                              initialValue:
                                                  profile.weight.toString(),
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                hintText: 'Input Weight',
                                                counterText: '',
                                                filled: true,
                                                fillColor: firstColor,
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          14), // เพิ่มความโค้งของ border
                                                  borderSide: const BorderSide(
                                                      color: firstColor,
                                                      width:
                                                          2.0), // เปลี่ยนสีเส้นขอบ
                                                ),
                                                // *** on focus ***
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                  borderSide: const BorderSide(
                                                      color: firstColor,
                                                      width:
                                                          2.0), // เส้นขอบเมื่อได้รับการ focus
                                                ),
                                                // *** on enable ***
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                  borderSide: const BorderSide(
                                                      color: firstColor,
                                                      width:
                                                          2.0), // เส้นขอบเมื่อไม่ได้รับการ focus
                                                ),
                                                prefixIcon: const Icon(
                                                  Icons.fitness_center,
                                                  color: thirdColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        // input gender
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text('Gender',
                                                style: TextStyle(
                                                    color: firstColor,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold)),
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
                                                      fontWeight:
                                                          FontWeight.normal,
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
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: secondColor),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),

                                        // update button
                                        const SizedBox(
                                          height: 35,
                                        ),
                                        ElevatedButton(
                                            style: ButtonStyle(
                                              fixedSize:
                                                  MaterialStateProperty.all(
                                                      Size.fromHeight(30)),
                                            ),
                                            onPressed: () {
                                              // ตรวจสอบว่าผู้ใช้เลือก gender หรือไม่
                                              if (groupValue == null) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: const Text(
                                                        'Please select gender'),
                                                    backgroundColor: Colors.red,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  ),
                                                );
                                                return; // ย้อนกลับไปไม่ทำอัปเดต
                                              } else {
                                                if (formKey.currentState!
                                                    .validate()) {
                                                  formKey.currentState!.save();

                                                  // สร้าง DocumentReference สำหรับเอกสารของผู้ใช้ปัจจุบัน
                                                  DocumentReference<
                                                          Map<String, dynamic>>
                                                      docRef = FirebaseFirestore
                                                          .instance
                                                          .collection('users')
                                                          .doc(user?.uid);

                                                  // อัปเดตข้อมูล
                                                  docRef.update({
                                                    'photoUrl':
                                                        newPhotoUrl.isNotEmpty
                                                            ? newPhotoUrl
                                                            : profile.photoUrl,
                                                    'username':
                                                        profile.username,
                                                    'height': profile.height,
                                                    'weight': profile.weight,
                                                    'gender': groupValue,
                                                  }).then((value) {
                                                    // หลังจากอัปเดตสำเร็จ แสดง SnackBar แจ้งเตือนว่าอัปเดตสำเร็จ
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: const Text(
                                                            'Update successful'),
                                                        backgroundColor:
                                                            Colors.green,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                      ),
                                                    );

                                                    // go to profile
                                                    Navigator.pop(context);
                                                  }).catchError((error) {
                                                    // หากเกิดข้อผิดพลาดในการอัปเดต แสดง SnackBar แจ้งเตือน
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                            'Failed to update: $error'),
                                                        backgroundColor:
                                                            Colors.red,
                                                      ),
                                                    );
                                                  });
                                                }
                                              }
                                            },
                                            child: const Text(
                                              'Update',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: fourColor),
                                            )),
                                        const SizedBox(
                                          height: 30,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            );
          } else {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        });
  }
}
