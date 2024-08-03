import 'package:flutter/material.dart';
import 'package:floor/floor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import '../generated/l10n.dart';
import 'ReservationDatabase.dart';
import 'ReservationDAO.dart';
import 'ReservationItem.dart';
import 'AddReservation.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'ReservationDetailsPage.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({super.key, required this.title});
  final String title;

  @override
  _ReservationPageState createState() => _ReservationPageState();

}
  class _ReservationPageState extends State<ReservationPage> {
    late ReservationDAO _resDao;
    late Future<List<Reservation>> _reservations = Future.value([]);


    @override
    void initState() {
      super.initState();
      _initDatabase();
    }

    void _initDatabase() async {
      try {
        final database = await $FloorReservationDatabase.databaseBuilder(
            'reservation_database.db').build();
        _resDao = database.reservationDao;
        _loadReservation();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Database initialization error: $e')));
      }
    }

    void _loadReservation() {
      setState(() {
        _reservations = _resDao.findAllReservation();
      });
    }

    void _navigateToAddReservation() async {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddReservation()),
      );
      if (result != null) {
        _loadReservation();
      };
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Reservations'),
        ),
        body: FutureBuilder<List<Reservation>>(
          future: _reservations,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No reservations found'));
            }
            else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final reservation = snapshot.data![index];
                  return ListTile(
                    title: Text(reservation.name),
                    subtitle: Text('Customer ID: ${reservation
                        .customerId}, Flight ID: ${reservation.flightId}'),
                    onTap: () async {
                      final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ReservationDetailsPage(
                                    reservation: reservation),
                          )
                      );
                      if (result != null) {
                        _loadReservation();
                      }
                    },
                  );
                },
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _navigateToAddReservation,
          child: const Icon(Icons.add),
        ),
      );
    }
  }
