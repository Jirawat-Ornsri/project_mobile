import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project_mobile/models/drink.dart';
import 'package:project_mobile/models/profile.dart';
import 'package:project_mobile/utils/colors.dart';
import 'package:project_mobile/widgets/box_add_drink.dart';
import 'package:project_mobile/widgets/drink_select.dart';

class AddDrinkScreen extends StatefulWidget {
  const AddDrinkScreen({Key? key}) : super(key: key);

  @override
  State<AddDrinkScreen> createState() => _AddDrinkScreenState();
}

class _AddDrinkScreenState extends State<AddDrinkScreen> {
  // connect firebase
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  // get porfile model
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

  // get drink model
  Drink drink = Drink(typeDrink: '', ml: 0, time: null, percen: 0);

  // drink list select
  List<Widget> drinkLists = [
    const DrinkSelect(
      iconPath: 'assets/glass-of-water.png',
      nameDrink: 'Water',
      percen: 100,
    ),
    const DrinkSelect(
      iconPath: 'assets/coconut-drink.png',
      nameDrink: 'Coconut',
      percen: 85,
    ),
    const DrinkSelect(
      iconPath: 'assets/coffee-cup.png',
      nameDrink: 'Coffee',
      percen: 80,
    ),
    const DrinkSelect(
      iconPath: 'assets/hot-chocolate.png',
      nameDrink: 'Chocolate',
      percen: 40,
    ),
    const DrinkSelect(
      iconPath: 'assets/lemonade.png',
      nameDrink: 'Lemonade',
      percen: 70,
    ),
    const DrinkSelect(
      iconPath: 'assets/milk.png',
      nameDrink: 'Milk',
      percen: 78,
    ),
    const DrinkSelect(
      iconPath: 'assets/orange-juice.png',
      nameDrink: 'Juice',
      percen: 55,
    ),
    const DrinkSelect(
      iconPath: 'assets/protein.png',
      nameDrink: 'Protein',
      percen: 30,
    ),
    const DrinkSelect(
      iconPath: 'assets/smoothie.png',
      nameDrink: 'Smoothie',
      percen: 33,
    ),
    const DrinkSelect(
      iconPath: 'assets/soda-bottle.png',
      nameDrink: 'Soda',
      percen: 60,
    ),
    const DrinkSelect(
      iconPath: 'assets/tea.png',
      nameDrink: 'Tea',
      percen: 85,
    ),
    const DrinkSelect(
      iconPath: 'assets/yogurt.png',
      nameDrink: 'Yogurt',
      percen: 50,
    ),
  ];

  // select value water (ml)
  var selectedValue = 0;
  
  // function calucate quantity type of drink
  int calQuantity(ml, persen) {
    double quantity = 0;
    quantity = ml * (persen / 100);
    return quantity.toInt();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          // if have error show error on screen
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Error"),
              ),
              body: Center(
                child: Text("${snapshot.error}"),
              ),
            );
          }
          // if connect success
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: PreferredSize(
                preferredSize:
                    Size.fromHeight(kToolbarHeight), // กำหนดความสูงของ AppBar
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal:
                          16.0), // เพิ่ม padding ด้านซ้ายและด้านขวาของ AppBar
                  child: AppBar(
                    title: const Text(
                      'Select Drink',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: fourColor),
                    ),
                    centerTitle: true,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),

                    // selec drink grid
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 16, // ระยะห่างระหว่างแถว
                          crossAxisSpacing: 16, // ระยะห่างระหว่างคอลัมน์
                        ),
                        itemCount: drinkLists.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                
                                drink.typeDrink =
                                    (drinkLists[index] as DrinkSelect)
                                        .nameDrink;

                                drink.percen =
                                    (drinkLists[index] as DrinkSelect).percen!;
                              });
                            },
                            // show item in list
                            child: drinkLists[index],
                          );
                        },
                      ),
                    ),

                    // Add slide to select numeric value
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(drink.typeDrink, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: thirdColor),),
                        const SizedBox(height: 8,),

                        // Display selected numeric value
                        Text(
                          'Selected Quantity: ${selectedValue} ml',
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: fourColor),
                        ),

                        // Slider to select numeric value
                        Container(
                          alignment: Alignment.center,
                          width: 270,
                          child: SliderTheme(
                            data: const SliderThemeData(
                              trackHeight:
                                  15, // Increase track height for visual width
                            ),
                            child: Slider(
                              value: selectedValue.toDouble(),
                              min: 0,
                              max: 600,
                              divisions: 601,
                              activeColor: secondColor,
                              onChanged: (newValue) {
                                setState(() {
                                  selectedValue = newValue.round();
                                  drink.ml = selectedValue;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),

                    // add drink button
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: 150,
                      height: 42,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(thirdColor)),
                          onPressed: () {
                            // get current user
                            final user = FirebaseAuth.instance.currentUser;
                            if (drink.typeDrink.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Please Select Drink'),
                                  duration: const Duration(seconds: 2),
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                              // ถ้า user ไม่เลือก water quantity ให้ส่งแจ้งเตือน
                            } else if (selectedValue == 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Please Select Quantity Water'),
                                  duration: const Duration(seconds: 2),
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            } else {
                              setState(() {
                                // calcucate type of drink water quantity
                                drink.ml = calQuantity(drink.ml, drink.percen);

                                profile.drinks.add(Drink(
                                    typeDrink: drink.typeDrink,
                                    ml: drink.ml,
                                    time: drink.time = DateTime.now(),
                                    percen: drink.percen));
                              });

                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user?.uid)
                                  .update({
                                'drinks': FieldValue.arrayUnion([
                                  {
                                    'typeDrink': drink.typeDrink,
                                    'quantity': drink.ml,
                                    'time': drink.time,
                                    'percen': drink.percen
                                  }
                                ])
                              }).then((value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Drink added'),
                                    duration: const Duration(seconds: 2),
                                    backgroundColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                );

                                // back to home screen
                                Navigator.pop(context);
                              }).catchError((error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Failed to add drink'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              });
                            }
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Add Drink',
                                style: TextStyle(
                                    color: firstColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              Icon(
                                Icons.add,
                                color: secondColor,
                                size: 18,
                              )
                            ],
                          )),
                    ),

                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            );
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
