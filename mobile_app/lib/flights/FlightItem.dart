import 'package:floor/floor.dart';

/// this class represents a flight item in the database
/// it has an id, departure city, destination city, departure time, and arrival time
/// 
/// @author: Joseph Garwood
@entity
class FlightItem {
  /// static variable to hold the current ID
  static int ID = 1;

  /// Create an ID for the item that is auto-generated
  @PrimaryKey(autoGenerate: true)
  final int id;

  /// Create a variable to hold the departure city
  final String departureCity;

  /// Create a variable to hold the destination city
  final String destinationCity;

  /// Create a variable to hold the departure time
  final String departureTime;

  /// Create a variable to hold the arrival time
  final String arrivalTime;

  /// constructor for the FlightItem 
  /// @param id the id of the item
  /// @param departureCity the departure city of the item
  /// @param destinationCity the destination city of the item
  /// @param departureTime the departure time of the item
  /// @param arrivalTime the arrival time of the item
  FlightItem(this.id, this.departureCity, this.destinationCity,
      this.departureTime, this.arrivalTime) {
    if (id > ID) {
      ID = id;
    }
  }
}
