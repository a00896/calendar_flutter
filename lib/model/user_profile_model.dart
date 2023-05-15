class UserProfileModel {
  final String uid;
  final String email;
  final String name;

  UserProfileModel({
    required this.uid,
    required this.email,
    required this.name,
  });

  UserProfileModel.empty()
      : uid = "",
        email = "",
        name = "";

  Map<String, String> toJson() {
    return {
      "uid": uid,
      "email": email,
      "name": name,
    };
  }
}
