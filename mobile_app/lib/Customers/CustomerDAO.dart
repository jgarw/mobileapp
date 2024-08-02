import 'package:floor/floor.dart';
import 'CustomerItem.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

/// Data Access Object (DAO) for managing [Customer] entities.
///
/// The [CustomerDAO] provides methods for performing CRUD operations on
/// [Customer] records in the database. It allows for querying, inserting,
/// updating, and deleting customer data.
@dao
abstract class CustomerDAO {
  /// Retrieves all [Customer] entities from the database.
  ///
  /// This method performs a query to fetch a list of all customer records.
  /// It returns a [Future] that resolves to a [List] of [Customer] objects.
  @Query('SELECT * FROM Customer')
  Future<List<Customer>> findAllCustomers();

  /// Inserts a new [Customer] entity into the database.
  ///
  /// This method takes a [Customer] object as a parameter and adds it to
  /// the database. If a customer with the same primary key already exists,
  /// it will be replaced.
  @insert
  Future<void> insertCustomer(Customer customer);

  /// Updates an existing [Customer] entity in the database.
  ///
  /// This method takes a [Customer] object with an existing primary key
  /// and updates the corresponding record in the database.
  @update
  Future<void> updateCustomer(Customer customer);

  /// Deletes a [Customer] entity from the database.
  ///
  /// This method takes a [Customer] object with an existing primary key
  /// and removes the corresponding record from the database.
  @delete
  Future<void> deleteCustomer(Customer customer);
}