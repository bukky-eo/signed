import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:signed/methods/auth_methods.dart';
import 'package:signed/screen/student/home_screen.dart';
import '../../helpers/constants.dart';
import '../../helpers/widgets.dart';
import 'package:signed/screen/student/login_screen.dart';
import '../../methods/storage_methods.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _regNoController = TextEditingController();
  final AuthMethods _authHelper = AuthMethods();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  void signUpStudent() {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      _authHelper
          .signUpUser(_emailController.text, _passwordController.text)
          .then((value) async {
        if (value != null) {
          Map<String, String> studentData = {
            'name': _nameController.text,
            'email': _emailController.text,
            'rollNo': _regNoController.text,
          };

          User? user = FirebaseAuth.instance.currentUser;

          await _databaseHelper.uploadStudentInfo(user!.uid, studentData);

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: ((context) => const StudentHomePage())),
          );
        } else {
          setState(() {
            isLoading = false;
          });
          SnackBar snackBar =
              const SnackBar(content: Text("Student Already Exists"));

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }).catchError((e) {
        setState(() {
          isLoading = false;
        });
        SnackBar snackBar = SnackBar(content: Text(e.message));

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _regNoController.dispose();
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
                          'S I G N U P',
                          style:
                              TextStyle(fontSize: 25, color: Color(0xff38AD57)),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        TextField(
                          obscureText: false,
                          controller: _regNoController,
                          decoration: InputDecoration(
                            fillColor: Colors.white70,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            hintStyle: TextStyle(
                                fontSize: 15, color: Colors.grey[800]),
                            prefixIcon: Icon(Icons.person),
                            hintText: 'Reg.No',
                          ),
                        ),
                        // InputField(
                        //     hintText: 'Reg.No', controller: _regNoController),
                        const SizedBox(
                          height: 25,
                        ),
                        TextField(
                          obscureText: false,
                          controller: _nameController,
                          decoration: InputDecoration(
                            fillColor: Colors.white70,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            hintStyle: TextStyle(
                                fontSize: 15, color: Colors.grey[800]),
                            prefixIcon: Icon(Icons.person),
                            hintText: 'Name',
                          ),
                        ),
                        // InputField(
                        //     hintText: 'Name', controller: _nameController),
                        const SizedBox(
                          height: 25,
                        ),

                        TextField(
                          obscureText: false,
                          controller: _emailController,
                          decoration: InputDecoration(
                            fillColor: Colors.white70,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            hintStyle: TextStyle(
                                fontSize: 15, color: Colors.grey[800]),
                            prefixIcon: Icon(Icons.mail),
                            hintText: 'E-mail',
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        TextField(
                          obscureText: true,
                          controller: _passwordController,
                          decoration: InputDecoration(
                            fillColor: Colors.white70,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            hintStyle: TextStyle(
                                fontSize: 15, color: Colors.grey[800]),
                            prefixIcon: Icon(Icons.password),
                            hintText: 'Password',
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                      ],
                    ),
                  ),
                  LinearButton(
                    title: 'Signup',
                    onTap: signUpStudent,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      TextButton(
                          onPressed: () {
                            print(_emailController.text +
                                _passwordController.text);
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
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
