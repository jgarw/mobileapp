import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/flights/FlightDAO.dart';
import 'package:mobile_app/flights/FlightItem.dart';

/// create a second page that will hold textfields for user to enter flight data to add an item to the list
class AddFlightPage extends StatefulWidget {
  /// Flight DAO that will be used to interact with the database
  final FlightDAO myDAO;

  /// function to call when an item is added
  final Function onAdd;

  /// constructor for the AddFlightPage
  AddFlightPage({required this.myDAO, required this.onAdd});

  @override
  _AddFlightPageState createState() => _AddFlightPageState();
}

/// State of the AddFlightPage
class _AddFlightPageState extends State<AddFlightPage> {
  final EncryptedSharedPreferences _prefs = EncryptedSharedPreferences();

  /// Text editing controller for departure city that will be set when user types in the textfield
  late TextEditingController _departureCityController;

  /// Text editing controller for arrival city that will be set when user types in the textfield
  late TextEditingController _arrivalCityController;

  /// Text editing controller for departure time that will be set when user types in the textfield
  late TextEditingController _departureTimeController;

  /// Text editing controller for arrival time that will be set when user types in the textfield
  late TextEditingController _arrivalTimeController;

  /// Initialize the state of the widget and create the text editing controllers
  @override
  void initState() {
    super.initState();
    // create the text editing controllers for the textfields with no preset values
    _departureCityController = TextEditingController();
    _arrivalCityController = TextEditingController();
    _departureTimeController = TextEditingController();
    _arrivalTimeController = TextEditingController();
  }

  /// Dispose of the text editing controllers when the widget is disposed
  @override
  void dispose() {
    _departureCityController.dispose();
    _arrivalCityController.dispose();
    _departureTimeController.dispose();
    _arrivalTimeController.dispose();
    super.dispose();
  }

  void _invalidFieldAlert(String field) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Invalid Field"),
          content: Text("Please enter a valid $field"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  /// method to add an item to the list when the user presses the button
  void _addItem() async {
    // Save new flight data to EncryptedSharedPreferences
    if (_departureCityController.text.isEmpty) {
      _invalidFieldAlert("Please enter a departure city");
      return;
    } else {
      await _prefs.setString('departureCity', _departureCityController.text);
    }

    if (_arrivalCityController.text.isEmpty) {
      _invalidFieldAlert("Please enter an arrival city");
      return;
    } else {
      await _prefs.setString('arrivalCity', _departureCityController.text);
    }

    if (_departureTimeController.text.isEmpty) {
      _invalidFieldAlert("Please enter a departure time");
      return;
    } else {
      await _prefs.setString('departureTime', _departureCityController.text);
    }

    if (_arrivalTimeController.text.isEmpty) {
      _invalidFieldAlert("Please enter an arrival time");
      return;
    } else {
      await _prefs.setString('arrivalTime', _departureCityController.text);
    }

    /// create a new FlightItem with the text from the textfields
    var newItem = FlightItem(
        FlightItem.ID + 1,
        _departureCityController.text,
        _arrivalCityController.text,
        _departureTimeController.text,
        _arrivalTimeController.text);

    /// insert the item into the database and call the onAdd function
    widget.myDAO.insertItem(newItem).then((_) {
      widget.onAdd();
      Navigator.pop(context);
    });
  }

  /// build the widget with textfields for user to enter flight data
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Flight'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // create a textfield for the user to enter the departure city of the flight
            TextField(
              controller: _departureCityController,
              decoration: InputDecoration(
                hintText: "Type here",
                border: OutlineInputBorder(),
                labelText: "Enter a Departure City:",
              ),
            ),

            // add space between the textfields
            SizedBox(height: 8),

            // create a textfield for the user to enter the arrival city of the flight
            TextField(
              controller: _arrivalCityController,
              decoration: InputDecoration(
                hintText: "Type here",
                border: OutlineInputBorder(),
                labelText: "Enter an Arrival City:",
              ),
            ),

            // add space between the textfields
            SizedBox(height: 8),

            // create a textfield for the user to enter the departure time of the flight
            TextField(
              controller: _departureTimeController,
              decoration: InputDecoration(
                hintText: "Type here",
                border: OutlineInputBorder(),
                labelText: "Enter a Departure Time:",
              ),
            ),

            // add space between the textfields
            SizedBox(height: 8),

            // create a textfield for the user to enter the arrival time of the flight
            TextField(
              controller: _arrivalTimeController,
              decoration: InputDecoration(
                hintText: "Type here",
                border: OutlineInputBorder(),
                labelText: "Enter an Arrival Time:",
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addItem,
              child: Text('Add Flight'),
            ),
          ],
        ),
      ),
    );
  }
}
