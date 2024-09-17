import 'package:flutter/material.dart';

class ConfirmBookingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              SizedBox(height: 50),
              Row(
                children: [
                  Icon(Icons.arrow_back, size: 24, color: Color(0xFF583EF2)),
                  SizedBox(width: 8),
                  Text(
                    "Confirm your booking",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E116B),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Card(
                elevation: 2,
                color: Colors.white, // Set card background color to white
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Color(0xFFEAE9FF)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderRow("Booking detail", Icons.edit),
                      SizedBox(height: 10),
                      _buildDetailItem("Package selected", "Select a package"),
                      _buildDetailItem("Working time", "Monday - 22 Mar 2021\n12:30 PM"),
                      _buildDetailItem("Location", "House 1"),
                      _buildLocationDetail(),
                      _buildDetailItem("Note", "No note added"),
                      _buildDetailItem("Cleaner", "Hassam Safdar Khan"),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Card(
                elevation: 2,
                color: Colors.white, // Set card background color to white
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Color(0xFFEAE9FF)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderRow("Payment detail", Icons.edit),
                      SizedBox(height: 10),
                      _buildDetailItem("Payment method", "Credit card"),
                      SizedBox(height: 10),
                      Text("Charges", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF38385E))),
                      SizedBox(height: 10),
                      _buildChargeRow("Per 1 washroom", "\$10"),
                      _buildChargeRow("Per 1 day", "\$2"),
                      _buildChargeRow("Total days", "30"),
                      _buildChargeRow("App cost", "5%"),
                      _buildChargeRow("Total payable amount", "\$12"),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              _buildBottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderRow(String title, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF583EF2),
          ),
        ),
        Icon(icon, color: Color(0xFF583EF2), size: 20),
      ],
    );
  }

  Widget _buildDetailItem(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF38385E)),
        ),
        SizedBox(height: 5),
        Text(
          subtitle,
          style: TextStyle(fontSize: 14, color: Color(0xFF77779D)),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildLocationDetail() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(Icons.location_pin, color: Color(0xFF6D6BE7)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "Room 123, Brooklyn St, Kepler District",
              style: TextStyle(fontSize: 14, color: Color(0xFF77779D)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChargeRow(String label, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: Color(0xFF77779D))),
          Text(amount, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF6D6BE7))),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildDot(Color(0xFFF3A8A2)),
              SizedBox(width: 10),
              _buildDot(Color(0xFFF3A8A2)),
              SizedBox(width: 10),
              _buildDot(Color(0xFFF3A8A2)),
            ],
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF583EF2),
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              "Book now",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white, // Set button text color to white
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
