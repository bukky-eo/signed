import 'package:flutter/material.dart';
import 'package:signed/methods/auth_methods.dart';
import 'package:signed/helpers/constants.dart';
import 'package:signed/screen/teacher/home_screen.dart';
import 'package:signed/screen/teacher/signup_screen.dart';
import '../../helpers/widgets.dart';

class TeacherLogin extends StatefulWidget {
  const TeacherLogin({Key? key}) : super(key: key);

  @override
  State<TeacherLogin> createState() => _TeacherLoginState();
}

class _TeacherLoginState extends State<TeacherLogin> {
  bool _isLoading = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthMethods _authHelper = AuthMethods();
  // DatabaseHelper _databaseHelper = DatabaseHelper();

  void login() {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      _authHelper
          .loginUser(_emailController.text, _passwordController.text)
          .then((value) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return const TeacherHomePage();
        }));
      }).catchError((e) {
        setState(() {
          _isLoading = false;
        });
        SnackBar snackBar = SnackBar(content: Text(e.code));

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      SnackBar snackBar = const SnackBar(
          content: Text("Something went wrong please try again later!"));

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                        Form(
                          key: formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'L O G I N',
                                style: TextStyle(
                                    fontSize: 25, color: Color(0xff38AD57)),
                              ),
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
                            ],
                          ),
                        ),
                        LinearButton(
                          title: 'Login',
                          onTap: login,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text("Don't have an account?"),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const TeacherSignUp()));
                                },
                                child: const Text(
                                  'Register',
                                  style: TextStyle(color: Color(0xff38AD57)),
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
