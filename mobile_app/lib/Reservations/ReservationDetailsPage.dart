import 'package:flutter/material.dart';
import 'package:mobile_app/Reservations/ReservationDatabase.dart';
import 'ReservationDAO.dart';
import 'ReservationItem.dart';
import 'ReservationDatabase.dart';
import 'ReservationPage.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:path/path.dart';
import 'package:floor/floor.dart';

class ReservationDetailsPage extends StatelessWidget{
  final Reservation reservation;

  const ReservationDetailsPage({Key? key, required this.reservation}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservation Details'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([
          initDatabase().then((db) => db.customerDao.findAllCustomer()),
          initDatabase().then((db) => db.flightDao.findAllFlight()),
        ]),
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }
          else if (snapshot.hasError){
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          else if (snapshot.hasData){
            final customers = snapshot.data![0] as List<Customer>;
            final flights = snapshot.data![1] as List<Flight>;
            final customer = customers.firstWhere((c) => c.id ==reservation.customerId);
            final flight = flights.firstWhere((f) => f.id == reservation.flightId);

            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Reservation Name: ${reservation.name}', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 8),
                  Text('Customer Name: ${customer.name}', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 8),
                  Text('Flight Number: ${flight.number}', style: TextStyle(fontSize: 18)),
                  Text('From: ${flight.departureCity}', style: TextStyle(fontSize: 18)),
                  Text('To: ${flight.arrivalCity}', style: TextStyle(fontSize: 18)),
                  Text('Departure Time: ${flight.departureTime}', style: TextStyle(fontSize: 18)),
                  Text('Arrival Time: ${flight.arrivalTime}', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 8),
                  Text('Reservation Date: ${reservation.date}', style: TextStyle(fontSize: 18)),
                ],
              ),
            );
          } else {
            return Center(child: Text('No data found.'));
          }
        },
      ),
    );
  }
}