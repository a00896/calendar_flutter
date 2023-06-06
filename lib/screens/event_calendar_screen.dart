import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class EventCalendarScreen extends StatefulWidget {
  const EventCalendarScreen({Key? key}) : super(key: key);

  @override
  State<EventCalendarScreen> createState() => _EventCalendarScreenState();
}

class _EventCalendarScreenState extends State<EventCalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDate;

  Map<String, List> mySelectedEvents = {};

  final titleController = TextEditingController();
  final descpController = TextEditingController();
  var collection_url = 'users/yWzLtNsNz2UrJjvGGq1lmR4aOVv2/calendars';
  var user_name = 'Every Calendar';

  @override
  void initState() {
    super.initState();
    _selectedDate = _focusedDay;

    loadPreviousEvents();
    getUserData();
    getCalendarData();
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
      final uid = user!.uid;
      var documentSnapshot = await users.doc(uid).get();
      print(documentSnapshot.data());
    } else {
      collection_url = 'users/yWzLtNsNz2UrJjvGGq1lmR4aOVv2/calendars';
    }
  }

  Future<void> getCalendarData() async {
    var user = FirebaseAuth.instance.currentUser;
    if (FirebaseAuth.instance.currentUser != null) {
      final uid = user!.uid;
      collection_url = 'users/$uid/calendars';
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
          });
          // print('print(mySelectedEvents): $mySelectedEvents');
        } else {
          mySelectedEvents[result['date']] = [
            {
              'title': result['title'],
              'desc': result['desc'],
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
                /*print(titleController.text);
                print(descpController.text);*/

                setState(() {
                  if (mySelectedEvents[
                          DateFormat('yyyy-MM-dd').format(_selectedDate!)] !=
                      null) {
                    mySelectedEvents[
                            DateFormat('yyyy-MM-dd').format(_selectedDate!)]
                        ?.add({
                      "title": titleController.text,
                      "desc": descpController.text,
                    });
                  } else {
                    mySelectedEvents[
                        DateFormat('yyyy-MM-dd').format(_selectedDate!)] = [
                      {
                        "title": titleController.text,
                        "desc": descpController.text,
                      }
                    ];
                  }
                });
                FirebaseFirestore.instance.collection(collection_url).add({
                  "date": DateFormat('yyyy-MM-dd').format(_selectedDate!),
                  "title": titleController.text,
                  "desc": descpController.text,
                });
                /*print(
                    "New Event for backend developer ${json.encode(mySelectedEvents)}");*/
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

  // All events completed check
  bool isAllEventsCompleted(List events) {
    if (events.isEmpty) {
      return false;
    }

    for (var event in events) {
      if (!(event['isCompleted'] ?? false)) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    List notCompletedEvents = _listOfDayEvents(_selectedDate!)
        .where((event) => !(event['isCompleted'] ?? false))
        .toList();
    List completedEvents = _listOfDayEvents(_selectedDate!)
        .where((event) => event['isCompleted'] ?? false)
        .toList();

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Color.fromARGB(255, 146, 182, 248),
        backgroundColor: Color.fromARGB(218, 255, 255, 255),
        elevation: 0,
        centerTitle: true,
        title: const Text('Every calendar'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
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
                /*eventLoader: _listOfDayEvents, >>>>>일정 완료 날짜 표시 근데 일정 개수가 사라짐ㅜㅜ
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, events) {
                    if (events.isNotEmpty) {
                      if (isAllEventsCompleted(events)) {
                        return Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.green.shade700,
                          ),
                          width: 10,
                          height: 10,
                        );
                      } else {
                        return Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.red.shade700,
                          ),
                          width: 10,
                          height: 10,
                        );
                      }
                    }
                    return null;
                  },
                ),
              ),
              Divider(*/
              ),
              Divider(
                // 구분선 추가
                color: Colors.grey,
                thickness: 1, // 원하는 두께를 선택
              ),
              ...notCompletedEvents
                  .map((myEvents) => listItemBuilder(myEvents)),
              ...completedEvents.map((myEvents) => listItemBuilder(myEvents)),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEventDialog(),
        label: const Text('Add Event--'),
      ),
    );
  }

  Widget listItemBuilder(myEvents) {
    return ListTile(
      leading: Checkbox(
        value: myEvents.containsKey('isCompleted')
            ? myEvents['isCompleted']
            : false,
        onChanged: (bool? newValue) {
          setState(() {
            myEvents['isCompleted'] = newValue;
          });
        },
      ),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text('to:   ${myEvents['title']}',
            style: TextStyle(
              decoration:
                  myEvents.containsKey('isCompleted') && myEvents['isCompleted']
                      ? TextDecoration.lineThrough
                      : null,
            )),
      ),
      subtitle: Text(
        '설명:   ${myEvents['desc']}',
        style: TextStyle(
          decoration:
              myEvents.containsKey('isCompleted') && myEvents['isCompleted']
                  ? TextDecoration.lineThrough
                  : null,
        ),
      ),
    );
  }
}
