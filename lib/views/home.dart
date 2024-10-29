import 'package:eliteclean/providers/addressnotifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/topSection.dart';
import 'bookings.dart';
import '../providers/locationnotifier.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Handle navigation logic here for each index if required
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      ref.read(addressProvider.notifier).getCurrentLocation();
    });
  }
Stream<List<Map<String, dynamic>>> getOngoingBookingsStream(String userId) {
  final dbRef = FirebaseDatabase.instance.ref();
  return dbRef.onValue.map((event) {
    List<Map<String, dynamic>> bookings = [];

    if (event.snapshot.value != null) {
      Map<dynamic, dynamic> allUsersData = event.snapshot.value as Map;

      // Iterate over all users' bookings to find those created by the logged-in user
      allUsersData.forEach((userIdKey, userData) {
        if (userData is Map && userData['bookings'] != null) {
          Map<dynamic, dynamic> bookingsData = userData['bookings'] as Map;

          bookingsData.forEach((bookingId, bookingInfo) {
            if (bookingInfo is Map && bookingInfo['booking_status'] == 'o' &&
                bookingInfo['creator_id'] == userId) {
              bookings.add({
                'address': bookingInfo['address'],
                'time': bookingInfo['time'],
                'price': bookingInfo['price'],
                'package': bookingInfo['package'],
                
              });
            }
          });
        }
      });
    }

    return bookings;
  });
}

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final List<Widget> _pages = [
      // Home Page
      Home(),
      // Bookings Page
      BookingScreen(),
      // Settings Page
      Column(
        children: const [
          Text(
            'Settings Page',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      // Notifications Page
      Column(
        children: const [
          Text(
            'Notifications Page',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: _selectedIndex == 0
          ? Column(
              children: [
                TopSection(
                    screenWidth: screenWidth, screenHeight: screenHeight),

                // Main content section (Your Packages and Services)
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Your booking',
                          style: TextStyle(
                            color: Color(0xFF1E116B),
                            fontSize: 20,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: screenWidth,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Consumer(builder: (context, ref, child) {
                             final String userId = FirebaseAuth.instance.currentUser!.uid;
                            return Column(
                              children: [
                                const Text(
                                  'Your bookings appear here',
                                  style: TextStyle(
                                    color: Color(0xFF808080),
                                    fontSize: 14,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 10),
                               StreamBuilder<List<Map<String, dynamic>>>(
  stream: getOngoingBookingsStream(userId),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    } else if (snapshot.hasError) {
      return Text("Error: ${snapshot.error}");
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
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
      List<Map<String, dynamic>> bookings = snapshot.data!;
      return SizedBox(
        height: 200,
        child: PageView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            var booking = bookings[index];
            return Center(
              child: Container(
                width: screenWidth * 0.8, // Adjust width as needed
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Left align text
                  mainAxisAlignment: MainAxisAlignment.center, // Center details vertically
                  children: [
                    Text(
                      "Address: ${booking['address']}",
                      style: const TextStyle(
                        color: Color(0xFF1E116B),
                        fontSize: 14,
                        fontFamily: 'Poppins',
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
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
  },
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
                          },
                          
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          'Select the service and choose the \nnumber of washrooms you want cleaned.',
                          style: TextStyle(
                            color: Color(0xFF6D6BE7),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Services',
                          style: TextStyle(
                            color: Color(0xFF1E116B),
                            fontSize: 20,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        // Services in GridView
                        GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 2, // Number of columns
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 3 / 4, // Adjust the aspect ratio
                          physics:
                              const NeverScrollableScrollPhysics(), // Disable scrolling inside the grid
                          children: List.generate(1, (index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/servicedetail');
                              },
                              child: Card(
                                color: const Color(0xFFEAE9FF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 2,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Image.asset(
                                        'assets/images/bathroom.png', // Replace with your image asset path
                                        height: 130,
                                        width: 130,
                                      ),
                                    ),
                                    const Text(
                                      'Bathroom Cleaning',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFF38385E),
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : _pages.elementAt(_selectedIndex),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        elevation: 15,
        selectedItemColor: const Color(0xFF583EF2),
        unselectedItemColor: const Color(0xFF77779D),
        currentIndex: _selectedIndex, // Set the currently selected index
        onTap: _onItemTapped, // Update selected index when a tab is tapped
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification',
          ),
        ],
      ),
    );
  }
}
