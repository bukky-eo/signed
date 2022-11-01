import 'package:flutter/material.dart';

import '../../screen/teacher/signup_screen.dart';

class TeacherMobileScreen extends StatefulWidget {
  const TeacherMobileScreen({Key? key}) : super(key: key);

  @override
  State<TeacherMobileScreen> createState() => _TeacherMobileScreenState();
}

class _TeacherMobileScreenState extends State<TeacherMobileScreen> {
  @override
  Widget build(BuildContext context) {
    return const TeacherSignUp();
  }
}
