import 'package:flutter/material.dart';
import 'package:floor/floor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'CustomerItem.dart';
import 'CustomerDAO.dart';
import 'CustomerDatabase.dart';
import 'AddCustomer.dart';
import 'UpdateCustomer.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  _CustomersPageState createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  late CustomerDatabase _database;
  late CustomerDAO _dao;
  late Future<List<Customer>> _customers = Future.value([]);
  final _storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  void _initDatabase() async {
    try {
      final database = await $FloorCustomerDatabase.databaseBuilder('customer_database.db').build();
      _dao = database.customerDao;
      _loadCustomers();
    } catch (e) {
      // Handle the error appropriately
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Database initialization error: $e')));
    }
  }

  void _loadCustomers() {
    setState(() {
      _customers = _dao.findAllCustomers();
    });
  }


  void _navigateToAddCustomer() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddCustomer()),
    );
    if (result != null) {
      _loadCustomers();
      };
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
                    _loadCustomers();
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

