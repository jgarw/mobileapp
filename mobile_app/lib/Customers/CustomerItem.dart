import 'package:floor/floor.dart';
import 'CustomerDAO.dart';
import 'CustomerDatabase.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:floor/floor.dart';

@entity
class Customer {
  @primaryKey
  final int? id;
  final String firstName;
  final String lastName;
  final String address;
  final String birthday; // Store as String

  Customer({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.birthday, // Pass as String
  });

  // Convert String to DateTime
  DateTime get birthdayDateTime => DateTime.parse(birthday);

  // Convert DateTime to String
  String get birthdayString => birthdayDateTime.toIso8601String();

  // Convert the Customer object to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'address': address,
      'birthday': birthdayString,
    };
  }

  // Create a Customer object from a map
  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      address: map['address'],
      birthday: map['birthday'], // Assume it's a String
    );
  }
}
