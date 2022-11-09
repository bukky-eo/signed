import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../methods/storage_methods.dart';

class AttendanceView extends StatefulWidget {
  final String sessionId;
  final String sectionName;

  const AttendanceView(
      {Key? key, required this.sessionId, required this.sectionName})
      : super(key: key);

  @override
  State<AttendanceView> createState() => _AttendanceViewState();
}

class _AttendanceViewState extends State<AttendanceView> {
  bool _isLoading = false;
  late Stream<QuerySnapshot> studentsStream;
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  void _loadAttendanceData() async {
    _databaseHelper
        .getAttendanceStatus(widget.sectionName, widget.sessionId)
        .then((val) => {
              setState((() {
                _isLoading = false;
                studentsStream = val;
              }))
            });
  }

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    _loadAttendanceData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
                title: Text(widget.sessionId),
                backgroundColor: const Color(0xff2BB7DA)),
            body: StreamBuilder<QuerySnapshot>(
              stream: studentsStream,
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: ((context, index) {
                          return InkWell(
                              onTap: null,
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 3.0, horizontal: 8.0),
                                  child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      color: snapshot.data!.docs[index]
                                              ['attending']
                                          ? Colors.green
                                          : const Color(0xff2BB7DA),
                                      child: SizedBox(
                                          width: double.infinity,
                                          height: 80.0,
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      snapshot
                                                          .data!.docs[index].id,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      snapshot.data!.docs[index]
                                                          ['studentName'],
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Icon(
                                                      snapshot.data!.docs[index]
                                                              ['attending']
                                                          ? Icons.done
                                                          : Icons.close,
                                                      color: Colors.white,
                                                    )
                                                  ]))))));
                        }))
                    : Container();
              },
            ),
          );
  }
}
