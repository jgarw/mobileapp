import 'package:flutter/material.dart';
import 'CustomerItem.dart';
import 'CustomerDAO.dart';
import 'CustomerDatabase.dart';

class AddCustomer extends StatefulWidget {
  @override
  _AddCustomerState createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _birthdayController = TextEditingController();
  late CustomerDAO _dao;

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  void _initDatabase() async {
    final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    _dao = database.customerDao;
  }

  void _saveCustomer() async {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _birthdayController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
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

    await _dao.insertCustomer(customer);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Customer'),
        ),
        body: Padding(
        padding: EdgeInsets.all(16.0),
    child: Column(
    children: <Widget>[
    TextField(
    controller: _firstNameController,
    decoration: InputDecoration(labelText: 'First Name'),
    ),
    TextField(
    controller: _lastNameController,
    decoration: InputDecoration(labelText: 'Last Name'),
  },
  TextField(
  controller: _addressController,
  decoration: InputDecoration(labelText: 'Address'),
},
TextField(
controller: _birthdayController,
decoration: InputDecoration(labelText: 'Birthday (YYYY-MM-DD)'),
},
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
