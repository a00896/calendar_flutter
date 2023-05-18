import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  RxBool isEditMyProfile = true.obs;

  var userEmail = ''.obs;
  var userName = ''.obs;
  var imageUrl = ''.obs;
  var friendData = <Map<String, dynamic>>[].obs;
  final emailController = TextEditingController(); // 이메일을 입력받을 컨트롤러 추가
  final RxString errorMessage = ''.obs; // 에러 메시지를 관리하기 위한 RxString 추가

  @override
  void onInit() {
    super.onInit();
    getProfileData();
  }

  Future<void> setImageUrl(File imageFile) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      String fileName = 'profile_image_$userId.jpg';

      Reference storageReference =
          FirebaseStorage.instance.ref().child('profile_images').child(fileName);

      UploadTask uploadTask = storageReference.putFile(imageFile);
      await uploadTask;

      String imageUrl = await storageReference.getDownloadURL();

      CollectionReference<Map<String, dynamic>> usersCollection =
          FirebaseFirestore.instance.collection('users');

      await usersCollection.doc(userId).set(
        {'imageUrl': imageUrl},
        SetOptions(merge: true),
      );

      this.imageUrl.value = imageUrl;
    }
  }

  Future<void> updateNickname(String newNickname) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;

      CollectionReference<Map<String, dynamic>> usersCollection =
          FirebaseFirestore.instance.collection('users');

      await usersCollection.doc(userId).set(
        {'name': newNickname},
        SetOptions(merge: true),
      );

      this.userName.value = newNickname;
    }
  }

  Future<void> addFriend() async {
    String email = emailController.text.trim();

    if (email.isEmpty) {
      errorMessage.value = '이메일을 입력해주세요.';
      return;
    }

    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (snapshot.docs.isEmpty) {
      // Firestore에 해당 이메일이 없는 경우
      errorMessage.value = '해당 이메일이 존재하지 않습니다.';
      return;
    }

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;

      CollectionReference<Map<String, dynamic>> usersCollection =
          FirebaseFirestore.instance.collection('users');

      // friends 필드에 userId 추가
      await usersCollection
          .doc(snapshot.docs.first.id)
          .collection('friends')
          .doc(userId)
          .set({});

      // 현재 사용자의 friends 필드에 friend의 userId 추가
      await usersCollection.doc(userId).set({
        'friends': FieldValue.arrayUnion([snapshot.docs.first.id])
      }, SetOptions(merge: true));

      // 친구 목록을 다시 가져옴
      getProfileData();
    }

    emailController.clear(); // 이메일 필드 초기화
  }

  void getProfileData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (snapshot.exists) {
        var userData = snapshot.data();
        List<dynamic> friendIds = userData?['friends'] ?? [];
        friendData.clear(); // friendData 초기화

        for (dynamic friendId in friendIds) {
          DocumentSnapshot<Map<String, dynamic>> friendSnapshot =
              await FirebaseFirestore.instance.collection('users').doc(friendId).get();
          if (friendSnapshot.exists) {
            Map<String, dynamic> friendData = friendSnapshot.data() ?? {};
            this.friendData.add(friendData); // List에 friendData 추가
          }
        }

        userEmail.value = userData?['email'] ?? '';
        userName.value = userData?['name'] ?? '';
        imageUrl.value = userData?['imageUrl'] ?? '';
      }
    }
  }
}
