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

  int countCheckedEvents(List events) {
    return events.where((event) => event['isChecked'] == true).length;
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
                itemCount: mySelectedEvents.length,
                separatorBuilder: (context, index) => SizedBox(height: 10),
                itemBuilder: (context, index) {
                  var date = mySelectedEvents.keys.elementAt(index);
                  var events = mySelectedEvents[date];
                  var trueCount = countCheckedEvents(events!);
                  var progress = trueCount / events.length;

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
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
                          'Checked Count: $trueCount',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
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
