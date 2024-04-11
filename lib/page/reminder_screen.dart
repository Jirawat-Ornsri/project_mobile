import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
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

  // get reminder model
  Reminder reminder = Reminder(title: '', des: '', time: null);

  Profile profile = Profile(
      username: '',
      email: '',
      password: '',
      imageBase64: '',
      height: '',
      weight: 0,
      gender: '',
      reminders: []);

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
                    imageBase64: data['imageBase64'] ?? '',
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
                                            content: Text('Reminder deleted'),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      }).catchError((error) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
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
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Form(
                                      key: formKey,
                                      child: AlertDialog(
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextFormField(
                                              validator: RequiredValidator(
                                                  errorText: "input title."),
                                              decoration: InputDecoration(
                                                hintText: 'Title',
                                              ),
                                              onSaved: (String? title) {
                                                reminder.title = title!;
                                              },
                                            ),
                                            TextFormField(
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
                                              title: Text(selectedTime != null
                                                  ? '${DateFormat('HH:mm').format(selectedTime!)}'
                                                  : 'Select Time'),
                                              trailing: Icon(Icons.access_time),
                                              onTap: () async {
                                                final TimeOfDay? pickedTime =
                                                    await showTimePicker(
                                                  context: context,
                                                  initialTime:
                                                      TimeOfDay.fromDateTime(
                                                          selectedTime ??
                                                              DateTime.now()),
                                                );
                                                if (pickedTime != null) {
                                                  setState(() {
                                                    selectedTime =
                                                        DateTime.now();
                                                    selectedTime = DateTime(
                                                      selectedTime!.year,
                                                      selectedTime!.month,
                                                      selectedTime!.day,
                                                      pickedTime.hour,
                                                      pickedTime.minute,
                                                    );
                                                  });
                                                }
                                              },
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
                                                      MaterialStateProperty.all<
                                                          Color>(fourColor),
                                                ),
                                                onPressed: () {
                                                  final user = FirebaseAuth
                                                      .instance.currentUser;
                                                  if (formKey.currentState!
                                                      .validate()) {
                                                    formKey.currentState!
                                                        .save();
                                                    if (selectedTime != null) {
                                                      setState(() {
                                                        profile.reminders
                                                            .add(Reminder(
                                                          title: reminder.title,
                                                          des: reminder.des,
                                                          time: selectedTime!,
                                                        ));
                                                      });
                                                      FirebaseFirestore.instance
                                                          .collection('users')
                                                          .doc(user?.uid)
                                                          .update({
                                                        'reminders': FieldValue
                                                            .arrayUnion([
                                                          {
                                                            'title':
                                                                reminder.title,
                                                            'description':
                                                                reminder.des,
                                                            'time':
                                                                selectedTime!,
                                                          }
                                                        ])
                                                      }).then((value) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                                'Reminder added'),
                                                            duration: Duration(
                                                                seconds: 2),
                                                          ),
                                                        );
                                                        formKey.currentState!
                                                            .reset();
                                                        selectedTime = null;
                                                        Navigator.pop(context);
                                                      }).catchError((error) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                                'Failed to add reminder'),
                                                            duration: Duration(
                                                                seconds: 2),
                                                          ),
                                                        );
                                                      });
                                                    }
                                                  }
                                                },
                                                child: Text(
                                                  'Add',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
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
                              child: Row(
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
                  return Center(child: CircularProgressIndicator());
                }
              },
            );
          } else {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        });
  }
}
