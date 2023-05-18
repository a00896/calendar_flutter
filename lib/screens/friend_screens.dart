import 'package:flutter/material.dart';
import 'package:calendar2/controller/ProfileController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class FriendScreen extends StatelessWidget {
  final ProfileController _profileController = Get.find<ProfileController>();

  FriendScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('친구 목록'),
      ),
      body: Obx(
        () {
          final List<Map<String, dynamic>> friends = _profileController.friendData;
          if (friends.isEmpty) {
            return const Center(
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
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('친구 삭제'),
                            content: const Text('정말로 삭제하시겠습니까?'),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  await _profileController.deleteFriend(index);
                                  Navigator.of(context).pop();
                                },
                                child: const Text('예'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('취소'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
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
                title: const Text('친구 추가'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _profileController.emailController,
                      decoration: const InputDecoration(
                        labelText: '이메일',
                      ),
                    ),
                    Obx(() {
                      final errorMessage = _profileController.errorMessage.value;
                      if (errorMessage.isNotEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            errorMessage,
                            style: const TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      await _profileController.addFriend();
                      if (_profileController.errorMessage.value.isEmpty) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('추가'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.person_add),
      ),
    );
  }
}