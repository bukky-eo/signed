import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:signed/screen/teacher/record_view.dart';
import 'package:signed/screen/teacher/student_list_view.dart';

class SectionView extends StatefulWidget {
  String sectionName;

  SectionView({Key? key, required this.sectionName}) : super(key: key);

  @override
  State<SectionView> createState() => _SectionViewState();
}

class _SectionViewState extends State<SectionView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff2BB7DA),
        title: Text(widget.sectionName),
      ),
      body: ListView(
        children: [
          InkWell(
              onTap: (() => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: ((context) =>
                            RecordView(sectionName: widget.sectionName))),
                  )),
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
                                  children: const [
                                    Text(
                                      'Sessions',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ])))))), //Sessions
          InkWell(
              onTap: (() => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: ((context) =>
                            StudentListView(sectionName: widget.sectionName))),
                  )),
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
                                  children: const [
                                    Text(
                                      'Student List',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ])))))), //Students list
        ],
      ),
    );
  }
}
