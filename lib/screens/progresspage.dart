import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProgressPage extends StatefulWidget {
  @override
  ProgressPageState createState() => ProgressPageState();
}

class ProgressPageState extends State<ProgressPage> {
  var collection_url = 'users/yWzLtNsNz2UrJjvGGq1lmR4aOVv2/calendars';
  Map<String, List> mySelectedEvents = {};
  List<ProgressData> progressList = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadPreviousEvents();
    getUserData();
    getCalendarData();
  }

  loadPreviousEvents() {
    mySelectedEvents = {};
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
      var collectionReference =
          FirebaseFirestore.instance.collection(collection_url);
      var snapshot = await collectionReference.get();

      // Listen for realtime changes
      collectionReference.snapshots().listen((snapshot) {
        setState(() {
          mySelectedEvents = {}; // Reset the map before updating
          for (var result in snapshot.docs) {
            if (mySelectedEvents[result['date']] != null) {
              mySelectedEvents[result['date']]?.add({
                'title': result['title'],
                'desc': result['desc'],
                'isChecked': result['isChecked'],
              });
            } else {
              mySelectedEvents[result['date']] = [
                {
                  'title': result['title'],
                  'desc': result['desc'],
                  'isChecked': result['isChecked'],
                }
              ];
            }
          }
        });
      });
    } on FirebaseException catch (e) {
      print(e);
    } catch (error) {
      print(error);
    }
  }

  void addProgressData(ProgressData progressData) {
    setState(() {
      progressList.add(progressData);
    });
  }

  void removeProgressData() {
    setState(() {
      if (progressList.isNotEmpty) {
        progressList.removeLast();
      }
    });
  }

  List<Map<String, dynamic>> countCheckedEvents(
      List<Map<String, dynamic>> events) {
    return events.where((event) => event['isChecked'] == true).toList();
  }

  @override
  Widget build(BuildContext context) {
    print(mySelectedEvents);
    return Scaffold(
      appBar: AppBar(
        // AppBar 위젯 추가
        title: const Text(
          'progress',
          style: TextStyle(fontSize: 26), // 원하는 텍스트 크기로 설정
        ),
        foregroundColor: const Color.fromARGB(255, 191, 224, 255),
        backgroundColor: const Color.fromARGB(255, 247, 247, 247),
        elevation: 0, // 페이지 이름 'Progress'
        centerTitle: true, // 제목을 가운데 정렬(선택 사항)
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            Text(
              '일별 달성도\u{1F4AA}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: mySelectedEvents.length,
                separatorBuilder: (context, index) => SizedBox(height: 10),
                itemBuilder: (context, index) {
                  var date = mySelectedEvents.keys.elementAt(index);
                  var events = mySelectedEvents[date];
                  var checkedEvents =
                      countCheckedEvents(events!.cast<Map<String, dynamic>>());
                  var progressText = checkedEvents.length == events.length
                      ? '모든 일정 완료 \u{1F389}'
                      : '완료한 갯수: ${checkedEvents.length}';
                  var progress = checkedEvents.length / events.length;

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Text(
                            date,
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 5),
                          ProgressBar(
                            progress: progress,
                            name: 'Progress',
                          ),
                          Text(
                            progressText,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class ProgressBar extends StatelessWidget {
  final double progress;
  final String name;

  const ProgressBar({required this.progress, required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 1000,
          height: 20,
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
                Color.fromARGB(255, 224, 232, 253)),
          ),
        ),
        Text(
          '(${(progress * 100).toStringAsFixed(1)}% / 100%)',
          style: TextStyle(fontSize: 15),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}

class ProgressData {
  final String name;
  final double progress;

  ProgressData({required this.name, required this.progress});
}
