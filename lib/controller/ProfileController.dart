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
  final emailController = TextEditingController();
  final RxString errorMessage = ''.obs;

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
    errorMessage.value = '해당 이메일이 존재하지 않습니다.';
    return;
  }

  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    String userId = user.uid;
    String friendId = snapshot.docs.first.id;

    if (isFriend(userId, friendId)) {
      errorMessage.value = '이미 친구입니다.';
      return;
    }

    CollectionReference<Map<String, dynamic>> usersCollection =
        FirebaseFirestore.instance.collection('users');

    // Update the friend data in the user's document
    await usersCollection.doc(userId).update({
      'friends': FieldValue.arrayUnion([friendId])
    });

    // Update the user's data in the friend's document
    await usersCollection.doc(friendId).update({
      'friends': FieldValue.arrayUnion([userId])
    });

    getProfileData();
  }

  emailController.clear();
}


  Future<void> deleteFriend(int index) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    String userId = user.uid;
    String friendId = friendData[index]['uid'];

    CollectionReference<Map<String, dynamic>> usersCollection =
        FirebaseFirestore.instance.collection('users');

    // 사용자의 친구 목록에서 친구 삭제
    await usersCollection.doc(userId).update({
      'friends': FieldValue.arrayRemove([friendId])
    });

    // 친구의 친구 목록에서 사용자 삭제
    await usersCollection.doc(friendId).update({
      'friends': FieldValue.arrayRemove([userId])
    });

    getProfileData();
  }
}


  void getProfileData() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    if (snapshot.exists) {
      var userData = snapshot.data();
      List<dynamic> friendIds = userData?['friends'] ?? [];
      
      // Create a temporary map to store friend data
      Map<String, Map<String, dynamic>> tempFriendData = {};

      for (dynamic friendId in friendIds) {
        DocumentSnapshot<Map<String, dynamic>> friendSnapshot =
            await FirebaseFirestore.instance.collection('users').doc(friendId).get();
        if (friendSnapshot.exists) {
          Map<String, dynamic> friend = friendSnapshot.data()!;
          friend['uid'] = friendId;

          // Check if the friend data already exists in the temporary map
          if (!tempFriendData.containsKey(friendId)) {
            tempFriendData[friendId] = friend;
          }
        }
      }

      // Clear the existing friendData list
      friendData.clear();

      // Add unique friends from the temporary map to the friendData list
      friendData.addAll(tempFriendData.values);

      userName.value = userData?['name'] ?? '';
      imageUrl.value = userData?['imageUrl'] ?? '';
    }
  }
}

  bool isFriend(String userId, String friendId) {
    for (Map<String, dynamic> friend in friendData) {
      if (friend['uid'] == friendId) {
        return true;
      }
    }
    return false;
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}