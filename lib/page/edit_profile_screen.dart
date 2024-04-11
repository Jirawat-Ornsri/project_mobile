import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_mobile/page/profile_screen.dart';
import 'package:project_mobile/utils/colors.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight), // กำหนดความสูงของ AppBar
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0), // เพิ่ม padding ด้านซ้ายและด้านขวาของ AppBar
          child: AppBar(
            title: Text('Edit Profile', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: fourColor),),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: Center(
        child: Text("Edit Profile Screen"),
      ),
    );
  }
}
