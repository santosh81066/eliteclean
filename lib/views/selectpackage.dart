import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SelectPackage extends StatefulWidget {
  const SelectPackage({super.key});

  @override
  State<SelectPackage> createState() => _SelectPackageState();
}

class _SelectPackageState extends State<SelectPackage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final _dateTimeController = TextEditingController();
  final _noteController = TextEditingController(); // Controller for the note section

  @override
  void initState() {
    super.initState();
    // Properly initialize the TabController
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _pickDateTime(BuildContext context) async {
    // First, pick the date
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      // Then, pick the time
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        // Both date and time are selected, update the controller and state
        setState(() {
          _selectedDate = pickedDate;
          _selectedTime = pickedTime;
          // Format the combined date and time
          _dateTimeController.text = DateFormat('yMMMd').format(pickedDate) +
              ' - ' +
              pickedTime.format(context);
        });
      } else {
        // If the user did not pick a time, clear the selected date
        setState(() {
          _selectedDate = null;
          _dateTimeController.clear();
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose(); // Properly dispose of the TabController
    _dateTimeController.dispose(); // Dispose of the date controller
    _noteController.dispose(); // Dispose of the note controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Package'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E116B),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E116B)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TabBar Section
            TabBar(
              dividerColor: Colors.transparent,
              controller: _tabController,
              indicator: BoxDecoration(
                color: const Color(0xFFFFDFF5), // Set the background color for the active tab
                borderRadius: BorderRadius.circular(15),
              ),
              tabs: [
                Tab(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 35),
                    decoration: BoxDecoration(
                      color: _tabController.index == 0
                          ? const Color(0xFFFFDFF5)
                          : Colors.black.withOpacity(0.2),
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(15),
                          topLeft: Radius.circular(2),
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15)),
                      border: Border.all(
                        color: _tabController.index == 0
                            ? const Color(0xFFFF66B3)
                            : Colors.transparent,
                      ),
                    ),
                    child: const Text(
                      'Instant',
                      style: TextStyle(
                        color: Color(0xFF1E116B),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 35),
                    decoration: BoxDecoration(
                      color: _tabController.index == 1
                          ? const Color(0xFFFFDFF5)
                          : Colors.black.withOpacity(0.2),
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(15),
                          topLeft: Radius.circular(2),
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15)),
                      border: Border.all(
                        color: _tabController.index == 1
                            ? const Color(0xFFFF66B3)
                            : Colors.transparent,
                      ),
                    ),
                    child: const Text(
                      'Monthly',
                      style: TextStyle(
                        color: Color(0xFF1E116B),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
              onTap: (index) {
                setState(() {});
              },
            ),
            const SizedBox(height: 16),
            // Text section for explaining the package
            Text(
              'This pack includes daily cleaning of the total number of washrooms you selected.',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF38385E),
              ),
            ),
            const SizedBox(height: 16),
            // Date and Time Picker Field
            Text(
              'Start Date & Time',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF38385E),
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _pickDateTime(context), // Call date & time picker on tap
              child: AbsorbPointer(
                child: TextFormField(
                  controller: _dateTimeController,
                  decoration: InputDecoration(
                    hintText: 'Select Date & Time',
                    hintStyle: const TextStyle(
                      color: Color(0xFFB8B8D2),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    prefixIcon: const Icon(
                      Icons.calendar_today,
                      color: Color(0xFF9191B2),
                    ),
                    // Change underline color
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFB8B8D2)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFB8B8D2)),
                    ),
                  ),
                ),
              ),
            ),
            
            // Cost per Day Section
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F3FC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cost per day per 1 washroom is',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Total number of washrooms and app cost will be\ncalculated at the end.',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: Color(0xFF5E5D5D),
                        ),
                      ),
                      Text(
                        '\$5',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
             const SizedBox(height: 16),
                    Text(
              'Note',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF38385E),
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _noteController,
              decoration: InputDecoration(
                hintText: 'Eg: Bathroom needs harder clean',
                hintStyle: const TextStyle(
                  color: Color(0xFFB8B8D2),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                // Change underline color for note field
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFB8B8D2)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFB8B8D2)),
                ),
              ),
              maxLines: 3,
            ),
          
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // Navigate to next screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF583EF2),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Center(
                child: Text(
                  'Next',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
