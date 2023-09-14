import 'package:floor/floor.dart';

@Entity(tableName: 'user_profiles')
class UserProfile {
  @primaryKey
  final String? email;
  

  final String name;
  final String username;
  final String phone;

  UserProfile({
   
    required this.name,
    required this.email,
    required this.username,
    required this.phone,
  });
}