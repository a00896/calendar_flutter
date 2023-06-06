import 'package:flutter/material.dart';

class ProgressPage extends StatefulWidget {
  @override
  ProgressPageState createState() => ProgressPageState();
}

class ProgressPageState extends State<ProgressPage> {
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
