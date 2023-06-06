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
  List<ProgressData> progressList = [
    ProgressData(name: 'Graph 1', progress: 0.1),
    ProgressData(name: 'Graph 2', progress: 0.3),
    ProgressData(name: 'Graph 3', progress: 0.5),
  ];

  @override
  void initState() {
    super.initState();

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
      var response = await FirebaseFirestore.instance
          .collection(collection_url)
          .get();
      for (var result in response.docs) {
        if (mySelectedEvents[result['date']] != null) {
          mySelectedEvents[result['date']]?.add({
            'title': result['title'],
            'desc': result['desc'],
          });
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

  @override
  Widget build(BuildContext context) {
    print(mySelectedEvents);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Progress:',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: progressList.length,
                separatorBuilder: (context, index) => SizedBox(height: 10), // 그래프 사이 간격
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20), // 좌우 여백 설정
                    child: Column(
                      children: [
                        Text(
                          progressList[index].name,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 5),
                        ProgressBar(progress: progressList[index].progress),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    addProgressData(
                      ProgressData(name: 'New Graph', progress: 0.7),
                    );
                  },
                  child: Text('Add Progress'),
                ),
                ElevatedButton(
                  onPressed: () {
                    removeProgressData();
                  },
                  child: Text('Remove Progress'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

  class ProgressBar extends StatelessWidget {
  final double progress;

  const ProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 1000, // 가로 길이를 최대로 확장
          height: 20, // 그래프의 높이
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
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
