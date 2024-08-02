import 'package:floor/floor.dart';
import 'CustomerItem.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

@dao
abstract class CustomerDAO {
  @Query('SELECT * FROM Customer')
  Future<List<Customer>> findAllCustomers();

  @insert
  Future<void> insertCustomer(Customer customer);

  @update
  Future<void> updateCustomer(Customer customer);

  @delete
  Future<void> deleteCustomer(Customer customer);
}