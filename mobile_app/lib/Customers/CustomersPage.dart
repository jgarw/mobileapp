import 'package:flutter/material.dart';
import 'package:floor/floor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import '../generated/l10n.dart';
import 'CustomerItem.dart';
import 'CustomerDAO.dart';
import 'CustomerDatabase.dart';
import 'AddCustomer.dart';
import 'UpdateCustomer.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

/// A StatefulWidget that displays a list of customers and allows navigation to
/// add or update customer details.
///
/// The [CustomersPage] widget initializes the database, loads customers from
/// the database, and provides options to add a new customer or update existing
/// customer details.
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

  /// Initializes the database and sets up the DAO for database operations.
  ///
  /// This method builds the customer database and assigns the DAO for CRUD operations.
  /// It also loads the list of customers from the database.
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

  /// Loads the list of customers from the database.
  ///
  /// This method updates the state to fetch the list of customers using the DAO
  /// and triggers a rebuild of the widget.
  void _loadCustomers() {
    setState(() {
      _customers = _dao.findAllCustomers();
    });
  }


  /// Navigates to the [AddCustomer] screen.
  ///
  /// After returning from the [AddCustomer] screen, this method reloads the
  /// customer list to reflect any new additions.
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
        title:   Text(S.of(context).customerManagement),
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
            return  Center(child: Text(S.of(context).noCustomerFound));
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

