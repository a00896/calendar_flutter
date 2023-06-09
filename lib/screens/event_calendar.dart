import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class EventCalendar extends StatefulWidget {
  const EventCalendar({
    Key? key,
    required this.friendUid,
  }) : super(key: key);
  final friendUid;

  @override
  State<EventCalendar> createState() => _EventCalendarState();
}

class _EventCalendarState extends State<EventCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDate;

  Map<String, List> mySelectedEvents = {};

  final titleController = TextEditingController();
  final descpController = TextEditingController();
  var collection_url = 'users/yWzLtNsNz2UrJjvGGq1lmR4aOVv2/calendars';
  var calendar_url;
  var user_name = 'Every Calendar';

  @override
  void initState() {
    super.initState();
    _selectedDate = _focusedDay;
    print("print: initState");

    loadPreviousEvents();
    getUserData();
    getCalendarData();
  }

  @override
  void dispose() {
    saveCalendarData();
    print("print: dispose");
    super.dispose(); // 마지막에 선언 / 차이는 없는데 보기좋음
  }

  loadPreviousEvents() {
    mySelectedEvents = {};
  }

  List _listOfDayEvents(DateTime dateTime) {
    if (mySelectedEvents[DateFormat('yyyy-MM-dd').format(dateTime)] != null) {
      return mySelectedEvents[DateFormat('yyyy-MM-dd').format(dateTime)]!;
    } else {
      return [];
    }
  }

  Future<void> getUserData() async {
    print('print: getUserData');
    var user = FirebaseAuth.instance.currentUser;
    var users = FirebaseFirestore.instance.collection('users');
    if (FirebaseAuth.instance.currentUser != null) {
      final uid = widget.friendUid;
      var documentSnapshot = await users.doc(uid).get();
      print(documentSnapshot.data());
    } else {
      collection_url = 'users/yWzLtNsNz2UrJjvGGq1lmR4aOVv2/calendars';
    }
  }

  Future<void> getCalendarData() async {
    var user = FirebaseAuth.instance.currentUser;
    if (FirebaseAuth.instance.currentUser != null) {
      final uid = widget.friendUid;
      collection_url = 'users/$uid/calendars';
      calendar_url = 'users/$uid';
    } else {
      collection_url = 'users/yWzLtNsNz2UrJjvGGq1lmR4aOVv2/calendars';
    }

    try {
      var response = await FirebaseFirestore.instance
          .collection(collection_url)
          // .where('data', isEqualTo: '2023-05-17')
          .get();
      for (var result in response.docs) {
        if (mySelectedEvents[result['date']] != null) {
          mySelectedEvents[result['date']]?.add({
            'title': result['title'],
            'desc': result['desc'],
            'isChecked': result['isChecked'],
            'document': result['document'],
          });
        } else {
          mySelectedEvents[result['date']] = [
            {
              'title': result['title'],
              'desc': result['desc'],
              'isChecked': result['isChecked'],
              'document': result['document'],
            }
          ];
        }
        setState(() {});
      }

      // if (response.docs.isNotEmpty) {
      //   print('print: ${response.docs.length}');
      // }
    } on FirebaseException catch (e) {
      print(e);
    } catch (error) {
      print(error);
    }
  }

  Future<void> saveCalendarData() async {
    var user = FirebaseAuth.instance.currentUser;
    final uid = widget.friendUid;
    await FirebaseFirestore.instance.collection("users").doc(uid).update(
      {
        "calendars": '',
      },
    );

    var response = await FirebaseFirestore.instance
        .collection(collection_url)
        // .where('data', isEqualTo: '2023-05-17')
        .get();
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      print('print:-------------------------------------------------------');
      // print('print query: ${await firestore.collection(collection_url).get()}');
      QuerySnapshot querySnapshot = await firestore
          .collection(collection_url)
          // .where('title', isEqualTo: 'Fg')
          .get();
      // print("print docs: ${querySnapshot.docs}");

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          print('print id: ${doc.id}');

          mySelectedEvents.forEach((key, value) {
            // print("print $key, $value");
            // print("print: ${value[0]["title"]}");
            for (var v in value) {
              // print("print: $key");
              // print("print v: $v");
              // print("print v: ${v["title"]}");
              print("print document: ${v["document"]}");
              if (doc.id == v["document"]) {
                print('print: true');
                FirebaseFirestore.instance
                    .collection(collection_url)
                    .doc(v["document"])
                    .update({
                  "isChecked": v["isChecked"],
                });
                // FirebaseFirestore.instance.collection(collection_url).add({
                //   "date": key,
                //   "title": v["title"],
                //   "desc": v["desc"],
                //   "isChecked": v["isChecked"],
                // });
              }
            }
          });
        }
        // 검색 결과에서 첫 번째 문서의 ID를 가져옴
        String documentID = querySnapshot.docs[0].id;
        print('print 문서 ID: $documentID');
      } else {
        print('print 해당하는 문서를 찾을 수 없음');
      }
    } on FirebaseException catch (e) {
      print(e);
    } catch (error) {
      print(error);
    }
  }

  _showAddEventDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Add New Event',
          textAlign: TextAlign.center,
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
            ),
            TextField(
              controller: descpController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            child: const Text('Add Event'),
            onPressed: () {
              if (titleController.text.isEmpty &&
                  descpController.text.isEmpty) {
                // const SnackBar(
                //   content: Text('Required title and description'),
                //   duration: Duration(seconds: 2),
                // );

                // SnackBar가 안되서 일단 toast msg로 대체
                Fluttertoast.showToast(
                    msg: "Required title and description",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.grey,
                    textColor: Colors.white,
                    fontSize: 16.0);

                //Navigator.pop(context);
                return;
              } else {
                DateTime dt = DateTime.now();
                String timestamp = dt.millisecondsSinceEpoch.toString();
                print(timestamp);
                setState(() {
                  if (mySelectedEvents[
                          DateFormat('yyyy-MM-dd').format(_selectedDate!)] !=
                      null) {
                    mySelectedEvents[
                            DateFormat('yyyy-MM-dd').format(_selectedDate!)]
                        ?.add({
                      "title": titleController.text,
                      "desc": descpController.text,
                      "isChecked": false,
                      "document": timestamp,
                    });
                  } else {
                    mySelectedEvents[
                        DateFormat('yyyy-MM-dd').format(_selectedDate!)] = [
                      {
                        "title": titleController.text,
                        "desc": descpController.text,
                        "isChecked": false,
                        "document": timestamp,
                      }
                    ];
                  }
                });
                FirebaseFirestore.instance
                    .collection(collection_url)
                    .doc(timestamp)
                    .set({
                  "date": DateFormat('yyyy-MM-dd').format(_selectedDate!),
                  "title": titleController.text,
                  "desc": descpController.text,
                  "isChecked": false,
                  "document": timestamp,
                });
                print(
                    "New Event for backend developer ${json.encode(mySelectedEvents)}");
                titleController.clear();
                descpController.clear();
                Navigator.pop(context);
                return;
              }
            },
          )
        ],
      ),
    );
  }

  _deleteEventDialog() {
    print("print: 삭제버튼 탭");
    print(
        'print1: ${mySelectedEvents[DateFormat('yyyy-MM-dd').format(_selectedDate!)]!.where((element) => element["title"] == "asdf")}');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          '일정 삭제',
          textAlign: TextAlign.center,
        ),
        content: const Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "삭제하시겠습니까?",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            child: const Text('삭제'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        // title: const Text(user_name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            children: [
              TableCalendar(
                locale: "ko-KR",
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDate, selectedDay)) {
                    // Call `setState()` when updating the selected day
                    setState(() {
                      _selectedDate = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  }
                },
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDate, day);
                },
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    // Call `setState()` when updating calendar format
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  // No need to call `setState()` here
                  _focusedDay = focusedDay;
                },
                eventLoader: _listOfDayEvents,
              ),
              ..._listOfDayEvents(_selectedDate!).map(
                (myEvents) => ListTile(
                  leading: Icon(
                    myEvents['isChecked']
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    color: Colors.teal,
                  ),
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Event Title:   ${myEvents['title']}',
                      style: TextStyle(
                        decoration: myEvents['isChecked']
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                  ),
                  subtitle: Text(
                    'Description:   ${myEvents['desc']}',
                    style: TextStyle(
                      decoration: myEvents['isChecked']
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
