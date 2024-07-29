import 'package:flutter/material.dart';
import 'CustomerItem.dart';
import 'CustomerDAO.dart';
import 'CustomerDatabase.dart';

class UpdateCustomer extends StatefulWidget {
  final Customer customer;

  UpdateCustomer({required this.customer});

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

  void _initDatabase() async {
    final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    _dao = database.customerDao;
  }

  void _updateCustomer() async {
    final updatedCustomer = Customer(
      id: widget.customer.id,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      address: _addressController.text,
      birthday: _birthdayController.text,
    );

    await _dao.updateCustomer(updatedCustomer);
    Navigator.pop(context, true);
  }

  void _deleteCustomer() async {
    await _dao.deleteCustomer(widget.customer);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Update Customer'),
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
Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: <Widget>[
ElevatedButton(
onPressed: _updateCustomer,
child: Text('Update'),
},
ElevatedButton(
onPressed: _deleteCustomer,
child: Text('Delete'),
},
],
),
],
),
),
);
}
}
