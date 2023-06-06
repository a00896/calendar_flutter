import 'package:flutter/material.dart';
import 'package:calendar2/screens/event_calendar.dart';
import 'package:calendar2/controller/ProfileController.dart';
import 'package:get/get.dart';

class FriendScreen extends StatelessWidget {
  final ProfileController _profileController = Get.find<ProfileController>();

  FriendScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('친구 목록'),
        foregroundColor: Color.fromARGB(255, 159, 190, 248),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('친구 요청'),
                    content: SizedBox(
                      height: 250.0,
                      width: 200.0,
                      child: Obx(
                        () {
                          final List<Map<String, dynamic>> friendRequests =
                              _profileController.friendRequestsData;
                          if (friendRequests.isEmpty) {
                            return const Center(
                              child: Text('친구 요청이 없습니다.'),
                            );
                          } else {
                            return ListView.builder(
                              itemCount: friendRequests.length,
                              itemBuilder: (context, index) {
                                String requesterId =
                                    friendRequests[index]['uid'] ?? '';
                                String requesterName =
                                    friendRequests[index]['name'] ?? '';
                                String requesterImageUrl =
                                    friendRequests[index]['imageUrl'] ?? '';

                                return FriendRequestCard(
                                  requesterId: requesterId,
                                  requesterName: requesterName,
                                  requesterImageUrl: requesterImageUrl,
                                  acceptCallback: () {
                                    _profileController.acceptFriendRequest(requesterId);
                                  },
                                  rejectCallback: () {
                                    _profileController.rejectFriendRequest(requesterId);
                                  },
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Obx(
        () {
          final List<Map<String, dynamic>> friends =
              _profileController.friendData;
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

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => EventCalendar(
                            friendUid: friends[index]['uid'],
                          )),
                        ),
                      );
                    },
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(friendImageUrl),
                      radius: 30,
                    ),
                    title: Text(
                      friendName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _profileController.deleteFriend(index);
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // Add friend functionality
        },
      ),
    );
  }
}

class FriendRequestCard extends StatelessWidget {
  final String requesterId;
  final String requesterName;
  final String requesterImageUrl;
  final VoidCallback acceptCallback;
  final VoidCallback rejectCallback;

  const FriendRequestCard({
    required this.requesterId,
    required this.requesterName,
    required this.requesterImageUrl,
    required this.acceptCallback,
    required this.rejectCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(requesterImageUrl),
          radius: 30,
        ),
        title: Text(
          requesterName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text('친구 요청이 도착했습니다.'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.check),
              onPressed: acceptCallback,
            ),
            IconButton(
              icon: Icon(Icons.close),
              onPressed: rejectCallback,
            ),
          ],
        ),
      ),
    );
  }
}
