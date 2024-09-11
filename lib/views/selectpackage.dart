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
  final _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Properly initialize the TabController
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _pickDate(BuildContext context) async {
    // Open the date picker
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      // If a date is selected, update the controller and state
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = DateFormat('yMMMd').format(pickedDate);
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose(); // Properly dispose of the TabController
    _dateController.dispose(); // Dispose of the date controller
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
                            : Colors.transparent
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
            // Date Picker Field
            Text(
              'Start Date',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF38385E),
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _pickDate(context), // Call date picker on tap
              child: AbsorbPointer(
                child: TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    hintText: 'Select Date',
                    hintStyle: TextStyle(
                      color: Color(0xFFB8B8D2),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color(0xFFD2D2D2),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color(0xFF583EF2),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color(0xFFD2D2D2),
                      ),
                    ),
                    suffixIcon: Icon(
                      Icons.calendar_today,
                      color: Color(0xFF9191B2),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
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
