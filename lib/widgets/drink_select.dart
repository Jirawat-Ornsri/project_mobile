import 'package:flutter/material.dart';
import 'package:project_mobile/utils/colors.dart';

class DrinkSelect extends StatelessWidget {
  final String iconPath;
  final String nameDrink;
  final int? percen;

  const DrinkSelect(
      {super.key,
      required this.iconPath,
      required this.nameDrink,
      required this.percen});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        border: Border.fromBorderSide(BorderSide(
          color: Colors.white,
          width: 1,
          style: BorderStyle.solid,
        )),
        borderRadius: BorderRadius.all(Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 204, 204, 204),
            offset: Offset(0, 1),
            blurRadius: 10.0,
            spreadRadius: 2.0,
          ),
          BoxShadow(
            color: Colors.white,
            offset: Offset(0.0, 0.0),
            blurRadius: 0.0,
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            iconPath,
            width: 30, // กำหนดความกว้างของรูปภาพ
            height: 30, // กำหนดความสูงของรูปภาพ
            fit: BoxFit.cover, // กำหนดวิธีการแสดงรูปภาพในกรอบ
          ),
          Text(
            nameDrink,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: fourColor),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.water_drop_rounded,
                color: secondColor,
                size: 14,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                '$percen %',
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: secondColor),
              ),
            ],
          )
        ],
      ),
    );
  }
}
