import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'flights/FlightsPage.dart'; 
import 'Customers/CustomersPage.dart';
import 'generated/l10n.dart';

void main() {
  runApp(const MyApp());
}

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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('CST2335 Final Project'),
      ),
      body: Center(
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
            SizedBox(height: 10),
            const ElevatedButton(onPressed: null, child: Text("Airplanes Page"),
            ),
            SizedBox(height: 10),

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
            SizedBox(height: 10),
            const ElevatedButton(onPressed: null, child: Text("Reservations Page"),
            ),
          ],
        ),
      ),
    );
  }
}
