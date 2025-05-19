part of 'pages.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _MapScreenView();
  }
}

class _MapScreenView extends StatefulWidget {
  const _MapScreenView();

  @override
  State<_MapScreenView> createState() => _MapScreenState();
}

class _MapScreenState extends State<_MapScreenView> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(33.6844, 73.0479);
  Set<Marker> _markers = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }
void _showCustomBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => CustomBottomSheet(
      professionalName: "Stephen Saville",
      profession: "Electrician",
      rating: 4.7,
      description: "Qualified electrician with extensive experience in both residential and commercial projects.",
      qualifications: "NICEIC approved",
    ),
  );
}
  Future<BitmapDescriptor> _loadIcon(BuildContext context, String assetPath) async {
  try {
    final Uint8List bytes = await getBytesFromAsset(context, assetPath, 250); 
    return BitmapDescriptor.fromBytes(bytes);
  } catch (e) {
    debugPrint('Error loading icon: $assetPath - $e');
    return BitmapDescriptor.defaultMarker;
  }
}

Future<Uint8List> getBytesFromAsset(BuildContext context, String path, int width) async {
  final ByteData data = await DefaultAssetBundle.of(context).load(path);
  final ui.Codec codec = await ui.instantiateImageCodec(
    data.buffer.asUint8List(),
    targetWidth: width,
  );
  final ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
      .buffer
      .asUint8List();
}

Future<void> _loadMarkers() async {
  try {
    final List<BitmapDescriptor> customIcons = await Future.wait([
      _loadIcon(context, Assets.imagesMapicon),
      _loadIcon(context, Assets.imagesTradeMapicon),
      _loadIcon(context, Assets.imagesPlumberMapicon),
      _loadIcon(context, Assets.imagesTradeHandMapicon),
      _loadIcon(context, Assets.imagesTradeHomeMapicon),
      _loadIcon(context, Assets.imagesElectricityMapicon),
      _loadIcon(context, Assets.imagesElectricityMapicon),
    ]);

    final List<LatLng> markerLocations = [
      const LatLng(33.6844, 73.0479),
      const LatLng(33.6900, 73.0500),
      const LatLng(33.6800, 73.0400),
      const LatLng(33.6860, 73.0550),
      const LatLng(33.6780, 73.0450),
      const LatLng(33.6920, 73.0600),
      const LatLng(33.6750, 73.0350),
    ];

    setState(() {
        _markers = markerLocations.asMap().entries.map((entry) {
          final index = entry.key;
          return Marker(
            markerId: MarkerId('marker_$index'),
            position: entry.value,
            icon: customIcons[index % customIcons.length],
            infoWindow: InfoWindow(title: 'Location ${index + 1}'),
            onTap: () => _showCustomBottomSheet(context),
          );
        }).toSet();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading markers: $e');
      _setDefaultMarkers();
    }
}

  void _setDefaultMarkers() {
    final List<LatLng> markerLocations = [
      const LatLng(33.6844, 73.0479),
      const LatLng(33.6900, 73.0500),
      const LatLng(33.6800, 73.0400),
      const LatLng(33.6860, 73.0550),
      const LatLng(33.6780, 73.0450),
      const LatLng(33.6920, 73.0600),
      const LatLng(33.6750, 73.0350),
    ];

    setState(() {
      _markers = markerLocations.asMap().entries.map((entry) {
        final index = entry.key;
        return Marker(
          markerId: MarkerId('marker_$index'),
          position: entry.value,
          infoWindow: InfoWindow(title: 'Location ${index + 1}'),
        );
      }).toSet();
      _isLoading = false;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightPeach,
      appBar: const TradesPeopleAppbar(currentScreen: MapScreen),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 15.0, // Increased zoom level
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              markers: _markers,
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.darkBlue,
        child: const Icon(Icons.my_location, color: Colors.white),
        onPressed: () {
          mapController.animateCamera(
            CameraUpdate.newLatLngZoom(_center, 14.0),
          );
        },
      ),
    );
  }
}