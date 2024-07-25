import 'package:flutter/material.dart';
import 'FlightDAO.dart';
import 'FlightItem.dart';

class AddFlightPage extends StatefulWidget {
  final FlightDAO myDAO;

  AddFlightPage({required this.myDAO});

  @override
  _AddFlightPageState createState() => _AddFlightPageState();
}

class _AddFlightPageState extends State<AddFlightPage> {
  late TextEditingController _departureCityController;
  late TextEditingController _arrivalCityController;
  late TextEditingController _departureTimeController;
  late TextEditingController _arrivalTimeController;

  @override
  void initState() {
    super.initState();
    _departureCityController = TextEditingController();
    _arrivalCityController = TextEditingController();
    _departureTimeController = TextEditingController();
    _arrivalTimeController = TextEditingController();
  }

  @override
  void dispose() {
    _departureCityController.dispose();
    _arrivalCityController.dispose();
    _departureTimeController.dispose();
    _arrivalTimeController.dispose();
    super.dispose();
  }

  void _addItem() {
    var newItem = FlightItem(
        FlightItem.ID + DateTime.now().millisecondsSinceEpoch,
        _departureCityController.text,
        _arrivalCityController.text,
        _departureTimeController.text,
        _arrivalTimeController.text);
    widget.myDAO.insertItem(newItem).then((_) {
      Navigator.pop(context);
    });
  }

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
              onPressed: _addItem,
              child: Text('Add Flight'),
            ),
          ],
        ),
      ),
    );
  }
}
