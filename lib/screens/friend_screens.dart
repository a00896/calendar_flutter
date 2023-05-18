import 'package:flutter/material.dart';
import 'package:calendar2/controller/ProfileController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class FriendScreen extends StatelessWidget {
  final ProfileController _profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('친구 목록'),
      ),
      body: Obx(
        () {
          final List<Map<String, dynamic>> friends = _profileController.friendData;
          if (friends == null || friends.isEmpty) {
            return Center(
              child: Text('친구가 없습니다.'),
            );
          } else {
            return ListView.builder(
              itemCount: friends.length,
              itemBuilder: (context, index) {
                String friendName = friends[index]['name'] ?? '';
                String friendImageUrl = friends[index]['imageUrl'] ?? '';

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(friendImageUrl),
                  ),
                  title: Text(friendName),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('친구 추가'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _profileController.emailController,
                      decoration: InputDecoration(
                        labelText: '이메일',
                      ),
                    ),
                    Obx(() {
                      final errorMessage = _profileController.errorMessage.value;
                      if (errorMessage.isNotEmpty) {
                        return Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            errorMessage,
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    }),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      await _profileController.addFriend();
                      // 이메일이 존재하지 않는 경우에만 팝업 닫지 않음
                      if (_profileController.errorMessage.isEmpty) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('추가'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.person_add),
      ),
    );
  }
}
