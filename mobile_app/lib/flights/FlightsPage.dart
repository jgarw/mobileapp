import 'package:flutter/services.dart';
import 'package:mobile_app/flights/FlightsDatabase.dart';

import 'FlightDAO.dart';
import 'FlightsDatabase.dart';
import 'package:flutter/material.dart';
import 'FlightItem.dart';
import 'AddFlightPage.dart';

void main() {
  runApp(const MyApp());
}

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
      home: const MyHomePage(title: 'Flights'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
          title: Text("Departure: " +
              _items[index].departureCity +
              " -> Arrival: " +
              _items[index].destinationCity +
              "\n" +
              "Departure Time: " +
              _items[index].departureTime +
              " -> Arrival Time: " +
              _items[index].arrivalTime),
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

class AddFlightPage extends StatefulWidget {
  final FlightDAO myDAO;
  final Function onAdd;

  AddFlightPage({required this.myDAO, required this.onAdd});

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
        FlightItem.ID + 1,
        _departureCityController.text,
        _arrivalCityController.text,
        _departureTimeController.text,
        _arrivalTimeController.text);
    widget.myDAO.insertItem(newItem).then((_) {
      widget.onAdd();
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
