import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'AirplaneDAO.dart';
import 'AirplaneItem.dart';

part 'AirplaneDatabase.g.dart'; // the generated code will be there

@Database(version: 1, entities: [AirplaneItem])
abstract class AppDatabase extends FloorDatabase {
  AirplaneDAO get airplaneDAO;
}
