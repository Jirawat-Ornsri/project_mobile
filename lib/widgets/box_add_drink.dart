import 'package:flutter/material.dart';
import 'package:project_mobile/utils/colors.dart';

class BoxDrink extends StatelessWidget {
  final String typeDrink;
  final String time;
  final int ml;

  const BoxDrink({
    super.key,
    required this.typeDrink,
    required this.time,
    required this.ml,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Container(
        width: 364,
        height: 70,
        decoration: BoxDecoration(
          color: firstColor,
          borderRadius:
              BorderRadius.circular(18), // เพิ่ม border radius ที่คุณต้องการ
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Row(
                  children: [
                    //icon type drink
                    const Icon(
                      Icons.water_drop_rounded,
                      size: 30,
                      color: secondColor,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$typeDrink',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: thirdColor),
                          ),
                          Text(
                            '$time',
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: fourColor),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Text(
                '$ml ml',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: thirdColor),
              )
            ],
          ),
        ),
      ),
    );
  }
}
