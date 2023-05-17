class UserProfileModel {
  final String uid;
  final String email;
  final String name;
  String imageUrl;

  UserProfileModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.imageUrl,
  });

  UserProfileModel.empty()
      : uid = "",
        email = "",
        name = "",
        imageUrl = "";

  Map<String, String> toJson() {
    return {
      "uid": uid,
      "email": email,
      "name": name,
      "imageUrl": imageUrl,
    };
  }
}
