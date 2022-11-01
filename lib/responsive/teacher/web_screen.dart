import 'package:flutter/material.dart';
import '../../screen/teacher/signup_screen.dart';

class TeacherWebScreen extends StatefulWidget {
  const TeacherWebScreen({Key? key}) : super(key: key);

  @override
  State<TeacherWebScreen> createState() => _TeacherWebScreenState();
}

class _TeacherWebScreenState extends State<TeacherWebScreen> {
  @override
  Widget build(BuildContext context) {
    return const TeacherSignUp();
  }
}
