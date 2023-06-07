import 'package:calendar2/controller/ProfileController.dart';
import 'package:calendar2/screens/setting_screen.dart';
import 'package:calendar2/widgets/start.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  ProfileScreen({Key? key}) : super(key: key) {
    // 데이터 가져오기
    controller.getProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'my page',
          style: TextStyle(fontSize: 26), // 원하는 텍스트 크기로 설정
        ),
        foregroundColor: const Color.fromARGB(255, 191, 224, 255),
        backgroundColor: const Color.fromARGB(255, 247, 247, 247),
        elevation: 0,
        centerTitle: true,
        // title: const Text(user_name),
      ),
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          const ProfileInfoSection(),
          const ProfileImageSection(),
          SettingButtonSection(
              controller: controller), // ProfileController 인스턴스 전달
        ],
      ),
    );
  }
}

class ProfileInfoSection extends GetWidget<ProfileController> {
  const ProfileInfoSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 170,
      left: 0,
      right: 230,
      child: SizedBox(
        height: 200,
        child: Column(
          children: [
            Obx(() => Text(
                  controller.userName.value,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 75, 75, 75),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class ProfileImageSection extends StatelessWidget {
  const ProfileImageSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      top: 30,
      left: 0,
      right: 230,
      child: SizedBox(
        height: 200,
        child: Column(
          children: [
            ProfileImage(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class ProfileImage extends GetWidget<ProfileController> {
  const ProfileImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 130,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(80),
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Obx(() => Image.network(
              controller.imageUrl.value,
              fit: BoxFit.cover,
            )),
      ),
    );
  }
}

class SettingButtonSection extends StatelessWidget {
  final ProfileController controller;

  const SettingButtonSection({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      right: 30,
      child: Column(
        children: [
          Container(
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to(() => SettingScreen());
                  },
                  child: const Column(
                    children: [
                      Icon(
                        Icons.settings,
                        color: Colors.grey,
                        size: 28,
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Start()),
                (Route<dynamic> route) => false,
              );
            },
            child: Container(
              width: 70,
              height: 40,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 250, 255, 206),
              ),
              child: const Align(
                alignment: Alignment.center,
                child: Text("로그아웃"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
