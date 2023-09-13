class UserModel {
  final String uid;
  final String name; // Firebase User ID
  final String username;
  final String email;
  final String phone;

  UserModel( {
   required this.name,
    required this.uid,
    required this.username,
    required this.email,
    required this.phone,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ??
          '', // Assuming 'uid' is a field in your Firestore document
      username: data['username'] ?? '', // Replace with the actual field name
       name: data['name'] ?? '',
      email: data['email'] ?? '', // Replace with the actual field name
      phone: data['phone'] ?? '', // Replace with the actual field name
    );
  }
}
