import 'package:calendar2/screens/event_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchQuery extends StatefulWidget {
  const SearchQuery({super.key});

  @override
  State<SearchQuery> createState() => _SearchQueryState();
}

class _SearchQueryState extends State<SearchQuery> {
  String name = "";
  List<Map<String, dynamic>> data = [];

  addData() async {
    for (var element in data) {
      FirebaseFirestore.instance.collection('users').add(element);
    }
    print('app data added');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 248, 248, 248),
        foregroundColor: Color.fromARGB(255, 165, 202, 243),
        title: Text('every calendar'), // 페이지 이름을 여기에 추가하세요.
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Card(
            margin: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(255, 223, 223, 223),
                prefixIcon: Icon(Icons.search),
                hintText: '닉네임을 입력하세요...',
                contentPadding: EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none, // TextField의 경계선을 제거
                ),
              ),
              onChanged: (val) {
                setState(() {
                  name = val;
                });
              },
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshots) {
            return (snapshots.connectionState == ConnectionState.waiting)
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: snapshots.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshots.data!.docs[index].data()
                          as Map<String, dynamic>;

                      if (name.isEmpty) {
                        return ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) =>
                                    EventCalendar(friendUid: data['uid'])),
                              ),
                            );
                          },
                          title: Text(
                            data['name'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 83, 83, 83),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            data['email'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 71, 71, 71),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(data['imageUrl']),
                          ),
                        );
                      }
                      if (data['name']
                          .toString()
                          .toLowerCase()
                          .startsWith(name.toLowerCase())) {
                        return ListTile(
                          onTap: () {
                            print('print: test');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) =>
                                    EventCalendar(friendUid: data['uid'])),
                              ),
                            );
                          },
                          title: Text(
                            data['name'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            data['email'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(data['imageUrl']),
                          ),
                        );
                      }
                      return Container();
                    },
                  );
          }),
    );
  }
}
