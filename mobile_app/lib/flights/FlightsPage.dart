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

/// the main Flights page widget
/// @author: Joseph Garwood
class FlightsPage extends StatefulWidget {
  const FlightsPage({super.key, required this.title});

/// variable to hold the title of the Flights page
  final String title;

  @override
  State<FlightsPage> createState() => _FlightsPage();
}

/// State of the Flights page
class _FlightsPage extends State<FlightsPage> {

  /// list of Flight items
  final List<FlightItem> _items = [];

  /// Flight DAO that will be used to interact with the database
  late FlightDAO myDAO;

  /// selected flight item from the list (will be set later when an item is selected)
  FlightItem? _selectedItem;

/// Initialize the state of the widget and get the database instance
  @override
  void initState() {
    super.initState();

    $FloorFlightsDatabase
        .databaseBuilder('app_database.db')
        .build()
        .then((database) {
      myDAO = database.flightDAO;
      myDAO.getAllItems().then((listOfItems) {
        // set the state of the widget with the list of items
        setState(() {
          _items.addAll(listOfItems);
          _refreshItems();
        });
      });
    });
  }

  /// Method to refresh the list of flight items
  void _refreshItems() {
    myDAO.getAllItems().then((listOfItems) {
      setState(() {
        _items.clear();
        _items.addAll(listOfItems);
      });
    });
  }

  /// Dispose the state of the widget 
  @override
  void dispose() {
    super.dispose();
  }

  /// Method to delete an item from the list
  /// @param item the item to be deleted
  void _deleteItem(FlightItem item) {
    myDAO.deleteItem(item).then((_) {
      setState(() {
        _items.remove(item);
        _selectedItem = null;
      });
    });
  }

  /// Method to handle the item selection
  void _onItemTapped(FlightItem item) {
    setState(() {
      _selectedItem = item;
    });
  }

  /// Method to build the widget for the tablet (landscape) view
  /// @return the widget with the list of items on the left and the selected item details on the right
  Widget _tabletView() {
    // return a row with two columns
    return Row(
      children: [
        // first column will have the list of items
        Expanded(child: _itemList()),

        // add a vertical divider between the two columns
        VerticalDivider(),

        // second column will have the details of the selected item
        Expanded(
          child: _selectedItem != null
              ? _detailsPage(_selectedItem!)
              : Center(child: Text('Select an item')),
        ),
      ],
    );
  }

  /// Method to build the widget for the mobile view
  /// @return the widget with the selected item details or the list of items
  Widget _mobileView() {
    // return the selected item details if an item is selected
    return _selectedItem != null ? _detailsPage(_selectedItem!) : _itemList();
  }

  /// Method to build the list of items
  /// @return the list view with the list of items
  Widget _itemList() {
    
    // create a list view with builder pattern to display the list of items 
    return ListView.builder(
      itemCount: _items.length,
      itemBuilder: (context, index) {
        // return a ListTile for each item in the list
         return ListTile(
        title: RichText(
          text: TextSpan(
            children: [
              // add the departure city with the value from the item
              TextSpan(
                text: "Departure: ${_items[index].departureCity} ",
                style: TextStyle(fontSize: 20, color: Colors.black)
              ),

              // add an airplane taking off icon between the departure and destination cities
              WidgetSpan(
                child: Icon(Icons.flight_takeoff, size: 20),
              ),

              // add the destination city with the value from the item
              TextSpan(
                text: " Arrival: ${_items[index].destinationCity}\n",
               style: TextStyle(fontSize: 20, color: Colors.black)
              ),

              // add the departure time with the value from the item
              TextSpan(
                text: "Departure Time: ${_items[index].departureTime}",
                style: TextStyle(fontSize: 20, color: Colors.black)
              ),

              // add an arrow icon between the departure and arrival times
              WidgetSpan(
                child: Icon(Icons.arrow_right_alt, size: 20),
              ),

              // add the arrival time with the value from the item
              TextSpan(
                text: "Arrival Time: ${_items[index].arrivalTime}",
                style: TextStyle(fontSize: 20, color: Colors.black)
              ),
            ],
          ),
        ),

        // set the onTap event to call the _onItemTapped method with the selected item
        onTap: () => _onItemTapped(_items[index]),
      );
    },
  );
  }

  /// Method to build the details page for the selected item
  /// @param item the selected item from the flight list
  /// @return the widget with the details of the selected item
  Widget _detailsPage(FlightItem item) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // add the details of the selected item with newline breaks afer each field
        Text(
            "Fight Information: \nDeparture City: ${item.departureCity} \nDestination City: ${item.destinationCity} \nDeparture Time: ${item.departureTime} \nArrival Time: ${item.arrivalTime} ",
            style: TextStyle(fontSize: 20)),
        // add the database ID of the item underneath the details
        Text('Database ID: ${item.id}', style: TextStyle(fontSize: 14)),
        SizedBox(height: 20),

        // add a row with buttons to cancel, delete, or update the selected item
        Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // add a cancel button to clear the selected item
              ElevatedButton(
                // when pressed, the selected item will be set to null
                  onPressed: () => setState(() {
                        _selectedItem = null;
                      }),
                      // set the text of the button to Cancel
                  child: Text('Cancel')),
              SizedBox(width: 20),

              // add a delete button to delete the selected item
              ElevatedButton(
                // when pressed, the selected item will be deleted using the deleteItem method
                onPressed: () => _deleteItem(item),
                child: Text('Delete'),
              ),
              SizedBox(width: 20),

              // add an update button to update the selected item
              ElevatedButton(

                // when pressed, the UpdateFlightPage will be opened with the selected item details to update
                onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                // pass the selected item to the UpdateFlightPage
                    UpdateFlightPage(myDAO: myDAO, onUpdate: _refreshItems, flight: item,)),
          );
        },
                // set the text of the button to Update
                child: Text('Update'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Method to build the widget for the Flights page
  /// @return the widget with the list of items and the selected item details
  @override
  Widget build(BuildContext context) {

    /// get the size of the screen
    var size = MediaQuery.of(context).size;

    /// get the width of the screen from size 
    var width = size.width;

    /// get the height of the screen from size
    var height = size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          /// add an exit button to close the app
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
        // check if width is greater than height and width is greater than 720 to determine if the screen is a tablet.
        // if it is a tablet, call the _tabletView method, otherwise call the _mobileView method
        child:
            (width > height) && (width > 720) ? _tabletView() : _mobileView(),
      ),
      // add a floating action button to add a new flight item. when pressed, the AddFlightPage will be opened and the list will be refreshed
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AddFlightPage(myDAO: myDAO, onAdd: _refreshItems)),
          );
        },
        // set the icon of the button to an add icon
        child: Icon(Icons.add),
      ),
    );
  }
}

