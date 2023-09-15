import 'dart:async';

import 'package:film_fusion/model/user_model.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../dao/user_dao.dart';
import '../entity/users.dart';

part 'film_fusion_database.g.dart'; // the generated code will be there

@Database(
  version: 1,
  entities: [UserProfile],
)
abstract class AppDatabase extends FloorDatabase {
  static const String dbName = "flim_fusion5.db";

  UserProfileDao get userProfileDao;
}
