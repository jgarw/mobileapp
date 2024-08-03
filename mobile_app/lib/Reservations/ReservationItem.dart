import 'package:floor/floor.dart';
import 'ReservationDAO.dart';
import 'ReservationDatabase.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

@Entity(tableName: 'Customer')
class Customer{
  @primaryKey
  final int? id;
  final String name;

  Customer({
    required this.id,
    required this.name,
});
}

@Entity(tableName: 'Flight')
class Flight{
  @primaryKey
  final int? id;
  final String number;
  final String departureCity;
  final String arrivalCity;
  final String departureTime;
  final String arrivalTime;

  Flight({
    required this.id,
    required this.number,
    required this.departureCity,
    required this.arrivalCity,
    required this.departureTime,
    required this.arrivalTime,
  });
  DateTime get departureDateTime => DateTime.parse(departureTime);
  DateTime get arrivalDateTime => DateTime.parse(arrivalTime);
}

@Entity(tableName: 'Reservation')
class Reservation{
  @primaryKey
  final int? id;
  final String name;
  final int customerId;
  final int flightId;
  final String date;

  Reservation({
    required this.id,
    required this.name,
    required this.customerId,
    required this.flightId,
    required this.date,
});
}
