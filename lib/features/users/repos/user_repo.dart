import 'package:calendar2/model/user_profile_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createProfile(UserProfileModel profile) async {
    await _db.collection("users").doc(profile.uid).set(profile.toJson());
  }
}
