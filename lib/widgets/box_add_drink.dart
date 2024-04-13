import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:project_mobile/utils/colors.dart';

class BoxDrink extends StatelessWidget {
  final String typeDrink;
  final String time;
  final int ml;

  const BoxDrink(
      {super.key,
      required this.typeDrink,
      required this.time,
      required this.ml});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Container(
        width: 364,
        height: 70,
        decoration: BoxDecoration(
          color: firstColor, // สีพื้นหลัง
          borderRadius:
              BorderRadius.circular(18), // ความโค้งของมุม (border radius)
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Row(
                  children: [
                    Icon(Icons.water_drop_outlined, size: 30, color: fourColor,),
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('$typeDrink', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: thirdColor),),
                          Text('$time', style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: fourColor),)
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Text('$ml ml', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: thirdColor),)
            ],
          ),
        ),
      ),
    );
  }
}
