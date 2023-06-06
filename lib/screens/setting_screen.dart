import 'dart:io';

import 'package:flutter/material.dart';
import 'package:calendar2/controller/ProfileController.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SettingScreen extends StatelessWidget {
  final ProfileController controller = Get.find<ProfileController>();

  SettingScreen({super.key});

  Future<void> _uploadImage(String imagePath) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
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
          title: const Text('닉네임 변경'),
          content: TextField(
            onChanged: (value) {
              newNickname = value;
            },
          ),
          actions: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    child: const Text('취소'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: 10), // 버튼 사이의 공간을 추가
                  TextButton(
                    child: const Text('확인'),
                    onPressed: () {
                      controller.updateNickname(newNickname);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
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
      child: SizedBox(
        height: 1000,
        child: Column(
          children: [
            profileImage(),
            const SizedBox(height: 100),
            Row(
              children: [
                const Text(
                  '       Email:',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(width: 100),
                Expanded(
                  child: Obx(
                    () => Text(
                      controller.userEmail.value,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Container(
              height: 5,
              color: Colors.grey, // Customize color as desired
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text(
                  '      닉네임:',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(width: 100),
                Expanded(
                  child: GestureDetector(
                    onTap: _showNicknameDialog, // Remove 'context' argument
                    child: Row(
                      children: [
                        Obx(
                          () => Text(
                            controller.userName.value,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(
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
    return SizedBox(
      width: 130,
      height: 130,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Stack(
          children: [
            Obx(
              () => Image.network(
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
                          decoration: const BoxDecoration(
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
            const SizedBox(
              height: 300,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
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
