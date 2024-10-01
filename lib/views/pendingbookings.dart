import 'package:flutter/material.dart';

class PendingBookingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Bookings Pending',
          style: TextStyle(color: Color(0xFF1E116B), fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF1E116B)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recent',
                  style: TextStyle(color: Color(0xFF1E116B), fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                bookingCard(context, '#12KL23', 'Monday - 22 Mar 2021 - 12:30 PM', 'House 1, Room 123, Brooklyn St, Kepler District', 'Hassam Safdar Khan'),
                bookingCard(context, '#12KL23', 'Monday - 22 Mar 2021 - 12:30 PM', 'House 1, Room 123, Brooklyn St, Kepler District', 'Hassam Safdar Khan'),
                bookingCard(context, '#12KL23', 'Monday - 22 Mar 2021 - 12:30 PM', 'House 1, Room 123, Brooklyn St, Kepler District', 'Hassam Safdar Khan'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget bookingCard(BuildContext context, String bookingNo, String workingTime, String location, String cleanerName) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Booking no $bookingNo', style: TextStyle(color: Color(0xFF1F1F39), fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Working time', style: TextStyle(color: Color(0xFF38385E))),
            Text(workingTime, style: TextStyle(color: Color(0xFF77779D))),
            SizedBox(height: 20),
            Text('Location', style: TextStyle(color: Color(0xFF38385E))),
            Text(location, style: TextStyle(color: Color(0xFF77779D))),
            SizedBox(height: 20),
            Text('Cleaner name', style: TextStyle(color: Color(0xFF38385E))),
            Text(cleanerName, style: TextStyle(color: Color(0xFF77779D))),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity, // Set width to double.infinity to make the button full width
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/viewbooking');
                },
                child: Text(
                  'View',
                  style: TextStyle(
                    color: Color(0xFF583EF2),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    height: 0.12,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF3F3FC),
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3), // Reduced the corner radius here
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
