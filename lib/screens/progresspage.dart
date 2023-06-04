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

  void addProgress(ProgressData progressData) {
    setState(() {
      progressList.add(progressData);
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

            for (ProgressData progressData in progressList)
              Column(
                children: [
                  Text(
                    progressData.name,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 5),
                  ProgressBar(progress: progressData.progress),
                  SizedBox(height: 10),
                ],
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => addProgress(ProgressData(name: 'New Graph', progress: 0.7)), // 새로운 진행도와 이름을 추가
              child: Text('Add Progress'),
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