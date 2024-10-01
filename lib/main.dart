import 'package:eliteclean/views/confirmbooking.dart';
import 'package:eliteclean/views/home.dart';
import 'package:eliteclean/views/loginpage.dart';
import 'package:eliteclean/views/otp.dart';
import 'package:eliteclean/views/selectpackage.dart';
import 'package:eliteclean/views/servicedetai.dart';
import 'package:flutter/material.dart';
import 'views/splashscreen.dart'; // Import your LoginPage widget
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Import your LoginPage widget
void main() async {
  // Ensure that widget binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EliteClean',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Define the initial route and the routes in the app
      initialRoute: '/',
      routes: {
        '/': (context) => Login(), // Splashscreen as the initial screen
        '/login': (context) => Login(),
        '/verify': (context) => Verify(), // otp route
        '/home': (context) => Home(), // otp route
        '/servicedetail': (context) => ServiceDetails(), // otp route
        '/selectpackage': (context) => SelectPackage(),
        '/confirmbooking': (context) => ConfirmBookingScreen(), // otp route
      },
    );
  }
}
