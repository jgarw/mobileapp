import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ReservationItem.dart';
import 'ReservationDAO.dart';
import 'ReservationDatabase.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:flutter_localizations/flutter_localizations.dart';
import '../generated/l10n.dart';

class AddReservation extends StatefulWidget {
  const AddReservation({super.key});

  @override
  _AddReservationState createState() => _AddReservationState();
}

class _AddReservationState extends State<AddReservation> {
  final _formKey = GlobalKey<FormState>();
  String? _reservationName;
  int? _customerId;
  int? _flightId;
  DateTime? _selectedDate;
  final _encryptedPrefs = EncryptedSharedPreferences();

  Future<void> _loadReservation() async {
    final savedName = await _encryptedPrefs.getString('Name');
    final savedFlightNum = await _encryptedPrefs.getString('Flight Number');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Reservation'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Reservation Name'),
                onSaved: (value) {
                  _reservationName = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name for the reservation';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Customer ID'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _customerId = int.tryParse(value ?? '');
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a customer ID';
                  } else if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Flight ID'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _flightId = int.tryParse(value ?? '');
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a flight ID';
                  } else if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                child: Text('Select Date'),
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now().subtract(Duration(days: 1)),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != _selectedDate) {
                    setState(() {
                      _selectedDate = picked;
                    });
                  }
                },
              ),
              SizedBox(height: 10),
              ElevatedButton(
                child: Text('Add Reservation'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final newReservation = Reservation(
                      id: null,
                      name: _reservationName!,
                      customerId: _customerId!,
                      flightId: _flightId!,
                      date: _selectedDate!.toIso8601String(),
                    );
                    final db = await initDatabase();
                    await db.reservationDao.insertReservation(newReservation);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}