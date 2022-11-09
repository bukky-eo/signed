import 'package:flutter/material.dart';

import '../../helpers/widgets.dart';
import '../../responsive/student/mobile_screen.dart';
import '../../responsive/responsive.dart';
import '../../responsive/student/web_screen.dart';
import '../../responsive/teacher/mobile_screen.dart';
import '../../responsive/teacher/web_screen.dart';

class Select extends StatelessWidget {
  const Select({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'images/logos.jpg',
              height: screenHeight / 2,
            ),
            const SizedBox(height: 35),
            LinearButton(
              title: 'Student',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Responsive(
                            mobileScreen: MobileScreen(),
                            desktopScreen: WebScreen())));
              },
            ),
            const SizedBox(height: 25),
            LinearButton(
                title: 'Teacher',
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Responsive(
                              mobileScreen: TeacherMobileScreen(),
                              desktopScreen: TeacherWebScreen())));
                })
          ],
        ),
      ),
    );
  }
}
