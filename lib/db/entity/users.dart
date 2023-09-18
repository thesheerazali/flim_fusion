import 'package:floor/floor.dart';

@Entity(tableName: 'users')
class UserProfile {
  @primaryKey
  final String email;

  final String name;
  final String username;
  final String phone;
  // final String profileImageUrl;

  UserProfile({
    required this.name,
    required this.email,
    required this.username,
    required this.phone,
    // this.profileImageUrl,
  });

  factory UserProfile.fromFirestore(Map<String, dynamic> data) {
    return UserProfile(
      // Assuming 'uid' is a field in your Firestore document
      username: data['username'] ?? '', // Replace with the actual field name
      name: data['name'] ?? '',
      email: data['email'] ?? '', // Replace with the actual field name
      phone: data['phone'] ?? '',
    //  profileImageUrl: data['profileImageUrl'] ?? '', // Replace with the actual field name
    );
  }
}
