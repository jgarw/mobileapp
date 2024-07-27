
import 'package:floor/floor.dart';

import 'FlightItem.dart';

@dao
abstract class FlightDAO {
  @Query('SELECT * FROM FlightItem')
  Future<List<FlightItem>> getAllItems();

  @insert
  Future<void> insertItem(FlightItem flight);

  @delete
  Future<void> deleteItem(FlightItem flight);

  @update
  Future<void> updateItem(FlightItem flight);

}
