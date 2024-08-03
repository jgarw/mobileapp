import "package:encrypted_shared_preferences/encrypted_shared_preferences.dart";
import "package:flutter/material.dart";
import "package:mobile_app/flights/FlightDAO.dart";
import "package:mobile_app/flights/FlightItem.dart";

/// create a class to hold page for updating a flight item
class UpdateFlightPage extends StatefulWidget{

  /// create reference to FlightDAO
   final FlightDAO myDAO;

   /// create reference to onUpdate function
   final Function onUpdate;

   /// create reference to FlightItem
   final FlightItem flight;

  UpdateFlightPage({required this.myDAO, required this.onUpdate, required this.flight});

  @override
  _UpdateFlightPageState createState() => _UpdateFlightPageState();
}

/// create a class to hold state of the page for updating a flight item
class _UpdateFlightPageState extends State<UpdateFlightPage> {

  /// create text editing controllers for the text fields
  late TextEditingController _departureCityController;
  late TextEditingController _arrivalCityController;
  late TextEditingController _departureTimeController;
  late TextEditingController _arrivalTimeController;

  /// create reference to EncryptedSharedPreferences
  /// this will be used to save and load data about flights
  final EncryptedSharedPreferences _prefs = EncryptedSharedPreferences();

  /// method to initialize the state
  @override
  void initState() {
    super.initState();

    // create the text editing controllers for the textfields with no preset values
    _departureCityController = TextEditingController();
    _arrivalCityController = TextEditingController();
    _departureTimeController = TextEditingController();
    _arrivalTimeController = TextEditingController();

    // load saved flight data from EncryptedSharedPreferences
    _loadSavedFlight();
  }

  @override
  void dispose() {
    _departureCityController.dispose();
    _arrivalCityController.dispose();
    _departureTimeController.dispose();
    _arrivalTimeController.dispose();
    super.dispose();
  }

  /// method to load saved flight data from EncryptedSharedPreferences
  Future<void> _loadSavedFlight() async {
    final savedDepartureCity = await _prefs.getString('departureCity');
    final savedArrivalCity = await _prefs.getString('arrivalCity');
    final savedDepartureTime = await _prefs.getString('departureTime');
    final savedArrivalTime = await _prefs.getString('arrivalTime');

    /// set the text in the textfields to the retrieved data from EncryptedSharedPreferences
    setState(() {
      _departureCityController.text = savedDepartureCity ?? '';
      _arrivalCityController.text = savedArrivalCity ?? '';
      _departureTimeController.text = savedDepartureTime ?? '';
      _arrivalTimeController.text = savedArrivalTime ?? '';
    });
  }


  /// method to save flight data to EncryptedSharedPreferences
   Future<void> _saveFlightData() async { 
    // Save data to EncryptedSharedPreferences
    await _prefs.setString('departureCity', _departureCityController.text);
    await _prefs.setString('arrivalCity', _arrivalCityController.text);
    await _prefs.setString('departureTime', _departureTimeController.text);
    await _prefs.setString('arrivalTime', _arrivalTimeController.text);
  }

///method to update item selected
  void _updateItem() async {
    await _saveFlightData();

    var updatedItem = FlightItem(
      FlightItem.ID,
      _departureCityController.text,
      _arrivalCityController.text,
      _departureTimeController.text,
      _arrivalTimeController.text
    );

    widget.myDAO.updateItem(updatedItem).then((_){
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