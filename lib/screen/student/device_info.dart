import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import '../../main.dart';
import '../../methods/auth_methods.dart';

// import 'package:flutter/foundation.dart';

class Devices extends StatefulWidget {
  const Devices({Key? key}) : super(key: key);

  @override
  State<Devices> createState() => _DevicesState();
}

class _DevicesState extends State<Devices> {
  final AuthMethods _authHelper = AuthMethods();
  String text = '';
  String subString = '';
  String secString = '';
  String deviceInfoOne = '';
  String deviceInfoTwo = '';

  void loadInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      setState(() {
        text = iosDeviceInfo.toString();
      });
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      setState(() {
        text = androidDeviceInfo.id.toString();
        subString = androidDeviceInfo.model.toString();
        secString = androidDeviceInfo.manufacturer.toString();
        deviceInfoOne = androidDeviceInfo.type.toString();
        deviceInfoTwo = androidDeviceInfo.device.toString();
      });
    }
  }

  @override
  void initState() {
    loadInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff38AD57),
        automaticallyImplyLeading: false,
        title: Text('Welcome ${FirebaseAuth.instance.currentUser!.email}'),
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
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 25,
            ),
            Text(
              'Device IMEI: $text',
              style: const TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              'Device model: $subString',
              style: const TextStyle(fontSize: 24, color: Colors.black),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              'Device product: $secString',
              style: const TextStyle(fontSize: 24, color: Colors.black),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              'Device type: $deviceInfoOne',
              style: const TextStyle(fontSize: 24, color: Colors.black),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              'Device model: $deviceInfoTwo',
              style: const TextStyle(fontSize: 24, color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
