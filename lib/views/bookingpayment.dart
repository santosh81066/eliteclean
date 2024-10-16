import 'package:flutter/material.dart';

class PaymentForBooking extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Confirm Bookings",
          style: TextStyle(
            fontSize: 16,
            color: Color(0xff1F126B),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            // Header (Time and Status)

            SizedBox(height: 16),

            // Payment method selection
            _buildPaymentMethodSection(),

            SizedBox(height: 16),

            // Card details form
            _buildCardDetailsSection(),

            Spacer(),

            // Save card info toggle

            // Footer (Next button)
            _buildFooterButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose a payment method',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        RadioListTile(
          value: 'Credit card',
          groupValue: 'Credit card',
          title: Text('Credit card'),
          onChanged: (value) {},
        ),
        RadioListTile(
          value: 'Paypal',
          groupValue: null,
          title: Text('Paypal'),
          onChanged: (value) {},
        ),
        RadioListTile(
          value: 'Cash',
          groupValue: null,
          title: Text('Cash'),
          onChanged: (value) {},
        ),
      ],
    );
  }

  Widget _buildCardDetailsSection() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0x33000000),
          width: 0.5,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(2.0),
          topRight: Radius.circular(25.0),
          bottomLeft: Radius.circular(25.0),
          bottomRight: Radius.circular(25.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              value: true,
              onChanged: (bool value) {},
              title: Text('Save card information'),
            ),
            _buildTextField(label: 'Card holder’s name', value: 'John Smith'),
            SizedBox(
              height: 16,
            ),
            _buildTextField(label: 'Card number', value: '1233 2343 2432 2243'),
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Expanded(
                    child: _buildTextField(label: 'Valid til', value: '12/21')),
                SizedBox(width: 16),
                Expanded(child: _buildTextField(label: 'CVV', value: '***')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildFooterButton(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          _showMyDialog(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF583EF2),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          'Next',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button to dismiss the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'Confirmation',
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF583EF2),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Selected Package',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Only Once',
                  style: TextStyle(
                    color: Color(0x80000000),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Service',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Bathroom Cleaning',
                  style: TextStyle(
                    color: Color(0x80000000),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Amount',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      'Total payable amount   ',
                      style: TextStyle(
                        color: Color(0x80000000),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '10\$',
                      style: TextStyle(
                        color: Color(0xff6E6BE8),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Center(
              child: ElevatedButton(
                child: Text(
                  'Confirm',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  // Perform action and then dismiss the dialog
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF583EF2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
