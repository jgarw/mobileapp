// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AirplaneDatabase.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
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

  AirplaneDAO? _airplaneDAOInstance;

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
            'CREATE TABLE IF NOT EXISTS `AirplaneItem` (`id` INTEGER NOT NULL, `type` TEXT NOT NULL, `passengers` INTEGER NOT NULL, `speed` REAL NOT NULL, `range` REAL NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  AirplaneDAO get airplaneDAO {
    return _airplaneDAOInstance ??= _$AirplaneDAO(database, changeListener);
  }
}

class _$AirplaneDAO extends AirplaneDAO {
  _$AirplaneDAO(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _airplaneItemInsertionAdapter = InsertionAdapter(
            database,
            'AirplaneItem',
            (AirplaneItem item) => <String, Object?>{
                  'id': item.id,
                  'type': item.type,
                  'passengers': item.passengers,
                  'speed': item.speed,
                  'range': item.range
                }),
        _airplaneItemUpdateAdapter = UpdateAdapter(
            database,
            'AirplaneItem',
            ['id'],
            (AirplaneItem item) => <String, Object?>{
                  'id': item.id,
                  'type': item.type,
                  'passengers': item.passengers,
                  'speed': item.speed,
                  'range': item.range
                }),
        _airplaneItemDeletionAdapter = DeletionAdapter(
            database,
            'AirplaneItem',
            ['id'],
            (AirplaneItem item) => <String, Object?>{
                  'id': item.id,
                  'type': item.type,
                  'passengers': item.passengers,
                  'speed': item.speed,
                  'range': item.range
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<AirplaneItem> _airplaneItemInsertionAdapter;

  final UpdateAdapter<AirplaneItem> _airplaneItemUpdateAdapter;

  final DeletionAdapter<AirplaneItem> _airplaneItemDeletionAdapter;

  @override
  Future<List<AirplaneItem>> getAllAirplanes() async {
    return _queryAdapter.queryList('SELECT * FROM AirplaneItem',
        mapper: (Map<String, Object?> row) => AirplaneItem(
            row['id'] as int,
            row['type'] as String,
            row['passengers'] as int,
            row['speed'] as double,
            row['range'] as double));
  }

  @override
  Future<void> insertItem(AirplaneItem airplane) async {
    await _airplaneItemInsertionAdapter.insert(
        airplane, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateItem(AirplaneItem airplane) async {
    await _airplaneItemUpdateAdapter.update(airplane, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteItem(AirplaneItem airplane) async {
    await _airplaneItemDeletionAdapter.delete(airplane);
  }
}
