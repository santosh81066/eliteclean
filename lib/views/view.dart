import 'package:flutter/material.dart';

class ViewBooking extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Booking Detail'),
        centerTitle: true,
        // Removes the back button
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Booking Details Card
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BookingDetailRow(
                          title: 'Working time',
                          value: 'Monday - 22 Mar 2021 - 12:30 PM'),
                      BookingDetailRow(
                          title: 'Cleaner name', value: 'Hassam Safdar Khan'),
                      BookingDetailRow(
                          title: 'Location',
                          value: 'Room 123, Brooklyn St, Kepler District'),
                      BookingDetailRow(title: 'Note', value: 'No note added'),
                      BookingDetailRow(
                          title: 'Package Selected', value: 'Daily'),
                      BookingDetailRow(title: 'Total cost', value: '\$12'),
                      BookingDetailRow(
                          title: 'Payment Method', value: 'Credit card'),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Generate OTP Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Color(0xFFF7658B), backgroundColor: Color(0xFFFFEAF0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {},
                child: Text(
                  'Generate OTP',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BookingDetailRow extends StatelessWidget {
  final String title;
  final String value;

  const BookingDetailRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF38385E),
            ),
          ),
          SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF77779D),
            ),
          ),
        ],
      ),
    );
  }
}
