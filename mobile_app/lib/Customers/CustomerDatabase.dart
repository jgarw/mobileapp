import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:floor/floor.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'CustomerDAO.dart';

part 'CustomerDatabase.g.dart'; // the generated code will be there

@Database(version: 1, entities: [Customer])
abstract class AppDatabase extends FloorDatabase {
  CustomerDAO get customerDao;
}