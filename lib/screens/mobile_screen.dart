import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:project_mobile/page/home_screen.dart';
import 'package:project_mobile/page/map_screen.dart';
import 'package:project_mobile/page/profile_screen.dart';
import 'package:project_mobile/page/reminder_screen.dart';
import 'package:project_mobile/page/static_screen.dart';
import 'package:project_mobile/utils/colors.dart';

class MobileScreen extends StatefulWidget {
  const MobileScreen({super.key});

  @override
  State<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  void NavigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          HomeScreen(),
          StaticScreen(),
          MapScreen(),
          ReminderScreen(),
          ProfileScreen(),
        ],
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: Container(
          height: 80,
          child: CupertinoTabBar(
            backgroundColor: fourColor,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home,
                      color: _page == 0 ? secondColor : thirdColor),
                  label: '',
                  backgroundColor: thirdColor),
              BottomNavigationBarItem(
                  icon: Icon(Icons.bar_chart,
                      color: _page == 1 ? secondColor : thirdColor),
                  label: '',
                  backgroundColor: thirdColor),
              BottomNavigationBarItem(
                  icon: Icon(Icons.map,
                      color: _page == 2 ? secondColor : thirdColor),
                  label: '',
                  backgroundColor: thirdColor),
              BottomNavigationBarItem(
                  icon: Icon(Icons.alarm,
                      color: _page == 3 ? secondColor : thirdColor),
                  label: '',
                  backgroundColor: thirdColor),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person,
                      color: _page == 4 ? secondColor : thirdColor),
                  label: '',
                  backgroundColor: thirdColor),
            ],
            onTap: NavigationTapped,
          ),
        ),
      ),
    );
  }
}
