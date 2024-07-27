import "package:flutter/material.dart";
import "package:mobile_app/flights/FlightDAO.dart";
import "package:mobile_app/flights/FlightItem.dart";

class UpdateFlightPage extends StatefulWidget{

   final FlightDAO myDAO;
   final Function onUpdate;
   final FlightItem flight;

  UpdateFlightPage({required this.myDAO, required this.onUpdate, required this.flight});

  @override
  _UpdateFlightPageState createState() => _UpdateFlightPageState();
}

class _UpdateFlightPageState extends State<UpdateFlightPage> {
  late TextEditingController _departureCityController;
  late TextEditingController _arrivalCityController;
  late TextEditingController _departureTimeController;
  late TextEditingController _arrivalTimeController;

  @override
  void initState() {
    super.initState();
    _departureCityController = TextEditingController(text: widget.flight.departureCity);
    _arrivalCityController = TextEditingController(text: widget.flight.destinationCity);
    _departureTimeController = TextEditingController(text: widget.flight.departureTime);
    _arrivalTimeController = TextEditingController(text: widget.flight.arrivalTime);
  }

  @override
  void dispose() {
    _departureCityController.dispose();
    _arrivalCityController.dispose();
    _departureTimeController.dispose();
    _arrivalTimeController.dispose();
    super.dispose();
  }

///method to update item selected
  void _updateItem(){

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