
import 'package:floor/floor.dart';

import 'FlightItem.dart';

/// this class acts as the data access object for the FlightItem in the databse
/// it has methods to get all items, insert an item, delete an item, and update an item in the database
/// 
/// @author: Joseph Garwood
@dao
abstract class FlightDAO {

  /// method to get all items from the database using a "select *" query
  @Query('SELECT * FROM FlightItem')
  Future<List<FlightItem>> getAllItems();

  /// method to insert an item into the database
  /// @param flight the flight item to be inserted
  @insert
  Future<void> insertItem(FlightItem flight);

  /// method to delete an item from the database
  /// @param flight the flight item to be deleted
  @delete
  Future<void> deleteItem(FlightItem flight);

  /// method to update an item in the database
  /// @param flight the flight item to be updated
  @update
  Future<void> updateItem(FlightItem flight);

}
