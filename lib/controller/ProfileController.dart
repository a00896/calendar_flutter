import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  RxBool isEditMyProfile = false.obs;

  var userEmail = ''.obs;
  var userName = ''.obs;
  var imageUrl = ''.obs;

  @override
  void onInit() {
    isEditMyProfile(false);
    super.onInit();
    getProfileData();
  }

  void toggleEditProfile() {
    isEditMyProfile.value = !isEditMyProfile.value;
  }

  Future<void> setImageUrl(File imageFile) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      String fileName = 'profile_image_$userId.jpg';

      Reference storageReference =
          FirebaseStorage.instance.ref().child('profile_images').child(fileName);

      // 이미지 업로드
      UploadTask uploadTask = storageReference.putFile(imageFile);
      await uploadTask;

      // 업로드된 이미지의 URL 가져오기
      String imageUrl = await storageReference.getDownloadURL();

      // Firestore에 이미지 URL 저장
      CollectionReference<Map<String, dynamic>> usersCollection =
          FirebaseFirestore.instance.collection('users');

      await usersCollection.doc(userId).set(
        {'imageUrl': imageUrl},
        SetOptions(merge: true),
      );

      // 이미지 URL 업데이트 후 상태 갱신
      this.imageUrl.value = imageUrl;
    }
  }

  Future<void> updateNickname(String newNickname) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      
      // Firestore에 닉네임 업데이트
      CollectionReference<Map<String, dynamic>> usersCollection =
          FirebaseFirestore.instance.collection('users');

      await usersCollection.doc(userId).set(
        {'name': newNickname},
        SetOptions(merge: true),
      );

      // 닉네임 업데이트 후 상태 갱신
      this.userName.value = newNickname;
    }
  }

  void getProfileData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (snapshot.exists) {
        var userData = snapshot.data();
        userEmail.value = userData?['email'] ?? '';
        userName.value = userData?['name'] ?? '';
        imageUrl.value = userData?['imageUrl'] ?? '';
      }
    }
  }
}
