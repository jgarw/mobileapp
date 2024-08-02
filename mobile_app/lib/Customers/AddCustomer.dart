import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../generated/l10n.dart';
import 'CustomerItem.dart';
import 'CustomerDAO.dart';
import 'CustomerDatabase.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:flutter_localizations/flutter_localizations.dart';


/// A StatefulWidget that represents a screen for adding a customer.
class AddCustomer extends StatefulWidget {

  /// Creates an instance of [AddCustomer].
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

  /// Initializes the database and sets up the DAO for database operations.
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

  /// Loads saved customer details from [EncryptedSharedPreferences] and populates the text fields.
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


  /// Saves the customer details to the database and optionally saves them for future use.
  /// Shows a confirmation dialog to ask if the details should be saved for the next time.
  void _saveCustomer() async {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _birthdayController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text(S.of(context).pleaseFillAllFields)),
      );
      return;
    }

    if (_dao == null) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text(S.of(context).databaseNotInitialized)),
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
         SnackBar(content: Text(S.of(context).customerAdded)),
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
          title: Text(S.of(context).saveDetails),
          content: Text(S.of(context).saveForNextTime),
          actions: <Widget>[
            TextButton(
              child:  Text(S.of(context).no),
              onPressed: () => Navigator.pop(context, false),
            ),
            TextButton(
              child:  Text(S.of(context).yes),
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
         SnackBar(content: Text(S.of(context).saveForNextTime)),
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
          title:  Text(S.of(context).addCustomer),
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
        controller : _addressController,
        decoration :  InputDecoration(labelText: S.of(context).address),
          ),
        TextField(
        controller : _birthdayController,
        decoration :  InputDecoration(labelText: S.of(context).birthday),
        ),
        ElevatedButton(
        onPressed: _saveCustomer,
        child: Text(S.of(context).save),
        ),
        ],
        ),
        ),
        );
        }
        }
