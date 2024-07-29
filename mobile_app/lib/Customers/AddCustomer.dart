import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'CustomerItem.dart';
import 'CustomerDAO.dart';
import 'CustomerDatabase.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

class AddCustomer extends StatefulWidget {
  const AddCustomer({super.key});

  @override
  _AddCustomerState createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _birthdayController = TextEditingController();
  CustomerDAO? _dao;

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  void _initDatabase() async {
    final database = await $FloorCustomerDatabase.databaseBuilder('app_database.db').build();
    _dao = database.customerDao;
  }

  void _saveCustomer() async {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _birthdayController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

   /* if (_dao == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Database not initialized')),
      );
      return;
    }*/

    final customer = Customer(
      id: null,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      address: _addressController.text,
      birthday: _birthdayController.text,
    );
    try {
      await _dao!.insertCustomer(customer);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Customer added')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }

    Navigator.pop(context, true);


    // Show AlertDialog to ask user if they want to save details for next time
    final saveForNextTime = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Save Details'),
          content: const Text('Do you want to save these details for next time?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () => Navigator.pop(context, false),
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        );
      },
    );

    // Save customer to database
    //await _dao.insertCustomer(customer);

    if (saveForNextTime ?? false) {
      // Save customer details using SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('firstName', customer.firstName);
      await prefs.setString('lastName', customer.lastName);
      await prefs.setString('address', customer.address);
      await prefs.setString('birthday', customer.birthday);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Customer details saved for next time')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Customer added')),
      );
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Customer'),
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
        controller : _addressController,
        decoration : const InputDecoration(labelText: 'Address'),
          ),
        TextField(
        controller : _birthdayController,
        decoration : const InputDecoration(labelText: 'Birthday (YYYY-MM-DD)'),
        ),
        ElevatedButton(
        onPressed: _saveCustomer,
        child: Text('Save'),
        ),
        ],
        ),
        ),
        );
        }
        }
