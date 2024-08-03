import 'package:floor/floor.dart';
import 'ReservationDAO.dart';
import 'ReservationItem.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'dart:async';

part 'ReservationDatabase.g.dart';

@Database(version: 1, entities: [Customer, Flight, Reservation])
abstract class ReservationDatabase extends FloorDatabase{
  CustomerDAO get customerDao;
  FlightDAO get flightDao;
  ReservationDAO get reservationDao;
}

Future<ReservationDatabase> initDatabase() async{
  return await $FloorReservationDatabase.databaseBuilder('reservation_database.db').build();
}