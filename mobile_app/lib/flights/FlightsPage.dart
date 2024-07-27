// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/services.dart';
import 'package:mobile_app/flights/AddFlightPage.dart';
import 'package:mobile_app/flights/FlightsDatabase.dart';
import 'package:mobile_app/flights/UpdateFlightPage.dart';

import 'FlightDAO.dart';
import 'FlightsDatabase.dart';
import 'package:flutter/material.dart';
import 'FlightItem.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flight List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const FlightsPage(title: 'Flights'),
    );
  }
}

class FlightsPage extends StatefulWidget {
  const FlightsPage({super.key, required this.title});

  final String title;

  @override
  State<FlightsPage> createState() => _FlightsPage();
}

class _FlightsPage extends State<FlightsPage> {
  final List<FlightItem> _items = [];
  late FlightDAO myDAO;
  FlightItem? _selectedItem;

  @override
  void initState() {
    super.initState();

    $FloorFlightsDatabase
        .databaseBuilder('app_database.db')
        .build()
        .then((database) {
      myDAO = database.flightDAO;
      myDAO.getAllItems().then((listOfItems) {
        setState(() {
          _items.addAll(listOfItems);
          _refreshItems();
        });
      });
    });
  }

  void _refreshItems() {
    myDAO.getAllItems().then((listOfItems) {
      setState(() {
        _items.clear();
        _items.addAll(listOfItems);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _deleteItem(FlightItem item) {
    myDAO.deleteItem(item).then((_) {
      setState(() {
        _items.remove(item);
        _selectedItem = null;
      });
    });
  }

  void _onItemTapped(FlightItem item) {
    setState(() {
      _selectedItem = item;
    });
  }

  Widget _tabletView() {
    return Row(
      children: [
        Expanded(child: _itemList()),
        VerticalDivider(),
        Expanded(
          child: _selectedItem != null
              ? _detailsPage(_selectedItem!)
              : Center(child: Text('Select an item')),
        ),
      ],
    );
  }

  Widget _mobileView() {
    return _selectedItem != null ? _detailsPage(_selectedItem!) : _itemList();
  }

  Widget _itemList() {
    

    return ListView.builder(
      itemCount: _items.length,
      itemBuilder: (context, index) {
         return ListTile(
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Departure: ${_items[index].departureCity} ",
                style: TextStyle(fontSize: 20, color: Colors.black)
              ),
              WidgetSpan(
                child: Icon(Icons.flight_takeoff, size: 20),
              ),
              TextSpan(
                text: " Arrival: ${_items[index].destinationCity}\n",
               style: TextStyle(fontSize: 20, color: Colors.black)
              ),
              TextSpan(
                text: "Departure Time: ${_items[index].departureTime}",
                style: TextStyle(fontSize: 20, color: Colors.black)
              ),
              WidgetSpan(
                child: Icon(Icons.arrow_right_alt, size: 20),
              ),
              TextSpan(
                text: "Arrival Time: ${_items[index].arrivalTime}",
                style: TextStyle(fontSize: 20, color: Colors.black)
              ),
            ],
          ),
        ),
        onTap: () => _onItemTapped(_items[index]),
      );
    },
  );
  }

  Widget _detailsPage(FlightItem item) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
            "Fight Information: \nDeparture City: ${item.departureCity} \nDestination City: ${item.destinationCity} \nDeparture Time: ${item.departureTime} \nArrival Time: ${item.arrivalTime} ",
            style: TextStyle(fontSize: 20)),
        Text('Database ID: ${item.id}', style: TextStyle(fontSize: 14)),
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () => setState(() {
                        _selectedItem = null;
                      }),
                  child: Text('Cancel')),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () => _deleteItem(item),
                child: Text('Delete'),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    UpdateFlightPage(myDAO: myDAO, onUpdate: _refreshItems, flight: item,)),
          );
        },
                child: Text('Update'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          TextButton.icon(
            onPressed: () {
              SystemNavigator.pop();
            },
            icon: Icon(Icons.exit_to_app, color: Colors.purple),
            label: Text('Exit', style: TextStyle(color: Colors.purple)),
          ),
        ],
      ),
      body: Center(
        child:
            (width > height) && (width > 720) ? _tabletView() : _mobileView(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AddFlightPage(myDAO: myDAO, onAdd: _refreshItems)),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

