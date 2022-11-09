import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:signed/main.dart';
import 'package:signed/methods/auth_methods.dart';
import 'package:signed/screen/teacher/section_view.dart';

import '../../methods/storage_methods.dart';

class TeacherHomePage extends StatefulWidget {
  const TeacherHomePage({Key? key}) : super(key: key);

  @override
  State<TeacherHomePage> createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  bool _isLoading = false;
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  late Stream<QuerySnapshot> sectionsStream;

  final TextEditingController _nameEditingController = TextEditingController();
  final AuthMethods _authHelper = AuthMethods();

  void loadAllSections() async {
    _databaseHelper
        .searchSectionForTeacher(FirebaseAuth.instance.currentUser?.email)
        .then((val) => {
              setState(() {
                sectionsStream = val;
                _isLoading = false;
              })
            });
  }

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });

    loadAllSections();
  }

  Widget sectionsList() {
    return StreamBuilder<QuerySnapshot>(
        stream: sectionsStream,
        builder: ((context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: ((context, index) {
                    return InkWell(
                        onTap: (() {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: ((context) => SectionView(
                                    sectionName: snapshot.data!.docs[index].id,
                                  ))));
                        }),
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 3.0, horizontal: 8.0),
                            child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                color: const Color(0xff2BB7DA),
                                child: SizedBox(
                                    width: double.infinity,
                                    height: 80.0,
                                    child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                snapshot.data!.docs[index].id,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ]))))));
                  }))
              : const Center(
                  child: Text('No Sections found. Click + to add section'));
        }));
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: const Color(0xff2BB7DA),
              title:
                  Text('Welcome ${FirebaseAuth.instance.currentUser!.email}'),
              actions: [
                IconButton(
                    onPressed: () {
                      _authHelper.signOut();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: ((context) => const Signed())),
                      );
                    },
                    icon: const Icon(Icons.logout, color: Colors.white))
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  sectionsList(),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: const Color(0xff2BB7DA),
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return SingleChildScrollView(
                        child: Center(
                          child: Column(children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text('Create Section'),
                            ),
                            TextField(
                              controller: _nameEditingController,
                              decoration: const InputDecoration(
                                icon: Icon(Icons.receipt),
                                labelText: 'Enter section name',
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Map<String, String> sectionInfo = {
                                  'sectionName': _nameEditingController.text,
                                  'teacherEmail':
                                      FirebaseAuth.instance.currentUser!.email!,
                                };

                                _databaseHelper.createSection(
                                    _nameEditingController.text, sectionInfo);
                                Navigator.pop(context);
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.green),
                              ),
                              child: const Text('Done!'),
                            ),
                          ]),
                        ),
                      );
                    });
              },
              child: const Icon(Icons.add),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
