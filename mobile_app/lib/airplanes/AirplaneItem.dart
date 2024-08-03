import 'package:floor/floor.dart';

@entity
class AirplaneItem {
  static int ID = 1;

  @PrimaryKey() // Use autoGenerate to let the database manage IDs
  final int id;
  final String type;
  final int passengers;
  final double speed;
  final double range;

  AirplaneItem(this.id, this.type, this.passengers,
      this.speed, this.range) {
    if (id > ID) {
      ID = id;
    }
  }
}
