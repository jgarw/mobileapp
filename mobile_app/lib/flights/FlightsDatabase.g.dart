// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FlightsDatabase.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $FlightsDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $FlightsDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $FlightsDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<FlightsDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorFlightsDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $FlightsDatabaseBuilderContract databaseBuilder(String name) =>
      _$FlightsDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $FlightsDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$FlightsDatabaseBuilder(null);
}

class _$FlightsDatabaseBuilder implements $FlightsDatabaseBuilderContract {
  _$FlightsDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $FlightsDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $FlightsDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<FlightsDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$FlightsDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$FlightsDatabase extends FlightsDatabase {
  _$FlightsDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  FlightDAO? _flightDAOInstance;

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
            'CREATE TABLE IF NOT EXISTS `FlightItem` (`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, `departureCity` TEXT NOT NULL, `destinationCity` TEXT NOT NULL, `departureTime` TEXT NOT NULL, `arrivalTime` TEXT NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  FlightDAO get flightDAO {
    return _flightDAOInstance ??= _$FlightDAO(database, changeListener);
  }
}

class _$FlightDAO extends FlightDAO {
  _$FlightDAO(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _flightItemInsertionAdapter = InsertionAdapter(
            database,
            'FlightItem',
            (FlightItem item) => <String, Object?>{
                  'id': item.id,
                  'departureCity': item.departureCity,
                  'destinationCity': item.destinationCity,
                  'departureTime': item.departureTime,
                  'arrivalTime': item.arrivalTime
                }),
        _flightItemUpdateAdapter = UpdateAdapter(
            database,
            'FlightItem',
            ['id'],
            (FlightItem item) => <String, Object?>{
                  'id': item.id,
                  'departureCity': item.departureCity,
                  'destinationCity': item.destinationCity,
                  'departureTime': item.departureTime,
                  'arrivalTime': item.arrivalTime
                }),
        _flightItemDeletionAdapter = DeletionAdapter(
            database,
            'FlightItem',
            ['id'],
            (FlightItem item) => <String, Object?>{
                  'id': item.id,
                  'departureCity': item.departureCity,
                  'destinationCity': item.destinationCity,
                  'departureTime': item.departureTime,
                  'arrivalTime': item.arrivalTime
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<FlightItem> _flightItemInsertionAdapter;

  final UpdateAdapter<FlightItem> _flightItemUpdateAdapter;

  final DeletionAdapter<FlightItem> _flightItemDeletionAdapter;

  @override
  Future<List<FlightItem>> getAllItems() async {
    return _queryAdapter.queryList('SELECT * FROM FlightItem',
        mapper: (Map<String, Object?> row) => FlightItem(
            row['id'] as int,
            row['departureCity'] as String,
            row['destinationCity'] as String,
            row['departureTime'] as String,
            row['arrivalTime'] as String));
  }

  @override
  Future<void> insertItem(FlightItem flight) async {
    await _flightItemInsertionAdapter.insert(flight, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateItem(FlightItem flight) async {
    await _flightItemUpdateAdapter.update(flight, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteItem(FlightItem flight) async {
    await _flightItemDeletionAdapter.delete(flight);
  }
}
