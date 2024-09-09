import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
    @override
  void initState() {
    super.initState();

    // Navigate to the login page after a delay
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }
  @override
  Widget build(BuildContext context) {
    // Get screen width and height
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(color: Color(0xFF583EF2)),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // The icon inside the circle
              Container(
                width: screenWidth * 0.2,
                height: screenWidth * 0.2,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(100),
                      bottomLeft: Radius.circular(100),
                      bottomRight: Radius.circular(100),
                    ),
                  ),
                ),
                child: Center(
                  child: Container(
                    width: screenWidth * 0.12,
                    height: screenWidth * 0.12,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(),
                    child: SvgPicture.asset(
                      'public/images/icon-32-x-clean.svg', // Path to your SVG file
                      fit: BoxFit.contain, // Adjust fit as needed
                    ), // Replace this with your custom icon
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.05),  // Space between the logo and text
              // The text below the logo
              Text(
                'EliteClean',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.07, // Dynamic font size
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
