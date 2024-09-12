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
  int _selectedMonthIndex = 0;
  int _selectedUseIndex = 0; // For selecting months

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _pickDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDate = pickedDate;
          _selectedTime = pickedTime;
          _dateTimeController.text = DateFormat('yMMMd').format(pickedDate) +
              ' - ' +
              pickedTime.format(context);
        });
      } else {
        setState(() {
          _selectedDate = null;
          _dateTimeController.clear();
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _dateTimeController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Widget _buildSelectableMonths() {
    List<String> months = ['1', '3', '6', '12'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(months.length, (index) {
        bool isSelected = _selectedMonthIndex == index;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedMonthIndex = index;
            });
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF583EF2).withOpacity(0.5) : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF583EF2)),
            ),
            child: Center(
              child: Text(
                months[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF583EF2),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSelectableUses() {
    List<String> uses = ['1', '2', '4'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(uses.length, (index) {
        bool isSelected = _selectedUseIndex == index;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedUseIndex = index;
            });
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF583EF2).withOpacity(0.5) : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF583EF2)),
            ),
            child: Center(
              child: Text(
                uses[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF583EF2),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      }),
    );
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
      body: SingleChildScrollView( // Added scrolling here
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TabBar Section
              TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: const Color(0xFFFFDFF5),
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
                          bottomRight: Radius.circular(15),
                        ),
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
                          bottomRight: Radius.circular(15),
                        ),
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
              
              // Package description
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 81,
                padding: const EdgeInsets.only(top: 13, left: 21, right: 20, bottom: 14),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0xFFEAE9FF)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        'This pack includes daily cleaning of total number of washrooms you selected.',
                        style: TextStyle(
                          color: const Color(0xFF38385E),
                          fontSize: MediaQuery.of(context).size.width * 0.035,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Months selection (only visible if "Monthly" is selected)
              if (_tabController.index == 1) const SizedBox(
                width: 311,
                child: Text(
                  'Select no.of months',
                  style: TextStyle(
                    color: Color(0xFF1F1F39),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
             if (_tabController.index == 1) const SizedBox(height: 16),
              if (_tabController.index == 1) _buildSelectableMonths(),
              const SizedBox(height: 16),
              
              // Uses selection
              if (_tabController.index == 1) const Text(
                'No.of uses',
                style: TextStyle(
                  color: Color(0xFF1F1F39),
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
          if (_tabController.index == 1)    const SizedBox(height: 16),
              if (_tabController.index == 1) _buildSelectableUses(),
            if (_tabController.index == 1)  const SizedBox(height: 16),
              
              // Date and Time Picker Field
              const Text(
                'Start Date & Time',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF38385E),
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _pickDateTime(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _dateTimeController,
                    decoration: const InputDecoration(
                      hintText: 'Select Date & Time',
                      hintStyle: TextStyle(
                        color: Color(0xFFB8B8D2),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      prefixIcon: Icon(
                        Icons.calendar_today,
                        color: Color(0xFF9191B2),
                      ),
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
              const SizedBox(height: 16),
              
              // Cost section
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F3FC),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cost per day per 1 washroom is',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
              
              // Note section
              const Text(
                'Note',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF38385E),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  hintText: 'Eg: Bathroom needs harder clean',
                  hintStyle: TextStyle(
                    color: Color(0xFFB8B8D2),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFB8B8D2)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFB8B8D2)),
                  ),
                ),
                maxLines: 3,
              ),
              
              // Next button
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                Navigator.pushNamed(context, '/confirmbooking');
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
      ),
    );
  }
}
