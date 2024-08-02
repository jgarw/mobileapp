import 'package:floor/floor.dart';
import 'CustomerDAO.dart';
import 'CustomerItem.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'dart:async';

part 'CustomerDatabase.g.dart'; // the generated code will be there

/// Represents the database for managing customer data.
///
/// The [CustomerDatabase] class extends [FloorDatabase] and provides access
/// to the [CustomerDAO] for performing CRUD operations on customer entities.
///
/// The database version is set to 1, and it includes the [Customer] entity.
@Database(version: 1, entities: [Customer])
abstract class CustomerDatabase extends FloorDatabase {

  /// Provides access to the Data Access Object (DAO) for [Customer] entities.
  ///
  /// The [customerDao] property allows for operations such as querying,
  /// inserting, updating, and deleting customer records in the database.
  CustomerDAO get customerDao;
}
