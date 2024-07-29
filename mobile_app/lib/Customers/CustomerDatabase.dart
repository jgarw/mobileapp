import 'package:floor/floor.dart';
import 'CustomerDAO.dart';
import 'CustomerItem.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'dart:async';

part 'CustomerDatabase.g.dart'; // the generated code will be there

@Database(version: 1, entities: [Customer])
abstract class CustomerDatabase extends FloorDatabase {
  CustomerDAO get customerDao;
}
