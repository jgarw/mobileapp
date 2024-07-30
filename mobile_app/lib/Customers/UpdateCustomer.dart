import 'package:flutter/material.dart';
import 'package:mobile_app/Customers/CustomerDatabase.dart';
import 'CustomerItem.dart';
import 'CustomerDAO.dart';
import 'CustomersPage.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:path/path.dart';

class UpdateCustomer extends StatefulWidget {
  final Customer customer;

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


  Future<void> _updateCustomer() async {
    if (_dao == null) {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        const SnackBar(content: Text('Database not initialized')),
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
        const SnackBar(content: Text('Customer updated')),
      );
      Navigator.pop(context as BuildContext, true);
    } catch (e) {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        SnackBar(content: Text('Error updating customer: $e')),
      );
    }
    }

  Future<void> _deleteCustomer() async {
    // Ensure that the database is initialized
    if (_dao == null) {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        const SnackBar(content: Text('Database not initialized')),
      );
      return;
    }

    try {
      await _dao.deleteCustomer(widget.customer);
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        const SnackBar(content: Text('Customer deleted')),
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
        title: const Text('Update Customer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Address'),
            ),
            TextField(
              controller: _birthdayController,
              decoration: const InputDecoration(
                  labelText: 'Birthday (YYYY-MM-DD)'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ElevatedButton(
                  onPressed: _updateCustomer,
                  child: Text('Update'),
                ),
                ElevatedButton(
                  onPressed: _deleteCustomer,
                  child: Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}