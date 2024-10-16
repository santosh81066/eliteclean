import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../providers/auth.dart';
import '../providers/loader.dart';

class Verify extends StatefulWidget {
  const Verify({super.key});

  @override
  _VerifyState createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();
  final TextEditingController _controller5 = TextEditingController();
  final TextEditingController _controller6 = TextEditingController();

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();
  final FocusNode _focusNode5 = FocusNode();
  final FocusNode _focusNode6 = FocusNode();

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    _controller5.dispose();
    _controller6.dispose();

    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    _focusNode4.dispose();
    _focusNode5.dispose();
    _focusNode6.dispose();
    super.dispose();
  }

  void _nextField(String value, FocusNode currentFocus, FocusNode? nextFocus) {
    if (value.length == 1) {
      currentFocus.unfocus();
      if (nextFocus != null) {
        FocusScope.of(context).requestFocus(nextFocus);
      }
    }
  }

  void _previousField(
      String value, FocusNode currentFocus, FocusNode? previousFocus) {
    if (value.isEmpty && previousFocus != null) {
      currentFocus.unfocus();
      FocusScope.of(context).requestFocus(previousFocus);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String phoneNumber =
        ModalRoute.of(context)?.settings.arguments as String;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon or Image
              SvgPicture.asset(
                'assets/images/icon-16-x-phone.svg', // Path to your SVG file
                fit: BoxFit.contain, // Adjust fit as needed
              ),

              // Title
              const Text(
                'Verify',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E116B),
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              // Subtitle
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  'Please enter the verification code sent to your phone number',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF77779D),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // OTP and Confirm Button Section in a bordered container
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 32.0),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFEAE9FF), width: 1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: [
                    // "Your code" label
                    const Align(
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

                    const SizedBox(height: 12),

                    // OTP input fields (Underline only)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: _buildUnderlineCodeField(
                              _controller1, _focusNode1, _focusNode2, null),
                        ),
                        const SizedBox(width: 8), // Adding gap between fields
                        Expanded(
                          child: _buildUnderlineCodeField(_controller2,
                              _focusNode2, _focusNode3, _focusNode1),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildUnderlineCodeField(_controller3,
                              _focusNode3, _focusNode4, _focusNode2),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildUnderlineCodeField(_controller4,
                              _focusNode4, _focusNode5, _focusNode3),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildUnderlineCodeField(_controller5,
                              _focusNode5, _focusNode6, _focusNode4),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildUnderlineCodeField(
                              _controller6, _focusNode6, null, _focusNode5),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Resend code and expiration text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Resend code functionality
                          },
                          child: const Text(
                            'Resend code',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6D6BE7),
                            ),
                          ),
                        ),
                        const Text(
                          'Expired after 23s',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF77779D),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Confirm button (full-width)
                    Consumer(builder: (con, ref, wid) {
                      var loader = ref.read(loadingProvider);

                      var verify = ref.watch(authProvider.notifier);
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: loader == true
                              ? null
                              : () {
                                  String smsCode = _controller1.text +
                                      _controller2.text +
                                      _controller3.text +
                                      _controller4.text +
                                      _controller5.text +
                                      _controller6.text;
                                  print("buttonpressed");
                                  verify.signInWithPhoneNumber(
                                      smsCode, context, ref, phoneNumber);
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                                0xFF583EF2), // Button background color
                            padding: const EdgeInsets.symmetric(
                                vertical: 14), // Full-width button
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: loader == true
                              ? CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'Confirm',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors
                                        .white, // White font color in button
                                  ),
                                ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for each input field of the verification code with only underline
  Widget _buildUnderlineCodeField(TextEditingController controller,
      FocusNode currentFocus, FocusNode? nextFocus, FocusNode? previousFocus) {
    return TextField(
      controller: controller,
      focusNode: currentFocus,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Color(0xFF38385E),
      ),
      onChanged: (value) {
        if (value.isNotEmpty && nextFocus != null) {
          _nextField(value, currentFocus, nextFocus);
        } else if (value.isEmpty && previousFocus != null) {
          _previousField(value, currentFocus, previousFocus);
        }
      },
      decoration: const InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFEAE9FF), width: 2),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF583EF2), width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 8),
      ),
    );
  }
}
