import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:signed/methods/auth_methods.dart';
import 'package:signed/screen/teacher/home_screen.dart';
import 'package:signed/screen/teacher/login_screen.dart';

import '../../helpers/constants.dart';
import '../../helpers/widgets.dart';
import '../../methods/storage_methods.dart';

class TeacherSignUp extends StatefulWidget {
  const TeacherSignUp({Key? key}) : super(key: key);

  @override
  State<TeacherSignUp> createState() => _TeacherSignUpState();
}

class _TeacherSignUpState extends State<TeacherSignUp> {
  bool _isLoading = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthMethods _authHelper = AuthMethods();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  void signUpTeacher() {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      _authHelper
          .signUpUser(_emailController.text, _passwordController.text)
          .then((value) {
        if (value != null) {
          Map<String, String> teacherData = {
            'name': _nameController.text,
            'email': _emailController.text,
          };

          User? user = FirebaseAuth.instance.currentUser;

          _databaseHelper.uploadTeacherInfo(user!.uid, teacherData);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: ((context) => const TeacherHomePage())),
          );
        } else {
          setState(() {
            _isLoading = false;
          });
          SnackBar snackBar =
              const SnackBar(content: Text("Teacher Already Exists"));

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }).catchError((e) {
        setState(() {
          _isLoading = false;
        });
        SnackBar snackBar = SnackBar(content: Text(e));

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            body: Center(
              child: SizedBox(
                width: isWeb ? screenWidth / 4 : screenWidth / 1.2,
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'S I G N U P',
                              style: TextStyle(
                                  fontSize: 25, color: Color(0xff38AD57)),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            InputField(
                                hintText: 'Name', controller: _nameController),
                            const SizedBox(
                              height: 25,
                            ),
                            InputField(
                                hintText: 'E-mail',
                                controller: _emailController),
                            const SizedBox(
                              height: 25,
                            ),
                            InputField(
                                hintText: 'Password',
                                controller: _passwordController),
                            const SizedBox(
                              height: 25,
                            ),
                            LinearButton(
                              title: 'Signup',
                              onTap: () {},
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text("Already have an account?"),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const TeacherLogin()));
                                },
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                      color: Color(0xff38AD57), fontSize: 15),
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
