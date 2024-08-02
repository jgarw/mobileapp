import 'dart:async';
import 'FlightDAO.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'FlightItem.dart';

part 'FlightsDatabase.g.dart'; // the generated code will be in this file

/// Database class for the flights database
@Database(version: 1, entities: [FlightItem])
abstract class FlightsDatabase extends FloorDatabase {
  /// Get the flight data access object
  FlightDAO get flightDAO;
}
