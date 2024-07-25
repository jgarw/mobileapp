import 'package:floor/floor.dart';

@entity
class FlightItem {
  static int ID = 1;

  @primaryKey
  final int id;
  final String departureCity;
  final String destinationCity;
  final String departureTime;
  final String arrivalTime;

  //constructor
  FlightItem(this.id, this.departureCity, this.destinationCity,
      this.departureTime, this.arrivalTime) {
    if (id > ID) {
      ID = id;
    }
  }
}
