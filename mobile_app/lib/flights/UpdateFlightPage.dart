import "package:flutter/material.dart";
import "package:mobile_app/flights/FlightDAO.dart";
import "package:mobile_app/flights/FlightItem.dart";

/// Page for updating a flight item.
class UpdateFlightPage extends StatefulWidget {
  /// DAO for interacting with the database.
  final FlightDAO myDAO;

  /// Function to call when an item is updated.
  final Function onUpdate;

  /// Flight item to be updated.
  final FlightItem flight;

  /// Constructs the [UpdateFlightPage] with the necessary data and functions.
  UpdateFlightPage({
    required this.myDAO,
    required this.onUpdate,
    required this.flight,
  });

  @override
  _UpdateFlightPageState createState() => _UpdateFlightPageState();
}

/// State class for [UpdateFlightPage].
class _UpdateFlightPageState extends State<UpdateFlightPage> {
  /// Text editing controllers for the text fields.
  late TextEditingController _departureCityController;
  late TextEditingController _arrivalCityController;
  late TextEditingController _departureTimeController;
  late TextEditingController _arrivalTimeController;

  /// Initialize the state and text controllers with the flight data.
  @override
  void initState() {
    super.initState();

    // Initialize the text controllers with the current flight data.
    _departureCityController =
        TextEditingController(text: widget.flight.departureCity);
    _arrivalCityController =
        TextEditingController(text: widget.flight.destinationCity);
    _departureTimeController =
        TextEditingController(text: widget.flight.departureTime);
    _arrivalTimeController =
        TextEditingController(text: widget.flight.arrivalTime);
  }

  /// Dispose of the text editing controllers when the widget is disposed.
  @override
  void dispose() {
    _departureCityController.dispose();
    _arrivalCityController.dispose();
    _departureTimeController.dispose();
    _arrivalTimeController.dispose();
    super.dispose();
  }

  /// Method to update the selected item in the database.
  void _updateItem() {
    var updatedItem = FlightItem(
      widget.flight.id, // Ensure the ID remains the same
      _departureCityController.text,
      _arrivalCityController.text,
      _departureTimeController.text,
      _arrivalTimeController.text,
    );

    // Update the item in the database and call the onUpdate function.
    widget.myDAO.updateItem(updatedItem).then((_) {
      widget.onUpdate();
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Flight'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _departureCityController,
              decoration: InputDecoration(
                hintText: "Type here",
                border: OutlineInputBorder(),
                labelText: "Enter a Departure City:",
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _arrivalCityController,
              decoration: InputDecoration(
                hintText: "Type here",
                border: OutlineInputBorder(),
                labelText: "Enter an Arrival City:",
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _departureTimeController,
              decoration: InputDecoration(
                hintText: "Type here",
                border: OutlineInputBorder(),
                labelText: "Enter a Departure Time:",
              ),
            ),
            SizedBox(height: 8),
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
              onPressed: _updateItem,
              child: Text('Update Flight'),
            ),
          ],
        ),
      ),
    );
  }
}
