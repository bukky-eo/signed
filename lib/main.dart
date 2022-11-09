import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:signed/screen/auth/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Signed());
}

class Signed extends StatelessWidget {
  const Signed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
