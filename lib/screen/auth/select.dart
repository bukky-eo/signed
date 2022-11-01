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
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
      ),
    );
  }
}
