import 'package:flutter/material.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'CustomerItem.dart';
import 'CustomerDAO.dart';
import 'CustomerDatabase.dart';
import 'AddCustomer.dart';
import 'UpdateCustomer.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  _CustomersPageState createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  late CustomerDatabase _database;
  late CustomerDAO _dao;
  late Future<List<Customer>> _customers = Future.value([]);

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  void _initDatabase() async {
    _database = await $FloorCustomerDatabase.databaseBuilder('app_database.db').build();
    _dao = _database.customerDao;
    _customers = _dao.findAllCustomers();
    if (mounted){
      setState(() {});
    }
  }

  void _navigateToAddCustomer() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddCustomer()),
    );
    if (result != null) {
      setState(() {
        _customers = _dao.findAllCustomers();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Management'),
      ),
      body: FutureBuilder<List<Customer>>(
        future: _customers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No customers found.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final customer = snapshot.data![index];
              return ListTile(
                title: Text('${customer.firstName} ${customer.lastName}'),
                subtitle: Text(customer.address),
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateCustomer(customer: customer),
                    ),
                  );
                  if (result != null) {
                    setState(() {
                      _customers = _dao.findAllCustomers();
                    });
                  }
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddCustomer,
        child: const Icon(Icons.add),
      ),
    );
  }
}
