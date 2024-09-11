import 'package:flutter/material.dart';

import '../widgets/topSection.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          TopSection(screenWidth: screenWidth, screenHeight: screenHeight),

          // Main content section (Your Packages and Services)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Packages',
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
                    child: Column(
                      
                      children: [
                        
                        const Text(
                          'Your packages appear here',
                          style: TextStyle(
                            color: Color(0xFF808080),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                         const SizedBox(height: 10),
                        Image.asset(
                          'public/images/emptyservice.png', // Replace with your image asset path
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
                    physics: const NeverScrollableScrollPhysics(), // Disable scrolling inside the grid
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
                                  'public/images/bathroom.png', // Replace with your image asset path
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
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        elevation: 15,
        selectedItemColor: const Color(0xFF583EF2),
        unselectedItemColor: const Color(0xFF77779D),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Bookings',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification',
          ),
        ],
      ),
    );
  }
}

