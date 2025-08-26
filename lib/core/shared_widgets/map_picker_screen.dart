// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:traderwho/core/theme/app_color.dart';
import 'package:traderwho/core/utils/location_utils.dart';

class MapPickerScreen extends StatefulWidget {
  final LatLng? initialLocation;
  final bool showSearchBar;

  const MapPickerScreen({
    super.key,
    this.initialLocation,
    this.showSearchBar = true,
  });

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  late GoogleMapController mapController;
  LatLng? _selectedLocation;
  String _address = "Searching address...";
  bool _loading = true;
  CameraPosition? cameraPosition;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Use initial location if provided, otherwise get current location
    if (widget.initialLocation != null) {
      setState(() {
        _selectedLocation = widget.initialLocation;
        _loading = false;
      });
      _getAddressFromLatLng(widget.initialLocation!);
    } else {
      _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _loading = false;
        _address = "Location services are disabled";
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _loading = false;
          _address = "Location permissions denied";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _loading = false;
        _address = "Location permissions permanently denied";
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _selectedLocation = LatLng(position.latitude, position.longitude);
      _loading = false;
    });

    _getAddressFromLatLng(_selectedLocation!);
  }

  Future<void> _getAddressFromLatLng(LatLng latLng) async {
    try {
      final address = await LocationUtils.getAddressFromLatLng(latLng);
      setState(() {
        _address = address;
      });
    } catch (e) {
      setState(() {
        _address = "Could not get address";
      });
    }
  }

  Future<void> _animateToPosition(LatLng position) async {
    await mapController.animateCamera(CameraUpdate.newLatLngZoom(position, 15));
  }

  Future<void> _getCurrentLocationAndAnimate() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      LatLng newLocation = LatLng(position.latitude, position.longitude);
      setState(() {
        _selectedLocation = newLocation;
        _address = "Getting address...";
      });

      await _animateToPosition(newLocation);
      _getAddressFromLatLng(newLocation);
    } catch (e) {
      setState(() {
        _address = "Could not get current location";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : _selectedLocation == null
              ? Center(child: Text(_address))
              : Stack(
                children: [
                  // Google Map
                  GoogleMap(
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    zoomGesturesEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: _selectedLocation!,
                      zoom: 15,
                    ),
                    mapType: MapType.normal,
                    onMapCreated: (controller) {
                      mapController = controller;
                    },
                    onCameraMove: (CameraPosition position) {
                      cameraPosition = position;
                    },
                    onCameraIdle: () async {
                      if (cameraPosition != null) {
                        setState(() {
                          _selectedLocation = cameraPosition!.target;
                          _address = "Getting address...";
                        });
                        _getAddressFromLatLng(cameraPosition!.target);
                      }
                    },
                  ),

                  // Location pin in center
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 35),
                      child: const Icon(
                        Icons.location_pin,
                        size: 50,
                        color: Colors.red,
                      ),
                    ),
                  ),

                  // Top UI elements
                  Positioned(
                    top: 50,
                    left: 10,
                    right: 10,
                    child: Row(
                      children: [
                        // Back button
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 3,
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, size: 20),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),

                        const SizedBox(width: 10),

                        // Search bar (optional)
                        if (widget.showSearchBar)
                          Expanded(
                            child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: _searchController,
                                decoration: const InputDecoration(
                                  hintText: 'Search for places...',
                                  prefixIcon: Icon(Icons.search),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 12,
                                  ),
                                ),
                                onTap: () async {
                                  // Open search for places
                                  final result = await showSearch(
                                    context: context,
                                    delegate: LocationSearchDelegate(),
                                  );

                                  if (result != null) {
                                    setState(() {
                                      _selectedLocation = result;
                                      _address = "Getting address...";
                                    });
                                    await _animateToPosition(result);
                                    _getAddressFromLatLng(result);
                                  }
                                },
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Current location button
                  Positioned(
                    bottom: 120,
                    right: 15,
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22.5),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 3,
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.gps_fixed,
                          color: Colors.black87,
                        ),
                        onPressed: _getCurrentLocationAndAnimate,
                      ),
                    ),
                  ),

                  // Bottom address display and confirm button
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Address display
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                  size: 25,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _address,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Lat: ${_selectedLocation!.latitude.toStringAsFixed(6)}, '
                                        'Lng: ${_selectedLocation!.longitude.toStringAsFixed(6)}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 15),

                          // Confirm button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed:
                                  _selectedLocation == null
                                      ? null
                                      : () {
                                        Get.back(
                                          result: {
                                            'address': _address,
                                            'lat': _selectedLocation!.latitude,
                                            'lon': _selectedLocation!.longitude,
                                          },
                                        );
                                      },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.orangeCustomColor,
                                foregroundColor: Colors.white,
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Confirm Location',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}

class LocationSearchDelegate extends SearchDelegate<LatLng?> {
  final List<Map<String, dynamic>> _popularPlaces = [
    {'name': 'Current Location', 'action': 'current_location'},
    {'name': 'New York, NY', 'lat': 40.7128, 'lng': -74.0060},
    {'name': 'Los Angeles, CA', 'lat': 34.0522, 'lng': -118.2437},
    {'name': 'Chicago, IL', 'lat': 41.8781, 'lng': -87.6298},
    {'name': 'Houston, TX', 'lat': 29.7604, 'lng': -95.3698},
    {'name': 'Phoenix, AZ', 'lat': 33.4484, 'lng': -112.0740},
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final filteredPlaces =
        query.isEmpty
            ? _popularPlaces
            : _popularPlaces
                .where(
                  (place) => place['name'].toString().toLowerCase().contains(
                    query.toLowerCase(),
                  ),
                )
                .toList();

    return ListView.builder(
      itemCount: filteredPlaces.length,
      itemBuilder: (context, index) {
        final place = filteredPlaces[index];
        return ListTile(
          leading: Icon(
            place['action'] == 'current_location'
                ? Icons.gps_fixed
                : Icons.location_on,
            color: AppColor.orangeCustomColor,
          ),
          title: Text(place['name']),
          onTap: () async {
            if (place['action'] == 'current_location') {
              try {
                Position position = await Geolocator.getCurrentPosition(
                  desiredAccuracy: LocationAccuracy.high,
                );
                close(context, LatLng(position.latitude, position.longitude));
              } catch (e) {
                // Handle error - maybe show snackbar
                close(context, null);
              }
            } else {
              close(context, LatLng(place['lat'], place['lng']));
            }
          },
        );
      },
    );
  }
}
