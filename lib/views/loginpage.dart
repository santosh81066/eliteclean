import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../providers/auth.dart';
import '../providers/loader.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _controller = TextEditingController();

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
              SizedBox(
                  height: screenHeight * 0.1), // Space from top to the logo

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Form fields
                    const SizedBox(height: 25),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Phone number',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F1F39),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.phone_outlined,
                                color: Color(0xFFB8B8D2)),
                            const SizedBox(width: 8),
                            Text(
                              "+91 ",
                              style: TextStyle(fontSize: 16),
                            ),
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                keyboardType: TextInputType.phone,
                                decoration: const InputDecoration(
                                  hintText: 'your phone number here',
                                  border: InputBorder.none,
                                  hintStyle:
                                      TextStyle(color: Color(0xFFB8B8D2)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                      ],
                    ),
                    const SizedBox(height: 60),

                    // "Next" button aligned at the bottom and full width
                    Consumer(
                      builder:
                          (BuildContext context, WidgetRef ref, Widget? child) {
                        var loader = ref.watch(loadingProvider);
                        return SizedBox(
                          width: double
                              .infinity, // Makes the button take full width
                          child: ElevatedButton(
                            onPressed: loader == true
                                ? () {} // Disable interaction but keep the style
                                : () {
                                    // Start the loader
                                    ref.read(loadingProvider.notifier).state =
                                        true;

                                    // Start the loader and wait for 3 seconds
                                    Future.delayed(const Duration(seconds: 3),
                                        () {
                                      // Stop the loader
                                      ref.read(loadingProvider.notifier).state =
                                          false;

                                      // Navigate to the next page
                                      Navigator.pushNamed(context, '/verify');
                                    });

                                    // Phone authentication (can be asynchronous)
                                    ref.read(authProvider.notifier).phoneAuth(
                                          context,
                                          "+91${_controller.text.trim()}",
                                          ref,
                                        );
                                  },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: const Color(
                                  0xFF583EF2), // Button color remains constant
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: loader == true
                                ? CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    'Next',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors
                                          .white, // Set text color to white
                                    ),
                                  ),
                          ),
                        );
                      },
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
