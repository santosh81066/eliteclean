import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import '../providers/locationnotifier.dart';
import '../providers/textfieldnotifier.dart';

class SelectPackage extends ConsumerStatefulWidget {
  const SelectPackage({super.key});

  @override
  ConsumerState<SelectPackage> createState() => _SelectPackageState();
}

class _SelectPackageState extends ConsumerState<SelectPackage>
    with SingleTickerProviderStateMixin {
  int loCount = 0;
  MapController mapController = MapController();
  late TabController _tabController;
  bool mapIsMoving = false;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final _dateTimeController = TextEditingController();
  final _noteController =
      TextEditingController(); // Controller for the note section
// Controller for the note section
  int _selectedMonthIndex = 0;
  int _selectedUseIndex = 0;
  final _searchController = TextEditingController();

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
    mapController.dispose();
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
              color: isSelected
                  ? const Color(0xFF583EF2).withOpacity(0.5)
                  : Colors.white,
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
              color: isSelected
                  ? const Color(0xFF583EF2).withOpacity(0.5)
                  : Colors.white,
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
    final locationState = ref.watch(locationProvider);
    final locationNotifier = ref.read(locationProvider.notifier);
    final textState = ref.watch(textFieldProvider);
    MapController mapController = MapController();
    if (locationState.address != null && _searchController.text.isEmpty) {
      _searchController.text = locationState.address!;
    }
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TabBar Section
              TabBar(
                dividerColor: Colors.transparent,
                controller: _tabController,
                indicator: BoxDecoration(
                  color: const Color(0xFFFFDFF5),
                  borderRadius: BorderRadius.circular(15),
                ),
                tabs: [
                  Tab(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 35),
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 35),
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
                padding: const EdgeInsets.only(
                    top: 13, left: 21, right: 20, bottom: 14),
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
              if (_tabController.index == 1)
                const SizedBox(
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
              if (_tabController.index == 1)
                const SizedBox(
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
              if (_tabController.index == 1)
                const Text(
                  'No.of uses',
                  style: TextStyle(
                    color: Color(0xFF1F1F39),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              if (_tabController.index == 1) const SizedBox(height: 16),
              if (_tabController.index == 1)
                const Text(
                  'No.of uses',
                  style: TextStyle(
                    color: Color(0xFF1F1F39),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              if (_tabController.index == 1) const SizedBox(height: 16),
              if (_tabController.index == 1) _buildSelectableUses(),
              const SizedBox(height: 16),

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
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    children: List.generate(
                      loCount,
                      (index) => // Change 10 to the number of items you want
                          Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        width: 110,
                        height: 130,
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                                2), // Top-left corner with radius 2
                            topRight:
                                Radius.circular(20), // Keep other corners at 20
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          border: Border.all(
                            color: Color(0xff6E6BE8),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 50, // Adjust the size as needed
                              child: Image.asset(
                                'assets/images/Home.png', // Replace with your image path
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'House ${index + 1}', // Dynamic text
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff6E6BE8),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              ElevatedButton(
                onPressed: () async {
                  // Get the user ID from Firebase Authentication
                  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

                  // Ensure user ID is not empty before proceeding
                  if (userId.isNotEmpty) {
                    // Get the location count for the user ID
                    int count = await getLocationCount(userId);

                    // Update the state with the new location count
                    setState(() {
                      loCount = count;
                    });

                    // Display the count or use it in your app
                    print("Total number of locations for user $userId: $count");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Total number of locations for user $userId: $count'),
                      ),
                    );
                  } else {
                    // Handle case where user is not authenticated
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('User is not authenticated.'),
                      ),
                    );
                  }
                },
                child: Icon(Icons.refresh),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.06,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFF3F3FC),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        print("add address tapped");

                        if (locationState.currentPosition != null) {
                          // Open the dialog and listen for changes in locationState using a Consumer
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Consumer(
                                builder: (context, ref, child) {
                                  // Re-read the locationState inside the dialog
                                  final locationState =
                                      ref.watch(locationProvider);
                                  LatLng selectedLocation =
                                      locationState.currentPosition!;

                                  return AlertDialog(
                                    contentPadding: EdgeInsets
                                        .zero, // Remove default padding
                                    content: SizedBox(
                                      width: double.maxFinite,
                                      height: 400, // Adjust height for the map
                                      child: Stack(
                                        children: [
                                          // Search field positioned at the top
                                          Positioned(
                                            top: 10,
                                            left: 10,
                                            right: 10,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.1),
                                                    blurRadius: 5,
                                                    spreadRadius: 1,
                                                  ),
                                                ],
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: TextField(
                                                  onChanged: (text) {
                                                    // Update Riverpod's state
                                                    ref
                                                        .read(textFieldProvider
                                                            .notifier)
                                                        .updateText(text);
                                                  },
                                                  controller: _searchController,
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10,
                                                            horizontal: 16),
                                                    hintText:
                                                        'Search for a location',
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide:
                                                          BorderSide.none,
                                                    ),
                                                    suffixIcon: textState == ''
                                                        ? IconButton(
                                                            icon: const Icon(
                                                                Icons.clear),
                                                            onPressed: () {
                                                              _searchController
                                                                  .clear();
                                                              ref
                                                                  .read(locationProvider
                                                                      .notifier)
                                                                  .clearaddress();
                                                              // Clear Riverpod's state
                                                              ref
                                                                  .read(textFieldProvider
                                                                      .notifier)
                                                                  .clearText();
                                                            },
                                                          )
                                                        : const Icon(
                                                            Icons.search),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          // Map layer below the search bar
                                          Positioned(
                                            top:
                                                60, // Adjust this to ensure the search bar is not blocked by the map
                                            left: 0,
                                            right: 0,
                                            bottom:
                                                60, // Add space for the Confirm button
                                            child: FlutterMap(
                                              mapController: mapController,
                                              options: MapOptions(
                                                initialCenter: selectedLocation,
                                                initialZoom: 15,
                                                minZoom:
                                                    5, // Set min zoom level
                                                maxZoom: 18,
                                                onTap: (_, latLng) {
                                                  // Update the current location in Riverpod's state when tapped
                                                  ref
                                                      .read(locationProvider
                                                          .notifier)
                                                      .setCurrentLocation(
                                                          latLng);
                                                  print(
                                                      "on tap change address: ${latLng.latitude}, ${latLng.longitude}");
                                                },
                                              ),
                                              children: [
                                                TileLayer(
                                                  urlTemplate:
                                                      'https://mts1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
                                                  subdomains: [
                                                    'mt0',
                                                    'mt1',
                                                    'mt2',
                                                    'mt3'
                                                  ],
                                                ),
                                                MarkerLayer(
                                                  markers: [
                                                    Marker(
                                                      point: selectedLocation,
                                                      child: const Icon(
                                                        Icons.location_pin,
                                                        color: Colors.red,
                                                        size: 40.0,
                                                      ),
                                                      rotate: true,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Address and Confirm button
                                          Positioned(
                                            bottom: 0,
                                            left: 0,
                                            right: 0,
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: SizedBox(
                                                    width: double.infinity,
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        // Hardcode the location ID (replace "12345" with your actual location ID)
                                                        String locationId = '';

                                                        // Check if current position and address are available
                                                        if (locationState
                                                                    .currentPosition !=
                                                                null &&
                                                            locationState
                                                                    .address !=
                                                                null) {
                                                          // Call the method to upload location data to Realtime Database with the hardcoded ID
                                                          locationNotifier
                                                              .uploadLocationToRealtimeDB(
                                                            locationId, // Hardcoded location ID
                                                            locationState
                                                                .currentPosition!, // Pass the current position
                                                            locationState
                                                                .address!, // Pass the address
                                                          );
                                                        } else {
                                                          // Show error message if location or address is missing
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                                content: Text(
                                                                    'Location or address is missing')),
                                                          );
                                                        }
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor: Colors
                                                            .green, // Button background color
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            vertical:
                                                                16.0), // Button height
                                                      ),
                                                      child: const Text(
                                                        'Confirm',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize:
                                                                16), // Text styling
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        } else {
                          // If currentPosition is null, show an error or loading indicator
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Location not found'),
                                content: const Center(
                                  child: Text(
                                      'Unable to fetch location. Please try again.'),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF583EF2),
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Color(0xFF583EF2),
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Flexible(
                              child: Text(
                                'Add another address',
                                style: TextStyle(
                                  color: Color(0xFF583EF2),
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Cost section
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<int> getLocationCount(String locationId) async {
    final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
    User? user = FirebaseAuth.instance.currentUser;
    try {
      // Get the data snapshot of the location_list under the specified id
      DatabaseEvent event =
          await dbRef.child('${user!.uid}/address_list').once();

      // Check if the location_list exists and count the number of children (locations)
      if (event.snapshot.exists) {
        Map<dynamic, dynamic>? locations =
            event.snapshot.value as Map<dynamic, dynamic>?;
        int locationCount =
            locations?.length ?? 0; // Get the number of items in the list
        print("Number of location entries: $locationCount");
        return locationCount;
      } else {
        print("No locations found for ID: ${user.uid}");
        return 0; // No location_list exists
      }
    } catch (e) {
      print("Failed to retrieve location count: $e");
      return 0;
    }
  }
}
