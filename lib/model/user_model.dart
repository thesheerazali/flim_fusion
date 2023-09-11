class UserModel {
  final String name;
  final String username;
  final String email;
  final String phoneNo;

  UserModel({
    required this.phoneNo,
    required this.name,
    required this.username,
    required this.email,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel(
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      name: data["name"] ?? '',
      phoneNo: data['phone'] ?? '',
    );
  }
}
