import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:project_mobile/utils/colors.dart';

class BoxInfo extends StatelessWidget {
  final String text;
  final String data;
  final String unit;
  final IconData icon;
  const BoxInfo(
      {super.key, required this.text, required this.data, required this.unit, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: firstColor,
        borderRadius: BorderRadius.circular(24), // เพิ่ม border radius ที่นี่
        border:
            Border.all(color: firstColor), // เพิ่ม border อื่น ๆ ตามต้องการ
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(icon, size: 24,),
              Text('$text', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: fourColor),)
            ],
          ),
          Text('$data $unit', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: secondColor),)
        ],
      ),
    );
  }
}
