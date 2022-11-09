import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../methods/storage_methods.dart';

class StudentListView extends StatefulWidget {
  final String sectionName;
  const StudentListView({Key? key, required this.sectionName})
      : super(key: key);

  @override
  State<StudentListView> createState() => _StudentListViewState();
}

class _StudentListViewState extends State<StudentListView> {
  bool _isLoading = false;
  late Stream<QuerySnapshot> _studentsStream;
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _rollNoEditingController =
      TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();

  void _loadStudentData() {
    _databaseHelper.getStudentsforSection(widget.sectionName).then((val) {
      setState(() {
        _isLoading = false;
        _studentsStream = val;
      });
    });
  }

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    _loadStudentData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              title: Text('Students of ${widget.sectionName}'),
              backgroundColor: const Color(0xff2BB7DA),
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: _studentsStream,
              builder: (context, snapshot) {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: ((context, index) {
                      return InkWell(
                          onTap: null,
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 3.0, horizontal: 8.0),
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  color: Colors.amber,
                                  child: SizedBox(
                                      width: double.infinity,
                                      height: 80.0,
                                      child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  snapshot.data!.docs[index].id,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  snapshot.data!.docs[index]
                                                      ['studentName'],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                IconButton(
                                                    onPressed: () {
                                                      _databaseHelper
                                                          .deleteStudentfromSection(
                                                              widget
                                                                  .sectionName,
                                                              snapshot
                                                                  .data!
                                                                  .docs[index]
                                                                  .id);
                                                    },
                                                    icon: const Icon(
                                                      Icons.delete,
                                                      color: Colors.white,
                                                    ))
                                              ]))))));
                    }));
              },
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                'Add Student',
                                style: TextStyle(
                                    color: Color(0xff2BB7DA), fontSize: 20),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: TextField(
                                controller: _nameEditingController,
                                decoration: const InputDecoration(
                                    icon: Icon(Icons.portrait),
                                    labelText: 'Enter student name',
                                    hintText: 'Name'),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: TextField(
                                controller: _rollNoEditingController,
                                decoration: const InputDecoration(
                                    icon: Icon(Icons.receipt),
                                    labelText: 'Enter student roll number',
                                    hintText: 'Roll Number'),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: TextField(
                                controller: _emailEditingController,
                                decoration: const InputDecoration(
                                    icon: Icon(Icons.email),
                                    labelText: 'Enter student email',
                                    hintText: 'Email'),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.green)),
                                onPressed: () {
                                  _databaseHelper.addStudenttoSection(
                                      widget.sectionName,
                                      _rollNoEditingController.text,
                                      _nameEditingController.text,
                                      _emailEditingController.text);
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Student ${_nameEditingController.text} added!')));
                                },
                                child: const Text(
                                  'Add student',
                                ))
                          ]),
                        ),
                      );
                    });
              },
              backgroundColor: const Color(0xff2BB7DA),
              child: const Icon(Icons.add),
            ),
          );
  }
}
