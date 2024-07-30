import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
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
  final _encryptedPrefs = EncryptedSharedPreferences();

  void _initDatabase() async {
    final database = await $FloorCustomerDatabase.databaseBuilder('customer_database.db').build();
    _dao = database.customerDao;
  }

  @override
  void initState() {
    super.initState();
    _initDatabase();
    _loadSavedCustomer();
  }

  Future<void> _loadSavedCustomer() async {
    final savedFirstName = await _encryptedPrefs.getString('firstName');
    final savedLastName = await _encryptedPrefs.getString('lastName');
    final savedAddress = await _encryptedPrefs.getString('address');
    final savedBirthday = await _encryptedPrefs.getString('birthday');

    if (savedFirstName != null) {
      _firstNameController.text = savedFirstName;
    }
    if (savedLastName != null) {
      _lastNameController.text = savedLastName;
    }
    if (savedAddress != null) {
      _addressController.text = savedAddress;
    }
    if (savedBirthday != null) {
      _birthdayController.text = savedBirthday;
    }
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

    if (_dao == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Database not initialized')),
      );
      return;
    }

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
      // Save customer details using EncryptedSharedPreferences
      await _encryptedPrefs.setString('firstName', customer.firstName);
      await _encryptedPrefs.setString('lastName', customer.lastName);
      await _encryptedPrefs.setString('address', customer.address);
      await _encryptedPrefs.setString('birthday', customer.birthday);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Customer details saved for next time')),
      );
    } else {
      // Clear saved customer details
      await _encryptedPrefs.remove('firstName');
      await _encryptedPrefs.remove('lastName');
      await _encryptedPrefs.remove('address');
      await _encryptedPrefs.remove('birthday');
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
