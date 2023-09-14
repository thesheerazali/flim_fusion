





import 'package:film_fusion/db/dao/user_dao.dart';

import '../database/film_fusion_database.dart';


abstract class LocalDbService {
  static Future<AppDatabase> get _db async =>
      $FloorAppDatabase.databaseBuilder(AppDatabase.dbName).build();


    static Future<UserProfileDao> get usersDao async => (await _db).userProfileDao;



    
}


// class LocalDbService2 {
//   static AppDatabase? _database;

//   static Future<AppDatabase?> get database async {
  
//       _database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
   
//     return _database;
//   }
// }