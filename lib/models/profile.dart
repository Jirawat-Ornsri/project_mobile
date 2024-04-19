
import 'package:project_mobile/models/drink.dart';
import 'package:project_mobile/models/reminder.dart';

class Profile{
  String username;
  String email;
  String password;
  String photoUrl;
  String height;
  int weight;
  String gender;
  List<Reminder> reminders;
  List<Drink> drinks;

  Profile({
    required this.username,
    required this.email,
    required this.password,
    required this.photoUrl,
    required this.height,
    required this.weight,
    required this.gender,
    required this.reminders,
    required this.drinks,
  });
}