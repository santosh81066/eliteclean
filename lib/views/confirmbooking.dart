import 'dart:math';

import 'package:eliteclean/providers/addressnotifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/loader.dart';

class ConfirmBookingScreen extends StatelessWidget {
  ConfirmBookingScreen({super.key});

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Radius of the Earth in kilometers
    double dLat = _deg2rad(lat2 - lat1);
    double dLon = _deg2rad(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_deg2rad(lat1)) *
            cos(_deg2rad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _deg2rad(double deg) {
    return deg * (pi / 180);
  }

  Future<bool> checkExistingBooking(
      double bookingLat, double bookingLon) async {
    const double threshold = 0.0001; // Define a small threshold for comparison

    final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
    DatabaseEvent event = await dbRef.once();

    if (!event.snapshot.exists) {
      print("No bookings found in the database.");
      return false;
    }

    Map<dynamic, dynamic> allUsersDynamic =
        event.snapshot.value as Map<dynamic, dynamic>;

    for (var userId in allUsersDynamic.keys) {
      var userData = allUsersDynamic[userId];
      if (userData is Map && userData['bookings'] != null) {
        Map<dynamic, dynamic> bookings =
            userData['bookings'] as Map<dynamic, dynamic>;

        for (var bookingId in bookings.keys) {
          var bookingInfo = bookings[bookingId];
          if (bookingInfo is Map) {
            double existingLat =
                double.tryParse(bookingInfo['latitude'].toString()) ?? 0.0;
            double existingLon =
                double.tryParse(bookingInfo['longitude'].toString()) ?? 0.0;
            String bookingStatus = bookingInfo['booking_status'] ?? '';

            // Check if the coordinates are within the threshold and the status is 'o'
            if ((existingLat - bookingLat).abs() < threshold &&
                (existingLon - bookingLon).abs() < threshold &&
                bookingStatus == 'o') {
              print("Ongoing booking found at $bookingLat, $bookingLon");
              return true; // Stop further checks once we find an existing booking
            }
          }
        }
      }
    }

    print("No ongoing bookings detected for the given coordinates.");
    return false;
  }

  bool isBookingProcessActive = false;

  Future<void> assignBookingToNearestUser(double bookingLat, double bookingLon,
    Map<String, dynamic> bookingData, BuildContext context) async {
  if (isBookingProcessActive) {
    print("Booking process already active, blocking new calls.");
    return;
  }

  isBookingProcessActive = true;
    final String? creatorId = FirebaseAuth.instance.currentUser?.uid;

    if (creatorId == null) {
      print("No logged-in user found.");
      return;
    }

    // Add creator_id directly to bookingData
    bookingData['creator_id'] = creatorId;

  try {
    bool existingBooking = await checkExistingBooking(bookingLat, bookingLon);

    if (existingBooking) {
      print("Ongoing booking detected. No new booking will be created.");
      await _showBookingExistsDialog(context);
      isBookingProcessActive = false;
      return; // Ensure no further processing occurs if an ongoing booking exists
    }

    print("No ongoing booking detected, proceeding to assign new booking.");
    await _findAndAssignBookingToNearestUser(
        bookingLat, bookingLon, bookingData, context);
  } finally {
    isBookingProcessActive = false;
  }
}

Future<void> _findAndAssignBookingToNearestUser(
    double bookingLat,
    double bookingLon,
    Map<String, dynamic> bookingData,
    BuildContext context) async {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  DatabaseEvent event = await dbRef.once();

  if (!event.snapshot.exists) {
    print("No users found in the database.");
    return;
  }

  Map<dynamic, dynamic> allUsersDynamic =
      event.snapshot.value as Map<dynamic, dynamic>;
  Map<String, dynamic> allUsers = Map<String, dynamic>.from(allUsersDynamic);

  double minDistance = double.infinity;
  String nearestUserId = '';

  allUsers.forEach((userId, userData) {
    if (userData is Map && userData['user_info'] != null) {
      Map<dynamic, dynamic> userInfoDynamic =
          userData['user_info'] as Map<dynamic, dynamic>;
      userInfoDynamic.forEach((key, userInfoData) {
        if (userInfoData is Map) {
          Map<String, dynamic> userInfo =
              Map<String, dynamic>.from(userInfoData);
          String? role = userInfo['use_role'] as String?;
          if (role == 's') {
            double userLat =
                double.tryParse(userInfo['latitude'].toString()) ?? 0.0;
            double userLon =
                double.tryParse(userInfo['longitude'].toString()) ?? 0.0;
            double distance =
                calculateDistance(bookingLat, bookingLon, userLat, userLon);
            if (distance < minDistance) {
              minDistance = distance;
              nearestUserId = userId;
            }
          }
        }
      });
    }
  });

  if (nearestUserId.isNotEmpty) {
    String newBookingKey = dbRef.child('$nearestUserId/bookings').push().key!;
    await dbRef.child('$nearestUserId/bookings/$newBookingKey').set(bookingData).then((_) {
      print("Booking successfully assigned to nearest user: $nearestUserId");
      _showSuccessDialog(context); // Show success dialog only if booking insertion is successful
    }).catchError((error) {
      print("Failed to assign booking: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to assign booking. Please try again."))
      );
    });
  } else {
    print("No suitable user found to assign the booking.");
  }
}


  Future<void> _showBookingExistsDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Existing Booking Detected"),
          content: const Text(
              "You have an ongoing booking at this location. Please complete it before creating a new one."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    // Extract the values from the arguments
    final String startDate = args['StartDate'];
    final String price = args['Price'].toString();
    final String note = args['Note'];
    final String package = args['Package'];
    final int washroomcount = args['WashroomCount'];
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Confirm Booking",
          style: TextStyle(
            fontSize: 16,
            color: Color(0xff1F126B),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Card(
                elevation: 2,
                color: Colors.white, // Set card background color to white
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Color(0xFFEAE9FF)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Consumer(
                    builder: (context, ref, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeaderRow("Booking detail", Icons.edit),
                          const SizedBox(height: 10),
                          _buildDetailItem("Package selected", package),
                          _buildDetailItem("Working time", startDate),
                          _buildDetailItem("Location",
                              "House ${ref.read(addressProvider).selectedIndex} "),
                          _buildLocationDetail(
                              ref.read(addressProvider).selectedAddress!),
                          if (note.isNotEmpty) _buildDetailItem("Note", note),
                        ],
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 2,
                color: Colors.white, // Set card background color to white
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Color(0xFFEAE9FF)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderRow("Payment detail", Icons.edit),
                      const SizedBox(height: 10),
                      _buildDetailItem("Payment method", "Cash on service"),
                      const SizedBox(height: 10),
                      const Text("Charges",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF38385E))),
                      const SizedBox(height: 10),
                      _buildChargeRow("Per 1 washroom", "\$10"),
                      _buildChargeRow("Per 1 day", "\$2"),
                      _buildChargeRow("Total days", "30"),
                      _buildChargeRow("App cost", "5%"),
                      _buildChargeRow("Total payable amount", "\$12"),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildBottomBar(context, startDate, price, package),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderRow(String title, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF583EF2),
          ),
        ),
        Icon(icon, color: const Color(0xFF583EF2), size: 20),
      ],
    );
  }

  Widget _buildDetailItem(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF38385E)),
        ),
        const SizedBox(height: 5),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 14, color: Color(0xFF77779D)),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildLocationDetail(String address) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(Icons.location_pin, color: Color(0xFF6D6BE7)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              address,
              style: const TextStyle(fontSize: 14, color: Color(0xFF77779D)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChargeRow(String label, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: Color(0xFF77779D))),
          Text(amount,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6D6BE7))),
        ],
      ),
    );
  }

  Widget _buildBottomBar(
      BuildContext context, String startDate, String price, String package) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildDot(const Color(0xFFF3A8A2)),
              const SizedBox(width: 10),
              _buildDot(const Color(0xFFF3A8A2)),
              const SizedBox(width: 10),
              _buildDot(const Color(0xFFF3A8A2)),
            ],
          ),
          Consumer(
            builder: (context, ref, child) {
              var loader = ref.watch(loadingProvider);
              final loadingState = ref.watch(loadingProvider.notifier);
              return ElevatedButton(
                onPressed: loader == true
                    ? null // Disable interaction but keep the style
                    : () async {
                        loadingState.state = true;
                        double bookingLat = ref.read(addressProvider).latitude!;
                        double bookingLon =
                            ref.read(addressProvider).longitude!;

                        // Example booking data, modify as per your need
                        Map<String, dynamic> bookingData = {
                          "address": ref.read(addressProvider).selectedAddress,
                          "latitude": bookingLat,
                          "longitude": bookingLon,
                          "time": startDate,
                          "price": price,
                          "package": package,
                          "booking_status": "o"
                          // Add any other necessary booking details here
                        };

                        // Assign the booking to the nearest user
                        await assignBookingToNearestUser(
                            bookingLat, bookingLon, bookingData, context);

                        loadingState.state = false;
                        // Navigator.pushNamed(context, '/bookingpayment');
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF583EF2),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  "Book now",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white, // Set button text color to white
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Booking Successful"),
          content: const Text("Your booking has been successfully assigned."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/home'); // Close the dialog
                // Navigate to payment screen
              },
              child: const Text("ok"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
