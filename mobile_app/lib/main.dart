import 'package:flutter/material.dart';
import 'flights/FlightsPage.dart';
import 'airplanes/AirplanesPage.dart';

/// main function to run the application
void main() {
  runApp(const MyApp());
}

/// Main application widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CST2335 Final Project',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'CST2335 Final Project',),
    );
  }
}

/// Homepage of the application
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  /// variable to hold the title of the homepage
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

/// State of the homepage
class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        // Column to hold the 4 buttons for navigation
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Create an ElevatedButton for customers page
            const ElevatedButton(onPressed: null, child: Text("Customers Page"),
            ),
            
            // SizedBox is used to add space between the buttons
            SizedBox(height: 10),
            
            // Create an ElevatedButton for airplanes page,
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AirplanesPage(title: 'Airplanes'),
                    ),
                  );
                }, child: Text("Airplanes Page"),
            ),

            // SizedBox is used to add space between the buttons
            SizedBox(height: 10),

            // Create an ElevatedButton for Flights page,
             ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FlightsPage(title: 'Flights',),
                  ),
                );
              },
              child: Text("Flights Page"),
            ),

             // SizedBox is used to add space between the buttons
            SizedBox(height: 10),

            // Create an ElevatedButton for reservations page,
            const ElevatedButton(onPressed: null, child: Text("Reservations Page"),
            ),
          ],
        ),
      ),
    );
  }
}
