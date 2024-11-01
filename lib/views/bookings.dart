import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class BookingScreen extends StatelessWidget {
  BookingScreen({super.key});
  Stream<Map<String, dynamic>?> getLatestOngoingBookingStream(String userId) {
    final dbRef = FirebaseDatabase.instance.ref();

    return dbRef.onValue.map((event) {
      Map<String, dynamic>? latestBooking;

      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> allUsersData = event.snapshot.value as Map;

        // Iterate over all users' bookings to find those created by the logged-in user
        allUsersData.forEach((userIdKey, userData) {
          if (userData is Map && userData['bookings'] != null) {
            Map<dynamic, dynamic> bookingsData = userData['bookings'] as Map;

            bookingsData.forEach((bookingId, bookingInfo) {
              if (bookingInfo is Map &&
                  bookingInfo['booking_status'] == 'o' &&
                  bookingInfo['creator_id'] == userId) {
                latestBooking = {
                  'address': bookingInfo['address'],
                  'time': bookingInfo['time'],
                  'price': bookingInfo['price'],
                  'package': bookingInfo['package'],
                };
              }
            });
          }
        });
      }

      return latestBooking;
    });
  }

  Stream<List<Map<String, dynamic>>> getUserBookingsStream(String userId) {
    final dbRef = FirebaseDatabase.instance.ref();

    return dbRef.onValue.map((event) {
      List<Map<String, dynamic>> userBookings = [];

      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> allUsersData = event.snapshot.value as Map;
        allUsersData.forEach((userIdKey, userData) {
          if (userData is Map && userData['bookings'] != null) {
            Map<dynamic, dynamic> bookingsData = userData['bookings'] as Map;
            bookingsData.forEach((bookingId, bookingInfo) {
              if (bookingInfo is Map && bookingInfo['creator_id'] == userId) {
                userBookings.add({
                  'address': bookingInfo['address'],
                  'time': bookingInfo['time'],
                  'price': bookingInfo['price'],
                  'package': bookingInfo['package'],
                  'status': bookingInfo['booking_status'],
                });
              }
            });
          }
        });
      }

      return userBookings;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = screenWidth > 360 ? 320 : screenWidth * 0.9;
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        backgroundColor:
            Colors.white, // Set the background color of the Scaffold body
        appBar: AppBar(
          backgroundColor:
              Colors.white, // Ensure AppBar background is also white
          iconTheme:
              const IconThemeData(color: Colors.black), // AppBar icon color
          title: const Text(
            'Bookings',
            style: TextStyle(color: Colors.black), // AppBar title color
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Container(
                  width: containerWidth,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Recent',
                            style: TextStyle(
                              color: Color(0xFF1E116B),
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          PopupMenuButton<String>(
                            offset: const Offset(0, 30),
                            color: Colors.white,
                            icon: const Icon(Icons.more_horiz,
                                color: Colors.black),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(
                                    8), // Custom radius for bottom left
                                bottomRight: Radius.circular(
                                    8), // Custom radius for bottom right
                              ),
                            ),
                            onSelected: (String result) {
                              switch (result) {
                                case 'Pending Bookings':
                                  Navigator.of(context)
                                      .pushNamed('/pendingbooking');
                                  // Handle edit action
                                  break;
                              }
                            },
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<String>>[
                              const PopupMenuItem<String>(
                                value: 'Pending Bookings',
                                child: Text('Pending Bookings'),
                              ),
                            ],
                          ), // Three dots icon
                        ],
                      ),
                      const SizedBox(
                          height:
                              10), // Space between the row and the main container
                      StreamBuilder<Map<String, dynamic>?>(
                        stream: getLatestOngoingBookingStream(userId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text("Error: ${snapshot.error}");
                          } else if (!snapshot.hasData ||
                              snapshot.data == null) {
                            return Column(
                              children: [
                                Image.asset(
                                  'assets/images/emptyservice.png', // Replace with your image asset path
                                  height: 80,
                                  width: 80,
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'No package subscribes yet...',
                                  style: TextStyle(
                                    color: Color(0xFF808080),
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            );
                          } else {
                            var booking = snapshot.data!;
                            return Center(
                              child: Container(
                                width: containerWidth,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: const Color(0xFFEAE9FF), width: 1),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(3)),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(22),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Location",
                                        style: TextStyle(
                                          color: Color(0xFF38385E),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        "Address: ${booking['address']}",
                                        style: const TextStyle(
                                          color: Color(0xFF38385E),
                                          fontSize: 12,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "working time",
                                        style: TextStyle(
                                          color: Color(0xFF38385E),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "Time: ${booking['time']}",
                                        style: const TextStyle(
                                          color: Color(0xFF38385E),
                                          fontSize: 12,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "Price: ${booking['price']}",
                                        style: const TextStyle(
                                          color: Color(0xFF38385E),
                                          fontSize: 12,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "Package: ${booking['package']}",
                                        style: const TextStyle(
                                          color: Color(0xFF38385E),
                                          fontSize: 12,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          TextButton(
                                            onPressed: () {},
                                            style: TextButton.styleFrom(
                                              backgroundColor:
                                                  Color(0xFFFFEAF0),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: Text(
                                              'OTP',
                                              style: TextStyle(
                                                color: Color(0xFFF7658B),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),

                      const TabBar(
                        dividerColor: Colors.transparent,
                        indicatorColor: Color(0xFF583EF2),
                        labelColor: Color(0xFF1E116B),
                        unselectedLabelColor: Color(0xFFB8B8D2),
                        tabs: [
                          Tab(text: 'Completed'),
                          Tab(text: 'Cancelled'),
                        ],
                      ),
                      // Expanded inside a SingleChildScrollView to prevent overflow and layout issues
                      SizedBox(
                        height:
                            300, // Specify a fixed height for the tab content area
                        child: StreamBuilder<List<Map<String, dynamic>>>(
                          stream: getUserBookingsStream(userId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text("Error: ${snapshot.error}"));
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Center(
                                  child: Text('No bookings found'));
                            } else {
                              List<Map<String, dynamic>> allBookings =
                                  snapshot.data!;
                              // Filter bookings by status
                              List<Map<String, dynamic>> completedBookings =
                                  allBookings
                                      .where(
                                          (booking) => booking['status'] == 'c')
                                      .toList();
                              List<Map<String, dynamic>> canceledBookings =
                                  allBookings
                                      .where((booking) =>
                                          booking['status'] == 'ce')
                                      .toList();

                              return TabBarView(
                                children: [
                                  // Completed Bookings Tab
                                  completedBookings.isEmpty
                                      ? const Center(
                                          child: Text('No completed bookings'))
                                      : ListView.builder(
                                          itemCount: completedBookings.length,
                                          itemBuilder: (context, index) {
                                            var booking =
                                                completedBookings[index];
                                            return Card(
                                              color: Colors.white,
                                              margin: const EdgeInsets.all(8),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(3),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Address: ${booking['address']}',
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Text(
                                                      'Time: ${booking['time']}',
                                                      style: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Price: ${booking['price']}',
                                                      style: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Package: ${booking['package']}',
                                                      style: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                  // Canceled Bookings Tab
                                  canceledBookings.isEmpty
                                      ? const Center(
                                          child: Text('No canceled bookings'))
                                      : ListView.builder(
                                          itemCount: canceledBookings.length,
                                          itemBuilder: (context, index) {
                                            var booking =
                                                canceledBookings[index];
                                            return Card(
                                              color: Colors.white,
                                              margin: const EdgeInsets.all(8),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(3),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Address: ${booking['address']}',
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Text(
                                                      'Time: ${booking['time']}',
                                                      style: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Price: ${booking['price']}',
                                                      style: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Package: ${booking['package']}',
                                                      style: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                ],
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
