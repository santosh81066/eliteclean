import 'package:flutter/material.dart';

import '../widgets/topSection.dart';

class ServiceDetails extends StatefulWidget {
  const ServiceDetails({super.key});

  @override
  _ServiceDetailsState createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
  // Index of the selected item
  int washroomCount = 1; // Initial count for washrooms



  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          TopSection(screenWidth: screenWidth, screenHeight: screenHeight),

          // Body Section
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Services',
                      style: TextStyle(
                        color: Color(0xFF1E116B),
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Service Card with Counter
                    Row(
                      children: [
                        // Service Description
                        Container(
                          width: 122,
                          height: 160,
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFF6D6BE7), width: 1),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(2),
                              topRight: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                            ),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: Image.asset(
                                  'public/images/bathroom.png', // Replace with your image asset path
                                  height: 50,
                                  width: 50,
                                ),
                              ),
                              const SizedBox(height: 15),
                              const Text(
                                'Bathroom Cleaning',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF38385E),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 16), // Spacing between the service and the counter

                        // Counter Buttons
                        Container(
                          width: 54,
                          height: 160,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xB5F0F0F0), // Reverted background
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Increment Button
                              IconButton(
                                icon: const Icon(Icons.add),
                                iconSize: 30,
                                color: Colors.black,
                                onPressed: () {
                                  setState(() {
                                    washroomCount++;
                                  });
                                },
                              ),
                              // Count Display with Background Color
                              Container(
                                width: 54,
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF583EF2), // Background color for the number
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    '$washroomCount',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                              ),
                              // Decrement Button
                              IconButton(
                                icon: const Icon(Icons.remove),
                                iconSize: 30,
                                color: Colors.black,
                                onPressed: () {
                                  if (washroomCount > 1) {
                                    setState(() {
                                      washroomCount--;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    const Text(
                      'Charges',
                      style: TextStyle(
                        color: Color(0xFF1E116B),
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Charges Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Per 1 washroom',
                          style: TextStyle(
                            color: Color(0xFF38385E),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        Text(
                          '\$10',
                          style: TextStyle(
                            color: Color(0xFF6D6BE7),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'App cost',
                          style: TextStyle(
                            color: Color(0xFF38385E),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        Text(
                          '5%',
                          style: TextStyle(
                            color: Color(0xFF6D6BE7),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Total payable amount',
                          style: TextStyle(
                            color: Color(0xFF38385E),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        Text(
                          '\$12',
                          style: TextStyle(
                            color: Color(0xFF6D6BE7),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Next Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: Align(
              alignment: Alignment.centerRight, // Right-aligned button
              child: SizedBox(
                width: 155,
                height: 46,
                child: ElevatedButton(
                  onPressed: () {
          Navigator.pushNamed(context, '/selectpackage');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF583EF2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar
     
    );
  }
}
