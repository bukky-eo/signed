import 'package:flutter/material.dart';
import 'package:signed/screen/student/signup_screen.dart';

class WebScreen extends StatefulWidget {
  const WebScreen({Key? key}) : super(key: key);

  @override
  State<WebScreen> createState() => _WebScreenState();
}

class _WebScreenState extends State<WebScreen> {
  @override
  Widget build(BuildContext context) {
    return const SignUpScreen();
  }
}
