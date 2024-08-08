import 'package:flutter/material.dart';
import 'AirplaneDatabase.dart';
import 'AirplaneItem.dart';
import 'AirplaneDAO.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Airplane Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AirplanesPage(title: 'Airplanes'),
    );
  }
}

class AirplanesPage extends StatefulWidget {
  const AirplanesPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<AirplanesPage> createState() => _AirplanesPageState();
}

class _AirplanesPageState extends State<AirplanesPage> {
  late TextEditingController typeController;
  late TextEditingController passengersController;
  late TextEditingController speedController;
  late TextEditingController rangeController;
  final encryptedSharedPreferences = EncryptedSharedPreferences();

  late AppDatabase database;
  late AirplaneDAO airplaneDAO;

  List<AirplaneItem> airplanes = [];
  AirplaneItem? selectedAirplane;

  @override
  void initState() {
    super.initState();
    typeController = TextEditingController();
    passengersController = TextEditingController();
    speedController = TextEditingController();
    rangeController = TextEditingController();

    loadAirplaneData();

    // Initialize the database and load airplanes
    $FloorAppDatabase
        .databaseBuilder('airplane_database.db')
        .build()
        .then((db) {
      database = db;
      airplaneDAO = database.airplaneDAO;
      _loadAirplanes();
    });
  }

  @override
  void dispose() {
    typeController.dispose();
    passengersController.dispose();
    speedController.dispose();
    rangeController.dispose();
    super.dispose();
  }

  void _loadAirplanes() async {
    final allAirplanes = await airplaneDAO.getAllAirplanes();
    setState(() {
      airplanes = allAirplanes;
    });
  }

  void addAirplane() {
    try {
      // Parse and validate the input fields
      final type = typeController.text.trim();
      final passengers = int.tryParse(passengersController.text.trim());
      final speed = double.tryParse(speedController.text.trim());
      final range = double.tryParse(rangeController.text.trim());

      if (type.isEmpty ||
          passengers == null ||
          speed == null ||
          range == null) {
        throw FormatException('Invalid input');
      }

      // Create a new AirplaneItem
      final newAirplane =
          AirplaneItem(AirplaneItem.ID++, type, passengers, speed, range);

      // Insert the new airplane into the database
      airplaneDAO.insertItem(newAirplane).then((_) {
        _loadAirplanes(); // Refresh the list of airplanes
        // Clear the input fields
        typeController.clear();
        passengersController.clear();
        speedController.clear();
        rangeController.clear();
      }).catchError((error) {
        print('Error adding airplane: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding airplane: $error')),
        );
      });
    } catch (e) {
      print('Error in addAirplane: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Invalid input. Please check your data and try again.')),
      );
    }
  }

  void updateAirplane(AirplaneItem airplane) {
    if (airplane == null) return; // No airplane to update

    final type = typeController.text.trim();
    final passengers = int.tryParse(passengersController.text.trim());
    final speed = double.tryParse(speedController.text.trim());
    final range = double.tryParse(rangeController.text.trim());

    final updatedAirplane =
        AirplaneItem(airplane.id, type, passengers!, speed!, range!);

    airplaneDAO.updateItem(updatedAirplane).then((_) {
      // Refresh the list of airplanes
      _loadAirplanes();

      // Clear the input fields and reset selected airplane
      typeController.clear();
      passengersController.clear();
      speedController.clear();
      rangeController.clear();

      setState(() {
        selectedAirplane = null;
      });
    }).catchError((error) {
      // Handle error
      print('Error updating airplane: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating airplane: $error')),
      );
    });
  }

  void confirmDeleteAirplane(AirplaneItem airplane) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this airplane?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                deleteAirplane(airplane); // Call the delete function
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void deleteAirplane(AirplaneItem airplane) {
    airplaneDAO.deleteItem(airplane).then((_) {
      _loadAirplanes();
      setState(() {
        selectedAirplane = null;
      });
    }).catchError((error) {
      print('Error deleting airplane: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting airplane: $error')),
      );
    });
  }

  void saveAirplaneData() async {
    await encryptedSharedPreferences.setString('type', typeController.text);
    await encryptedSharedPreferences.setString(
        'passengers', passengersController.text);
    await encryptedSharedPreferences.setString('speed', speedController.text);
    await encryptedSharedPreferences.setString('range', rangeController.text);
  }

  void loadAirplaneData() async {
    typeController.text =
        await encryptedSharedPreferences.getString('type') ?? '';
    passengersController.text =
        await encryptedSharedPreferences.getString('passengers') ?? '';
    speedController.text =
        await encryptedSharedPreferences.getString('speed') ?? '';
    rangeController.text =
        await encryptedSharedPreferences.getString('range') ?? '';
  }

  void showInstructions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Instructions'),
          content: const Text(
              '1. Use the text fields to input the attributes of the airplane.\n'
              '2. Click "Add Airplane" to add it to the list.\n'
              '3. Tap on an airplane to view its type, amount of passengers, max speed, and range.\n'
              '4. Use the "Update" button to modify an airplane\'s details.\n'
              '5. Use the "Delete" button to remove an airplane from the list.\n'
              '6. The airplane details page works both in Portrait and Landscape mode.\n'
              '7. The instructions can be accessed from the ActionBar icon.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text(widget.title),
        flexibleSpace: Align(
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize
                .min, // Prevents Row from taking up more space than necessary
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Instructions:',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(color: Colors.white),
              ),
              SizedBox(width: 8), // Space between text and icon
              IconButton(
                icon: Icon(Icons.info_outline),
                onPressed: showInstructions,
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isTablet
            ? buildTabletLayout(isPortrait)
            : buildPhoneLayout(isPortrait),
      ),
    );
  }

  Widget buildTabletLayout(bool isPortrait) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(labelText: 'Type'),
                      controller: typeController,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(labelText: 'Passengers'),
                      controller: passengersController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(labelText: 'Max Speed'),
                      controller: speedController,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(labelText: 'Range'),
                      controller: rangeController,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      addAirplane();
                      saveAirplaneData();
                    },
                    child: Text("Add Airplane"),
                  ),
                ],
              ),
              Expanded(
                child: airplanes.isEmpty
                    ? Center(child: Text('No airplanes available'))
                    : ListView.builder(
                        itemCount: airplanes.length,
                        itemBuilder: (context, index) {
                          final airplane = airplanes[index];
                          return ListTile(
                            title: Text(airplane.type),
                            onTap: () {
                              setState(() {
                                selectedAirplane = airplane;
                              });
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
        selectedAirplane != null
            ? Expanded(
                child: buildDetailsPage(),
              )
            : Container(),
      ],
    );
  }

  Widget buildPhoneLayout(bool isPortrait) {
    return selectedAirplane == null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(labelText: 'Type'),
                      controller: typeController,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(labelText: 'Passengers'),
                      controller: passengersController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(labelText: 'Max Speed'),
                      controller: speedController,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(labelText: 'Range'),
                      controller: rangeController,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      addAirplane();
                      saveAirplaneData();
                    },
                    child: Text("Add Airplane"),
                  ),
                ],
              ),
              Expanded(
                child: airplanes.isEmpty
                    ? Center(child: Text('No airplanes available'))
                    : ListView.builder(
                        itemCount: airplanes.length,
                        itemBuilder: (context, index) {
                          final airplane = airplanes[index];
                          return ListTile(
                            title: Text(airplane.type),
                            onTap: () {
                              setState(() {
                                selectedAirplane = airplane;
                              });
                            },
                          );
                        },
                      ),
              ),
            ],
          )
        : buildDetailsPage(isPortrait);
  }

  Widget buildDetailsPage([bool? isPortrait]) {
    typeController.text = selectedAirplane?.type ?? '';
    passengersController.text = selectedAirplane?.passengers.toString() ?? '';
    speedController.text = selectedAirplane?.speed.toString() ?? '';
    rangeController.text = selectedAirplane?.range.toString() ?? '';

    if (isPortrait != null && isPortrait) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Airplane Details'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              setState(() {
                selectedAirplane = null;
              });
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Type'),
                controller: typeController,
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(labelText: 'Passengers'),
                controller: passengersController,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(labelText: 'Max Speed'),
                controller: speedController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(labelText: 'Range'),
                controller: rangeController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  confirmDeleteAirplane(selectedAirplane!);
                },
                child: Text('Delete'),
              ),
              ElevatedButton(
                onPressed: () {
                  updateAirplane(selectedAirplane!);
                },
                child: Text('Update'),
              ),
            ],
          ),
        ),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(
            title: Text('Airplane Details'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                setState(() {
                  selectedAirplane = null;
                });
              },
            ),
          ),
          Expanded(
            child: detailsContent(),
          ),
        ],
      );
    }
  }

  Widget detailsContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Type: ${selectedAirplane!.type}'),
          SizedBox(height: 10),
          Text('Passengers: ${selectedAirplane!.passengers}'),
          SizedBox(height: 10),
          Text('Max Speed: ${selectedAirplane!.speed} km/h'),
          SizedBox(height: 10),
          Text('Range: ${selectedAirplane!.range} km'),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              deleteAirplane(selectedAirplane!);
            },
            child: const Text('Delete'),
          ),
          ElevatedButton(
            onPressed: () {
              updateAirplane(selectedAirplane!);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}
