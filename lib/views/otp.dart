import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Verify extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon or Image
             SvgPicture.asset(
                      'public/images/icon-16-x-phone.svg', // Path to your SVG file
                      fit: BoxFit.contain, // Adjust fit as needed
                    ),
            
            // Title
            Text(
              'Verify',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E116B),
              ),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: 8),
            
            // Subtitle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                'Please enter the verification code sent to your phone number',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF77779D),
                ),
              ),
            ),
            
            SizedBox(height: 24),
            
            // OTP and Confirm Button Section in a bordered container
            Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.symmetric(horizontal: 32.0),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFEAE9FF), width: 1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                children: [
                  // "Your code" label
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Your code',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF38385E),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 12),
                  
                  // OTP input fields (Underline only)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildUnderlineCodeField(),
                      _buildUnderlineCodeField(),
                      _buildUnderlineCodeField(),
                      _buildUnderlineCodeField(),
                    ],
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Resend code and expiration text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Resend code functionality
                        },
                        child: Text(
                          'Resend code',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6D6BE7),
                          ),
                        ),
                      ),
                      Text(
                        'Expired after 23s',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF77779D),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 24),
                  
                  // Confirm button (full-width)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
Navigator.pushNamed(context, '/home');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF583EF2), // Button background color
                        padding: EdgeInsets.symmetric(vertical: 14), // Full-width button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'Confirm',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white, // White font color in button
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
    );
  }

  // Widget for each input field of the verification code with only underline
  Widget _buildUnderlineCodeField() {
    return SizedBox(
      width: 60,
      child: TextField(
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Color(0xFF38385E),
        ),
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFEAE9FF), width: 2),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF583EF2), width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 8),
        ),
      ),
    );
  }
}
