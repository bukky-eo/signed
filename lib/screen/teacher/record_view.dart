import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:signed/methods/aes.dart';
import '../../methods/storage_methods.dart';
import 'attendance_view.dart';

class RecordView extends StatefulWidget {
  final String sectionName;
  const RecordView({Key? key, required this.sectionName}) : super(key: key);

  @override
  State<RecordView> createState() => _RecordViewState();
}

class _RecordViewState extends State<RecordView> {
  AESEncryption encryption = AESEncryption();
  bool _isLoading = false;
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  late Stream<QuerySnapshot> sessionsStream;
  final TextEditingController _nameEditingController = TextEditingController();

  void _loadSessions() async {
    _databaseHelper.searchSessionsofClass(widget.sectionName).then((val) => {
          setState((() {
            _isLoading = false;
            sessionsStream = val;
          }))
        });
  }

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    _loadSessions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xff2BB7DA),
              title: Text('Session History of ${widget.sectionName}'),
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: sessionsStream,
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? ListView.builder(
                        itemCount: snapshot.data!.size,
                        itemBuilder: ((context, index) {
                          return InkWell(
                              onTap: (() => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: ((context) => AttendanceView(
                                              sessionId:
                                                  snapshot.data!.docs[index].id,
                                              sectionName: widget.sectionName,
                                            ))),
                                  )),
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 3.0, horizontal: 8.0),
                                  child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      color: const Color(0xff2BB7DA),
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
                                                    IconButton(
                                                        onPressed: () {
                                                          _databaseHelper
                                                              .deleteSessionsofClass(
                                                                  widget
                                                                      .sectionName,
                                                                  snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                      .id)
                                                              .then((_) {
                                                            setState(() {
                                                              _loadSessions();
                                                            });
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    const SnackBar(
                                                                        content:
                                                                            Text('Session deleted successfully!')));
                                                          });
                                                        },
                                                        icon: const Icon(
                                                          Icons.delete,
                                                          color: Colors.white,
                                                        ))
                                                  ]))))));
                        }))
                    : const Center(
                        child: Text('No sessions yet. Tap + to add a session'));
              },
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: const Color(0xff2BB7DA),
              onPressed: () {
                showModalBottomSheet(
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(25.0)),
                    ),
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                'Create Session',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                    fontSize: 20),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: TextField(
                                controller: _nameEditingController,
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.receipt),
                                  labelText: 'Enter session name',
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _databaseHelper
                                    .searchSessionsofClassget(
                                        widget.sectionName,
                                        _nameEditingController.text)
                                    .then((var val) {
                                  if (val.exists) {
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Session with same name already exists!')));
                                  } else {
                                    _databaseHelper.createSession(
                                        widget.sectionName,
                                        _nameEditingController.text);
                                    setState(() {
                                      _loadSessions();
                                    });
                                    Navigator.of(context).pop();

                                    String qrData =
                                        '${widget.sectionName}/${_nameEditingController.text}'; // 'csb/29-06-2022'

                                    final encryptedQR =
                                        encryption.encryptMsg(qrData);

                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Dialog(
                                            child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  QrImage(
                                                    data: encryptedQR.base64,
                                                  ),
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        _databaseHelper
                                                            .disactivateSession(
                                                                widget
                                                                    .sectionName,
                                                                _nameEditingController
                                                                    .text);
                                                      },
                                                      child: const Text('Done'))
                                                ]),
                                          );
                                        });
                                  }
                                });
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.green),
                              ),
                              child: const Text('Generate Session'),
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
