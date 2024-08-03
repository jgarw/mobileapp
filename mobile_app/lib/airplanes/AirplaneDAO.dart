import 'package:floor/floor.dart';
import 'AirplaneItem.dart';

@dao
abstract class AirplaneDAO {

  @Query("SELECT * FROM AirplaneItem")
  Future<List<AirplaneItem>> getAllAirplanes();

  @insert
  Future<void> insertItem(AirplaneItem airplane);

  @delete
  Future<void> deleteItem(AirplaneItem airplane);

  @update
  Future<void> updateItem(AirplaneItem airplane);
}
