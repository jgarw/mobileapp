import 'package:floor/floor.dart';
import 'ReservationItem.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

@dao
abstract class CustomerDAO{
  @Query('SELECT * FROM Customer')
  Future<List<Customer>> findAllCustomer();

  @insert
  Future<void> insertCustomer(Customer customer);
}

@dao
abstract class FlightDAO{
  @Query('SELECT * FROM Flight')
  Future<List<Flight>> findAllFlight();

  @insert
  Future<void> insertFlight(Flight flight);
}

@dao
abstract class ReservationDAO{
  @Query('SELECT * FROM Reservation')
  Future<List<Reservation>> findAllReservation();

  @insert
  Future<void> insertReservation(Reservation reservation);
}