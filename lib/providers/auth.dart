import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/authstate.dart';
import 'loader.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState.initial());
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> phoneAuth(
      BuildContext context, String phoneNumber, WidgetRef ref) async {
    final loadingState = ref.watch(loadingProvider.notifier);
    final FirebaseAuth auth = FirebaseAuth.instance;

    try {
      loadingState.state = true;

      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          // Handle auto-retrieval or instant verification
        },
        verificationFailed: (FirebaseException exception) {
          loadingState.state = false;
          _showAlertDialog(context, "Verification Failed",
              exception.message ?? "An error occurred.");
        },
        codeSent: (String verificationId, [int? forceResendingToken]) async {
          _showAlertDialog(
              context, "Code Sent", "Verification code sent on your mobile.");
          Navigator.of(context).pushNamed('verifyotp', arguments: phoneNumber);
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('verificationid', verificationId);
          loadingState.state = false;
        },
        timeout: const Duration(seconds: 30),
        codeAutoRetrievalTimeout: (String verificationId) {
          // Handle auto retrieval timeout
        },
      );
    } catch (e) {
      loadingState.state = false;
      _showAlertDialog(context, "Error", e.toString());
    }
  }

  Future<void> signInWithPhoneNumber(
      String smsCode,
      BuildContext context,
      WidgetRef ref,
      String phoneNumber,
      ScaffoldMessengerState scaffoldKey) async {
    final prefs = await SharedPreferences.getInstance();
    String? verificationId = prefs.getString('verificationid');
    final authState = ref.watch(authProvider);
    final loadingState = ref.watch(loadingProvider.notifier);
    try {
      loadingState.state = true;

      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId!, smsCode: smsCode);

      await auth.signInWithCredential(credential).then((value) async {
        if (value.user != null) {
          var user = auth.currentUser!;

          user.getIdToken().then((ftoken) async {
            await prefs.setString('firebaseToken', ftoken!);
          });
          // Add any additional logic needed after successful login here
        }
      });

      loadingState.state = false;
    } catch (e) {
      loadingState.state = false;
      if (e is PlatformException) {
        PlatformException exception = e;
        if (exception.code == 'firebase_auth') {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Error'),
                  content: Text(exception.message!),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              });
        }
      }
    }
    loadingState.state = false;
  }

  void _showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> logout() async {
    final pref = await SharedPreferences.getInstance();
    await pref.clear();
    state = AuthState.initial(); // Correct usage of state
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    // Check if userData exists in shared preferences
    if (!prefs.containsKey('userData')) {
      print('tryAutoLogin is false');
      return false;
    }

    print("From tryAutoLogin: SharedPreferences contains user data.");

    // Extract user data from shared preferences
    final extractedData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;

    // Extract individual data fields from the saved data
    final newUser = Data(
      userId: extractedData['userId'],
      username: extractedData['username'],
      countryname: extractedData['countryname'],
      state: extractedData['state'],
      city: extractedData['city'],
      address: extractedData['address'],
      profilePic: extractedData['profile_pic'],
      useRole: extractedData['use_role'],
      idFront: extractedData['id_front'],
      idBack: extractedData['id_back'],
      idCard: extractedData['id_card'],
      bankaccountno: extractedData['bankaccountno'],
      bankname: extractedData['bankname'],
      ifsccode: extractedData['ifsccode'],
      latitude: extractedData['latitude'],
      longitude: extractedData['longitude'],
      radius: extractedData['radius'],
      accessToken: extractedData['accessToken'],
      accessTokenExpiresAt: extractedData['accessTokenExpiry'] != null
          ? DateTime.parse(extractedData['accessTokenExpiry'])
              .millisecondsSinceEpoch
          : null,
      refreshToken: extractedData['refreshToken'],
      refreshTokenExpiresAt: extractedData['refreshTokenExpiry'] != null
          ? DateTime.parse(extractedData['refreshTokenExpiry'])
              .millisecondsSinceEpoch
          : null,
    );

    // Update the AuthState with new data using copyWith
    state = state.copyWith(
      data: newUser, // Updating the state with the restored user data
    );

    // Optional: Log the access token to debug
    print('Access token from tryAutoLogin: ${state.data?.accessToken}');

    return true;
  }
}

// Define the provider for AuthNotifier
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
