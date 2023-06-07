import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const List<String> list = <String>[
  '',
  '일어나기',
  '밥 먹기',
  '과제 하기',
  '과제 제출 하기',
  '런닝하기',
  '산책하기',
  '회의',
  '직접입력'
];

const List<String> timeList = <String>[
  '',
  '00시',
  '01시',
  '02시',
  '03시',
  '09시',
  '10시',
  '11시',
  '12시',
  '13시',
  '14시',
  '15시',
  '16시',
  '17시',
  '18시',
  '19시',
  '20시',
  '21시',
  '22시',
  '23시',
  '24시',
];

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
  var calendar_url;
  var user_name = 'Every Calendar';
  String dropdownValue = list.first;
  String dropdownTimeValue = timeList.first;

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
    print("print: save 실행");
    // var user = FirebaseAuth.instance.currentUser;
    // final uid = user!.uid;
    // await FirebaseFirestore.instance.collection("users").doc(uid).update(
    //   {
    //     "calendars": '',
    //   },
    // );

    // var response = await FirebaseFirestore.instance
    //     .collection(collection_url)
    //     // .where('data', isEqualTo: '2023-05-17')
    //     .get();
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
          print("print: save 종료");
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
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: const Text(
              '새로운 일정 추가',
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
                    labelText: '제목',
                  ),
                ),
                SizedBox(
                  height: 60.0,
                  child: CupertinoPicker(
                    scrollController:
                        FixedExtentScrollController(initialItem: 0),
                    itemExtent: 32.0,
                    useMagnifier: true,
                    onSelectedItemChanged: (int index) {
                      dropdownTimeValue = timeList[index];
                    },
                    backgroundColor: CupertinoColors.white,
                    children:
                        List<Widget>.generate(timeList.length, (int index) {
                      return Center(child: Text(timeList[index]));
                    }),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  height: 60.0,
                  child: CupertinoPicker(
                    scrollController:
                        FixedExtentScrollController(initialItem: 0),
                    itemExtent: 32.0,
                    useMagnifier: true,
                    onSelectedItemChanged: (int index) {
                      dropdownValue = list[index];
                    },
                    backgroundColor: CupertinoColors.white,
                    children: List<Widget>.generate(list.length, (int index) {
                      return Center(child: Text(list[index]));
                    }),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                TextField(
                  enabled: (dropdownValue == '직접입력') ? true : false,
                  controller: descpController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(labelText: '내용'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('취소'),
              ),
              TextButton(
                child: const Text('추가'),
                onPressed: () {
                  // if (titleController.text.isEmpty &&
                  // descpController.text.isEmpty) {
                  if (titleController.text.isEmpty) {
                    // const SnackBar(
                    //   content: Text('Required title and description'),
                    //   duration: Duration(seconds: 2),
                    // );

                    // SnackBar가 안되서 일단 toast msg로 대체
                    Fluttertoast.showToast(
                        msg: "제목을 입력해주세요",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.grey,
                        textColor: Colors.white,
                        fontSize: 16.0);

                    //Navigator.pop(context);
                    return;
                  } else if (dropdownValue == "직접입력") {
                    DateTime dt = DateTime.now();
                    String timestamp = dt.millisecondsSinceEpoch.toString();
                    print(timestamp);
                    setState(() {
                      if (mySelectedEvents[DateFormat('yyyy-MM-dd')
                              .format(_selectedDate!)] !=
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
                  } else if (dropdownValue != "직접입력") {
                    DateTime dt = DateTime.now();
                    String timestamp = dt.millisecondsSinceEpoch.toString();
                    print(timestamp);
                    setState(() {
                      if (mySelectedEvents[DateFormat('yyyy-MM-dd')
                              .format(_selectedDate!)] !=
                          null) {
                        mySelectedEvents[
                                DateFormat('yyyy-MM-dd').format(_selectedDate!)]
                            ?.add({
                          "title": titleController.text,
                          "desc": '$dropdownTimeValue $dropdownValue',
                          "isChecked": false,
                          "document": timestamp,
                        });
                      } else {
                        mySelectedEvents[
                            DateFormat('yyyy-MM-dd').format(_selectedDate!)] = [
                          {
                            "title": titleController.text,
                            "desc": '$dropdownTimeValue $dropdownValue',
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
                      "desc": '$dropdownTimeValue $dropdownValue',
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
          );
        },
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
        title: const Text(
          'every calendar',
          style: TextStyle(fontSize: 26), // 원하는 텍스트 크기로 설정
        ),
        foregroundColor: Color.fromARGB(255, 191, 224, 255),
        backgroundColor: const Color.fromARGB(255, 247, 247, 247),
        elevation: 0,
        centerTitle: true,
        // title: const Text(user_name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
              Container(
                height: 1,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 192, 192, 192),
                ),
              ),
              ..._listOfDayEvents(_selectedDate!).map(
                (myEvents) => ListTile(
                  onTap: () => {
                    print("print: 리스트타일 탭"),
                    setState(() {
                      myEvents['isChecked'] = !myEvents['isChecked'];
                    }),
                    saveCalendarData(),
                  },
                  leading: Icon(
                    myEvents['isChecked']
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    color: const Color.fromARGB(255, 115, 224, 213),
                  ),
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      '제목:   ${myEvents['title']}',
                      style: TextStyle(
                        decoration: myEvents['isChecked']
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                  ),
                  subtitle: Text(
                    '내용:   ${myEvents['desc']}',
                    style: TextStyle(
                      decoration: myEvents['isChecked']
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  trailing: IconButton(
                    // onPressed: _deleteEventDialog,
                    onPressed: () {
                      print("print: 삭제버튼클릭");
                      print('print: $myEvents');
                      FirebaseFirestore.instance
                          .collection(collection_url)
                          .doc(myEvents['document'])
                          .delete()
                          .then(
                            (doc) => print("Document deleted"),
                            onError: (e) => print("Error updating document $e"),
                          );
                      setState(() {
                        mySelectedEvents.forEach((key, values) {
                          print("print remove1: $mySelectedEvents");
                          values.removeWhere((value) => value == myEvents);

                          print("print remove2: $mySelectedEvents");
                        });
                      });
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Color.fromARGB(255, 165, 165, 165),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEventDialog(),
        backgroundColor: Color.fromARGB(255, 181, 226, 255),
        label: const Text('일정 추가 \u{1F4AC}'),
      ),
    );
  }
}
