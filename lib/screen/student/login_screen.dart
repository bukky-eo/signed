import 'package:flutter/material.dart';
import 'package:signed/helpers/constants.dart';
import 'package:signed/helpers/widgets.dart';
import 'package:signed/methods/auth_methods.dart';
import 'package:signed/screen/student/signup_screen.dart';
import 'package:signed/screen/student/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthMethods _authHelper = AuthMethods();
  // DatabaseHelper _databaseHelper = DatabaseHelper();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
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
                          style:
                              TextStyle(fontSize: 25, color: Color(0xff38AD57)),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        InputField(
                            hintText: 'E-mail', controller: _emailController),
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
                    onTap: _login,
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
                                        const SignUpScreen()));
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

  void _login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      _authHelper
          .loginUser(_emailController.text, _passwordController.text)
          .then((value) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return const StudentHomePage();
        }));
      }).catchError((e) {
        setState(() {
          isLoading = false;
        });
        SnackBar snackBar = SnackBar(content: Text(e.code));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    } else {
      setState(() {
        isLoading = false;
      });
      SnackBar snackBar = const SnackBar(
          content: Text('Something went wrong please try again'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
