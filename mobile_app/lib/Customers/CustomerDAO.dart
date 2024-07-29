import 'package:floor/floor.dart';
import 'CustomerDatabase.dart';
import 'CustomerItem.dart';


@dao
abstract class CustomerDAO {
  @Query('SELECT * FROM customers')
  Future<List<Customer>> findAllCustomers();

  @insert
  Future<void> insertCustomer(Customer customer);

  @update
  Future<void> updateCustomer(Customer customer);

  @delete
  Future<void> deleteCustomer(Customer customer);
}