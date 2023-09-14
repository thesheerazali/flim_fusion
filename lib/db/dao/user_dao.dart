

import 'package:floor/floor.dart';

import '../entity/users.dart';

@dao
abstract class UserProfileDao {
  @Query('SELECT * FROM user_profiles')
  Future<List<UserProfile>> findAllUserProfiles();

  @Query('SELECT * FROM user_profiles WHERE email = :email')
  Future<UserProfile?> findUserProfileById(String email);

  @insert
  Future<void> insertUserProfile(UserProfile userProfile);

  @update
  Future<void> updateUserProfile(UserProfile userProfile);

  @delete
  Future<void> deleteUserProfile(UserProfile userProfile);
}
