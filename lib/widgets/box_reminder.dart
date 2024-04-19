import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_mobile/utils/colors.dart';

class BoxReminder extends StatelessWidget {
  final String title;
  final String des;
  final String time;
  final VoidCallback onDelete;

  const BoxReminder(
      {super.key,
      required this.title,
      required this.des,
      required this.time,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 38),
      child: Container(
        width: 352,
        height: 130,
        decoration: const BoxDecoration(
          border: Border.fromBorderSide(BorderSide(
            color: Colors.white,
            width: 1,
            style: BorderStyle.solid,
          )),
          borderRadius: BorderRadius.all(Radius.circular(24)),
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
        child: Padding(
          padding: const EdgeInsets.only(right: 20, left: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$title',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$des',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: thirdColor),
                  ),
                  IconButton(
                      onPressed: onDelete,
                      icon:const Icon(
                        Icons.delete_forever,
                        color: Colors.red,
                        size: 30,
                      ))
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.alarm,
                    color: secondColor,
                    size: 30,
                  ),
                  const SizedBox(
                    width: 11,
                  ),
                  Text(
                    '$time',
                    style: const TextStyle(
                        fontSize: 24,
                        color: fourColor,
                        fontWeight: FontWeight.bold),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
