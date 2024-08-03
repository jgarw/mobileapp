import 'package:flutter/material.dart';
import 'package:mobile_app/Customers/CustomerDatabase.dart';
import '../generated/l10n.dart';
import 'CustomerItem.dart';
import 'CustomerDAO.dart';
import 'CustomersPage.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:path/path.dart';

/// A StatefulWidget that represents a screen for updating a customer's details.
///
/// The [UpdateCustomer] widget takes an existing [Customer] object as a parameter and
/// allows the user to update the customer's information.
class UpdateCustomer extends StatefulWidget {
  /// Creates an instance of [UpdateCustomer].
  ///
  /// The [customer] parameter is required and represents the customer to be updated.
  final Customer customer;

  /// Creates an instance of [UpdateCustomer] with the given [customer].
  const UpdateCustomer({super.key, required this.customer});

  @override
  _UpdateCustomerState createState() => _UpdateCustomerState();
}

class _UpdateCustomerState extends State<UpdateCustomer> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _addressController;
  late TextEditingController _birthdayController;
  late CustomerDAO _dao;

  @override
  void initState() {
    super.initState();
    _initDatabase();
    _firstNameController = TextEditingController(text: widget.customer.firstName);
    _lastNameController = TextEditingController(text: widget.customer.lastName);
    _addressController = TextEditingController(text: widget.customer.address);
    _birthdayController = TextEditingController(text: widget.customer.birthday);
  }


  /// Initializes the database and sets up the DAO for database operations.
  ///
  /// This method builds the customer database and assigns the DAO for CRUD operations.
  Future<void> _initDatabase() async {
    try {
      final database = await $FloorCustomerDatabase.databaseBuilder(
          'customer_database.db').build();
      _dao = database.customerDao;
    } catch (e) {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        SnackBar(content: Text('Database initialization error: $e')),
      );
    }
  }


  /// Updates the customer's details in the database.
  ///
  /// This method creates an updated [Customer] object with the values from the text
  /// controllers and then attempts to update the customer in the database.
  /// If successful, it displays a success message and pops the screen.
  Future<void> _updateCustomer() async {
    if (_dao == null) {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
         SnackBar(content: Text(S.of(context as BuildContext).databaseNotInitialized)),
      );
      return;
    }
    final updatedCustomer = Customer(
      id: widget.customer.id,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      address: _addressController.text,
      birthday: _birthdayController.text,
    );

    try {
      await _dao.updateCustomer(updatedCustomer);
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
         SnackBar(content: Text(S.of(context as BuildContext).customerUpdated)),
      );
      Navigator.pop(context as BuildContext, true);
    } catch (e) {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        SnackBar(content: Text('Error updating customer: $e')),
      );
    }
    }

  /// Deletes the customer from the database.
  ///
  /// This method attempts to delete the customer from the database and displays a
  /// success message if the operation is successful. If an error occurs, it displays
  /// an error message. After successful deletion, it pops the screen.
  Future<void> _deleteCustomer() async {
    // Ensure that the database is initialized
    if (_dao == null) {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
         SnackBar(content: Text(S.of(context as BuildContext).databaseNotInitialized)),
      );
      return;
    }

    try {
      await _dao.deleteCustomer(widget.customer);
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
         SnackBar(content: Text(S.of(context as BuildContext).customerDeleted)),
      );
      Navigator.pop(context as BuildContext, true);
    } catch (e) {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        SnackBar(content: Text('Error deleting customer: $e')),
      );
    }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(S.of(context).updateCustomer),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _firstNameController,
              decoration:  InputDecoration(labelText: S.of(context).firstName),
            ),
            TextField(
              controller: _lastNameController,
              decoration:  InputDecoration(labelText: S.of(context).lastName),
            ),
            TextField(
              controller: _addressController,
              decoration:  InputDecoration(labelText: S.of(context).address),
            ),
            TextField(
              controller: _birthdayController,
              decoration:  InputDecoration(
                  labelText: S.of(context).birthday),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ElevatedButton(
                  onPressed: _updateCustomer,
                  child: Text(S.of(context).update),
                ),
                ElevatedButton(
                  onPressed: _deleteCustomer,
                  child: Text(S.of(context).delete),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}