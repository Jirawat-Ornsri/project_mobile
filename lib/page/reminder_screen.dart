import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:project_mobile/models/profile.dart';
import 'package:project_mobile/models/reminder.dart';
import 'package:project_mobile/utils/colors.dart';
import 'package:project_mobile/widgets/box_reminder.dart';
import 'package:intl/intl.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  // form validation
  final formKey = GlobalKey<FormState>();

  DateTime? selectedTime;
  TimeOfDay time = TimeOfDay.now();

  // get reminder model
  Reminder reminder = Reminder(title: '', des: '', time: null);

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
      drinks: []);

  // connect firebase
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  // get current user
  final user = FirebaseAuth.instance.currentUser;

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
                    drinks: [],
                  );
                  return Scaffold(
                      body: SafeArea(
                          child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 53,
                        ),

                        // *** title reminder ***
                        Container(
                          alignment: Alignment.center,
                          child: const Text(
                            'Reminders',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: fourColor),
                          ),
                        ),

                        const SizedBox(
                          height: 35,
                        ),

                        // *** reminder items ***
                        Container(
                          height: 550,
                          alignment: Alignment.topCenter,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                for (var reminder in profile.reminders)
                                  BoxReminder(
                                    title: reminder.title,
                                    des: reminder.des,
                                    time: DateFormat('HH:mm')
                                        .format(reminder.time!),
                                    // remove reminder
                                    onDelete: () {
                                      setState(() {
                                        profile.reminders.remove(reminder);
                                      });
                                      FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(user?.uid)
                                          .update({
                                        'reminders': FieldValue.arrayRemove([
                                          {
                                            'title': reminder.title,
                                            'description': reminder.des,
                                            'time': reminder.time,
                                          }
                                        ])
                                      }).then((value) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content:
                                                const Text('Reminder deleted'),
                                            duration:
                                                const Duration(seconds: 2),
                                            backgroundColor: Colors.red,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        );
                                      }).catchError((error) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Failed to delete reminder'),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      });
                                    },
                                  ),
                                const SizedBox(
                                  height: 20,
                                )
                              ],
                            ),
                          ),
                        ),

                        // *** add reminder button ***
                        Container(
                          width: 188,
                          height: 42,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          thirdColor)),
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return StatefulBuilder(
                                      builder: (context, setState) {
                                        return Form(
                                          key: formKey,
                                          child: AlertDialog(
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextFormField(
                                                  maxLength: 20,
                                                  validator: RequiredValidator(
                                                      errorText:
                                                          "input title."),
                                                  decoration: InputDecoration(
                                                    hintText: 'Title',
                                                  ),
                                                  onSaved: (String? title) {
                                                    reminder.title = title!;
                                                  },
                                                ),
                                                TextFormField(
                                                  maxLength: 30,
                                                  validator: RequiredValidator(
                                                      errorText:
                                                          "input description."),
                                                  decoration: InputDecoration(
                                                    hintText: 'Description',
                                                  ),
                                                  onSaved: (String? des) {
                                                    reminder.des = des!;
                                                  },
                                                ),
                                                ListTile(
                                                  onTap: () async {
                                                    TimeOfDay? newTime =
                                                        await showTimePicker(
                                                      context: context,
                                                      initialTime:
                                                          TimeOfDay.now(),
                                                    );

                                                    if (newTime == null) return;
                                                    setState(() {
                                                      time = newTime;
                                                    });

                                                    if (newTime != null) {
                                                      setState(() {
                                                        selectedTime =
                                                            DateTime.now();
                                                        selectedTime = DateTime(
                                                          selectedTime!.year,
                                                          selectedTime!.month,
                                                          selectedTime!.day,
                                                          newTime.hour,
                                                          newTime.minute,
                                                        );
                                                      });
                                                    }
                                                  },
                                                  title: Text(time.format(
                                                      context)), // Display the selected time here
                                                  trailing:
                                                      Icon(Icons.access_time),
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              Align(
                                                alignment: Alignment.center,
                                                child: Container(
                                                  width: 86,
                                                  height: 28,
                                                  child: ElevatedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all<Color>(
                                                                  fourColor),
                                                    ),
                                                    onPressed: () {
                                                      final user = FirebaseAuth
                                                          .instance.currentUser;
                                                      if (formKey.currentState!
                                                          .validate()) {
                                                        formKey.currentState!
                                                            .save();
                                                        if (selectedTime !=
                                                            null) {
                                                          setState(() {
                                                            profile.reminders
                                                                .add(Reminder(
                                                              title: reminder
                                                                  .title,
                                                              des: reminder.des,
                                                              time:
                                                                  selectedTime!,
                                                            ));
                                                          });
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'users')
                                                              .doc(user?.uid)
                                                              .update({
                                                            'reminders':
                                                                FieldValue
                                                                    .arrayUnion([
                                                              {
                                                                'title':
                                                                    reminder
                                                                        .title,
                                                                'description':
                                                                    reminder
                                                                        .des,
                                                                'time':
                                                                    selectedTime!,
                                                              }
                                                            ])
                                                          }).then((value) {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                content: const Text(
                                                                    'Reminder added'),
                                                                duration:
                                                                    const Duration(
                                                                        seconds:
                                                                            2),
                                                                backgroundColor:
                                                                    Colors
                                                                        .green,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                              ),
                                                            );
                                                            formKey
                                                                .currentState!
                                                                .reset();
                                                            selectedTime = null;
                                                            Navigator.pop(
                                                                context);
                                                          }).catchError(
                                                                  (error) {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              const SnackBar(
                                                                content: Text(
                                                                    'Failed to add reminder'),
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            2),
                                                              ),
                                                            );
                                                          });
                                                        }
                                                      }
                                                    },
                                                    child: const Text(
                                                      'Add',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: firstColor,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Add Reminder',
                                    style: TextStyle(
                                        color: firstColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Icon(
                                    Icons.add_alarm,
                                    color: secondColor,
                                    size: 24,
                                  )
                                ],
                              )),
                        ),
                      ],
                    ),
                  )));
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
