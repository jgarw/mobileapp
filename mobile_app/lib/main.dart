import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'flights/FlightsPage.dart'; 
import 'Customers/CustomersPage.dart';
import 'generated/l10n.dart';

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
      localizationsDelegates: [
        S.delegate, // The generated localization delegate
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        //const Locale('en', ''), // English
        const Locale('hi', ''), // Hindi
      ],
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
        title: Text('CST2335 Final Project'),
      ),
      body: Center(
        // Column to hold the 4 buttons for navigation
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                context,
                MaterialPageRoute(
                builder: (context) => CustomersPage(),
                ),
                );
                },
              child: Text(S.of(context).customersPage),
            ),
            
            // SizedBox is used to add space between the buttons
            SizedBox(height: 10),
            
            // Create an ElevatedButton for airplanes page,
            const ElevatedButton(onPressed: null, child: Text("Airplanes Page"),
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
