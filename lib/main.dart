import 'package:eliteclean/firebase_options.dart';
import 'package:eliteclean/views/confirmbooking.dart';
import 'package:eliteclean/views/home.dart';
import 'package:eliteclean/views/loginpage.dart';
import 'package:eliteclean/views/otp.dart';
import 'package:eliteclean/views/pendingbookings.dart';
import 'package:eliteclean/views/selectpackage.dart';
import 'package:eliteclean/views/servicedetai.dart';
import 'package:eliteclean/views/view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/auth.dart';
import 'views/splashscreen.dart'; // Import your LoginPage widget

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        '/': (context) {
          return Consumer(
            builder: (context, ref, child) {
              final authState = ref.watch(authProvider);
              // Check if the user has a valid refresh token
              if (authState.data?.refreshToken != null &&
                  authState.data!.refreshToken!.isNotEmpty) {
                print('Refresh token exists: ${authState.data?.refreshToken}');
                return Home(); // User is authenticated, redirect to Home
              } else {
                print('No valid refresh token, trying auto-login');
              }

              // Attempt auto-login if refresh token is not in state
              return FutureBuilder(
                future: ref.watch(authProvider.notifier).tryAutoLogin(),
                builder: (context, snapshot) {
                  print(
                      'Token after auto-login attempt: ${authState.data?.accessToken}');
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    ); // Show SplashScreen while waiting
                  } else if (snapshot.hasData &&
                      snapshot.data == true &&
                      authState.data?.refreshToken != null) {
                    // If auto-login is successful and refresh token is available, go to Home
                    return const Home();
                  } else {
                    // If auto-login fails, redirect to login page
                    return Login();
                  }
                },
              );
            },
          );
        }, // Splashscreen as the initial screen
        '/login': (context) => Login(),
        '/verify': (context) => Verify(), // otp route
        '/home': (context) => Home(), // otp route
        '/servicedetail': (context) => ServiceDetails(), // otp route
        '/selectpackage': (context) => SelectPackage(),
        '/confirmbooking': (context) => ConfirmBookingScreen(), // otp route
        '/pendingbooking': (context) => PendingBookingScreen(),
        '/viewbooking': (context) => ViewBooking(),
      },
    );
  }
}
