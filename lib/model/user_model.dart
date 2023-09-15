// import 'package:floor/floor.dart';

// @Entity(tableName: 'user_models')
// class UserModel {
//   @primaryKey
//   final String email;


//   final String name; // Firebase User ID
//   final String username;

//   final String phone;

//   UserModel({
//     required this.name,
//     required this.username,
//     required this.email,
//     required this.phone,
//   });

//   factory UserModel.fromFirestore(Map<String, dynamic> data) {
//     return UserModel(
    
//            // Assuming 'uid' is a field in your Firestore document
//       username: data['username'] ?? '', // Replace with the actual field name
//       name: data['name'] ?? '',
//       email: data['email'] ?? '', // Replace with the actual field name
//       phone: data['phone'] ?? '', // Replace with the actual field name
//     );
//   }
// }
