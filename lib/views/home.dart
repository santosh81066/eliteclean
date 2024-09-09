import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            width: screenWidth,
            height: screenHeight * 0.35,
            decoration: BoxDecoration(
              color: const Color(0xFF6D6BE7),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(45),
                bottomRight: Radius.circular(45),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My location',
                    style: TextStyle(
                      color: Color(0xFFB0BCE7),
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Barcelona, Spain',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.menu, color: Colors.white),
                        onPressed: () {},
                      )
                    ],
                  ),
                  SizedBox(height: 40),
                  Text(
                    'Hi Saim,',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Need some help today?',
                    style: TextStyle(
                      color: Color(0xFFF8F8FA),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.3,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Packages',
                  style: TextStyle(
                    color: Color(0xFF1E116B),
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: screenWidth,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/box.png', // Replace with your image asset path
                        height: 80,
                        width: 80,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Your packages appear here',
                        style: TextStyle(
                          color: Color(0xFF808080),
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'No package subscribes yet...',
                        style: TextStyle(
                          color: Color(0xFF808080),
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'Select the service and choose the \nnumber of washrooms you want cleaned.',
                  style: TextStyle(
                    color: Color(0xFF6D6BE7),
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Services',
                  style: TextStyle(
                    color: Color(0xFF1E116B),
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Card(
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
                                'assets/bathroom.png', // Replace with your image asset path
                                height: 80,
                                width: 80,
                              ),
                            ),
                            Text(
                              'Bathroom Cleaning',
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
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        elevation: 15,
        selectedItemColor: Color(0xFF583EF2),
        unselectedItemColor: Color(0xFF77779D),
        items: [
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
