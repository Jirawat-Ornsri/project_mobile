import 'dart:ffi';

class Profile{
  String username;
  String email;
  String password;
  String imageBase64;
  String height;
  int weight;
  String gender;

  Profile({
    required this.username,
    required this.email,
    required this.password,
    required this.imageBase64,
    required this.height,
    required this.weight,
    required this.gender,
  });
}