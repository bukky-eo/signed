import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:signed/main.dart';
import 'package:signed/methods/auth_methods.dart';
import 'package:signed/screen/student/qr_scan.dart';

import 'device_info.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({Key? key}) : super(key: key);

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  // DatabaseHelper _databaseHelper = DatabaseHelper();
  final AuthMethods _authHelper = AuthMethods();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () {
                  _authHelper.signOut();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: ((context) => const Signed())),
                  );
                },
                icon: const Icon(Icons.logout, color: Colors.white))
          ],
          backgroundColor: const Color(0xff38AD57),
          title: Text('Welcome ${FirebaseAuth.instance.currentUser!.email}'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Give Attendance'),
              Tab(text: 'History'),
            ],
          ),
        ),
        body: TabBarView(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: (() => Navigator.of(context).push(
                      MaterialPageRoute(builder: ((context) => const QRScan())),
                    )),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                  const Color(0xff38AD57),
                )),
                child: const Text('Scan QR Code'),
              ),
              ElevatedButton(
                onPressed: (() => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: ((context) => const Devices())),
                    )),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                  const Color(0xff38AD57),
                )),
                child: const Text('Device IMEI'),
              )
            ],
          ),
          Container(),
        ]),
      ),
    );
  }
}
