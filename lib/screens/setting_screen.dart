import 'dart:io';

import 'package:flutter/material.dart';
import 'package:calendar2/controller/ProfileController.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SettingScreen extends StatelessWidget {
  final ProfileController controller = Get.find<ProfileController>();

  Future<void> _uploadImage(String imagePath) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      await controller.setImageUrl(imageFile);
    }
  }

  void _showNicknameDialog() {
    String newNickname = controller.userName.value;

    showDialog(
      context: Get.context!, // Use the context from Get
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('닉네임 변경'),
          content: TextField(
            onChanged: (value) {
              newNickname = value;
            },
          ),
          actions: [
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('확인'),
              onPressed: () {
                controller.updateNickname(newNickname);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Widget myProfile() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 1000,
        child: Column(
          children: [
            profileImage(),
            SizedBox(height: 100),
            Row(
              children: [
                Text(
                  '       Email:',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(width: 100),
                Expanded(
                  child: Obx(
                    () => Text(
                      controller.userEmail.value,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Container(
              height: 5,
              color: Colors.grey, // Customize color as desired
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  '      닉네임:',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(width: 100),
                Expanded(
                  child: GestureDetector(
                    onTap: _showNicknameDialog, // Remove 'context' argument
                    child: Row(
                      children: [
                        Obx(
                          () => Text(
                            controller.userName.value,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(
                          Icons.edit,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget profileImage() {
    return Container(
      width: 130,
      height: 130,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Stack(
          children: [
            Obx(() 
              => Image.network(
                controller.imageUrl.value,
                fit: BoxFit.cover,
              ),
           ),
          controller.isEditMyProfile.value
          ? Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: () async {
                final pickedFile = await ImagePicker().pickImage(
                source: ImageSource.gallery,
                );
                if (pickedFile != null) {
                  _uploadImage(pickedFile.path);
                }   
              },
              child: Container(
                alignment: Alignment.bottomRight,
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 25,
                    ),
                  ),
              ),
            ),
          )
          : Container(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: const Text('설정'),
      ),
      body: Container(
        child: Stack(
          children: [
            myProfile(),
          ],
        ),
      ),
    );
  }
}