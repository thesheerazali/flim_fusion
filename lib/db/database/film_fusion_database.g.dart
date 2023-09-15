// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'film_fusion_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  UserProfileDao? _userProfileDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `users` (`email` TEXT NOT NULL, `name` TEXT NOT NULL, `username` TEXT NOT NULL, `phone` TEXT NOT NULL, PRIMARY KEY (`email`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  UserProfileDao get userProfileDao {
    return _userProfileDaoInstance ??=
        _$UserProfileDao(database, changeListener);
  }
}

class _$UserProfileDao extends UserProfileDao {
  _$UserProfileDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _userProfileInsertionAdapter = InsertionAdapter(
            database,
            'users',
            (UserProfile item) => <String, Object?>{
                  'email': item.email,
                  'name': item.name,
                  'username': item.username,
                  'phone': item.phone
                }),
        _userProfileUpdateAdapter = UpdateAdapter(
            database,
            'users',
            ['email'],
            (UserProfile item) => <String, Object?>{
                  'email': item.email,
                  'name': item.name,
                  'username': item.username,
                  'phone': item.phone
                }),
        _userProfileDeletionAdapter = DeletionAdapter(
            database,
            'users',
            ['email'],
            (UserProfile item) => <String, Object?>{
                  'email': item.email,
                  'name': item.name,
                  'username': item.username,
                  'phone': item.phone
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<UserProfile> _userProfileInsertionAdapter;

  final UpdateAdapter<UserProfile> _userProfileUpdateAdapter;

  final DeletionAdapter<UserProfile> _userProfileDeletionAdapter;

  @override
  Future<List<UserProfile>> findAllUserProfiles() async {
    return _queryAdapter.queryList('SELECT * FROM users',
        mapper: (Map<String, Object?> row) => UserProfile(
            name: row['name'] as String,
            email: row['email'] as String,
            username: row['username'] as String,
            phone: row['phone'] as String));
  }

  @override
  Future<UserProfile?> findUserProfileById(String email) async {
    return _queryAdapter.query('SELECT * FROM users WHERE email = ?1',
        mapper: (Map<String, Object?> row) => UserProfile(
            name: row['name'] as String,
            email: row['email'] as String,
            username: row['username'] as String,
            phone: row['phone'] as String),
        arguments: [email]);
  }

  @override
  Future<List<String>> getEmails() async {
    return _queryAdapter.queryList('SELECT email FROM users',
        mapper: (Map<String, Object?> row) => row.values.first as String);
  }

  @override
  Future<void> insertUserProfile(UserProfile userProfile) async {
    await _userProfileInsertionAdapter.insert(
        userProfile, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateUserProfile(UserProfile userProfile) async {
    await _userProfileUpdateAdapter.update(
        userProfile, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteUserProfile(UserProfile userProfile) async {
    await _userProfileDeletionAdapter.delete(userProfile);
  }
}
