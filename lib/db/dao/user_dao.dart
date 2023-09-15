

import 'package:floor/floor.dart';

import '../../model/user_model.dart';
import '../entity/users.dart';

@dao
abstract class UserProfileDao {
  @Query('SELECT * FROM users')
  Future<List<UserProfile>> findAllUserProfiles();

  @Query('SELECT * FROM users WHERE email = :email')
  Future<UserProfile?> findUserProfileById(String email);
   
  @Query('SELECT email FROM users')
  Future<List<String>> getEmails();

 // Modify the method name and parameter to accept UserModel

  @insert
  Future<void> insertUserProfile(UserProfile userProfile);

  @update
  Future<void> updateUserProfile(UserProfile userProfile);

  @delete
  Future<void> deleteUserProfile(UserProfile userProfile);
}
