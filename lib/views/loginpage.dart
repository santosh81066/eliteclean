import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.1), // Space from top to the logo

              // Logo at the top
              SvgPicture.asset(
                      'public/images/logo-icon.svg', // Path to your SVG file
                      fit: BoxFit.contain, // Adjust fit as needed
                    ),

              SizedBox(height: 16),

              // "Sign up" text
              Text(
                'Sign up',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E116B),
                ),
              ),
              SizedBox(height: 8),

              // Subtext
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Please enter your details to sign up and create an account.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF77779D),
                  ),
                ),
              ),
              SizedBox(height: 32),

              // Form container (expanded towards the bottom)
              Container(
                padding: const EdgeInsets.all(24),
                margin: const EdgeInsets.symmetric(horizontal: 32),
                height: screenHeight * 0.60, // Adjust height of the container
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Color(0xFFEAE9FF)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align the button at the bottom
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Form fields
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // "Your name" label and input field
                                               // "Phone number" label and input field
                        Text(
                          'Phone number',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F1F39),
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.phone_outlined, color: Color(0xFFB8B8D2)),
                            SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  hintText: 'your phone number here',
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(color: Color(0xFFB8B8D2)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(),

                      ],
                    ),

                    // "Next" button aligned at the bottom and full width
                    SizedBox(
                      width: double.infinity, // Makes the button take full width
                      child: ElevatedButton(
                        onPressed: () {
                      Navigator.pushNamed(context, '/verify');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Color(0xFF583EF2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          'Next',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white, // Set text color to white
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
