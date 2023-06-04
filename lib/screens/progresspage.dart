import 'package:flutter/material.dart';

class ProgressPage extends StatefulWidget {
  @override
  _ProgressPageState createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  List<ProgressData> progressList = [
    ProgressData(name: 'Graph 1', progress: 0.1),
    ProgressData(name: 'Graph 2', progress: 0.3),
    ProgressData(name: 'Graph 3', progress: 0.5),
  ];

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Progress Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Progress:',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),

            for (int i = 0; i < progressList.length; i++) // 수정
              Column(
                children: [
                  Text(
                    progressList[i].name,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 5),
                  ProgressBar(progress: progressList[i].progress),
                  SizedBox(height: 10),
                ],
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                addProgressData(ProgressData(name: 'New Graph', progress: 0.7));
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
      ),
    );
  }
}

class ProgressBar extends StatelessWidget {
  final double progress;

  const ProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: progress,
      backgroundColor: Colors.grey[200],
      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
    );
  }
}

class ProgressData {
  final String name;
  final double progress;

  ProgressData({required this.name, required this.progress});
}
