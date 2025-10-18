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
  // double userLat = Get.find<UserController>().latitude.value;
  // double userLng = Get.find<UserController>().longitude.value;
  final LatLng _center = LatLng(
    Get.find<UserController>().latitude.value,
    Get.find<UserController>().longitude.value,
  );
  Set<Marker> _markers = {};
  late TradesPeopleController _controller;

  @override
  void initState() {
    super.initState();
    // Find the existing controller instead of creating a new one
    _controller = Get.find<TradesPeopleController>();
    // Use ever() to listen to changes in the tradesPeople list
    ever(_controller.filteredServices, (_) => _loadMarkersFromController());
    ever(_controller.isLoading, (_) {
      if (!_controller.isLoading.value) {
        _loadMarkersFromController();
      }
    });
    _loadMarkersFromController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadMarkersFromController() async {
    final tradesServices = _controller.filteredServices;
    print(
      'Map Screen: Loading markers, tradesServices count: ${tradesServices.length}',
    );

    if (tradesServices.isEmpty) {
      setState(() {
        _markers = {};
      });
      return;
    }

    final List<Marker> markers = [];
    for (int i = 0; i < tradesServices.length; i++) {
      ServiceItem service = tradesServices[i];
      print(
        'Service ${i}: ${service.title}, lat: ${service.tradesPerson?.latitude}, lng: ${service.tradesPerson?.longitude}',
      );

      // Check if coordinates are valid (not 0.0 or default values)
      if (service.tradesPerson?.latitude != 0.0 &&
          service.tradesPerson?.longitude != 0.0) {
        markers.add(
          Marker(
            markerId: MarkerId('tradesperson_${service.tradesPerson?.id}'),
            position: LatLng(
              service.tradesPerson?.latitude ?? 0.0,
              service.tradesPerson?.longitude ?? 0.0,
            ),
            infoWindow: InfoWindow(
              title: service.tradesPerson?.name ?? '',
              snippet: service.tradesPerson?.bio ?? '',
              onTap:
                  () => _showCustomBottomSheet(
                    context,
                    service.tradesPerson!,
                    service.price!,
                    _controller.selectedJobType.value,
                  ),
            ),
          ),
        );
      }
    }

    print('Map Screen: Created ${markers.length} markers');
    setState(() {
      _markers = markers.toSet();
    });
  }

  void _showCustomBottomSheet(
    BuildContext context,
    TradesPerson person,
    double price,
    String selectedJobType,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => CustomBottomSheet(
            person: person,
            price: price,
            selectedJobType: selectedJobType,
          ),
    );
  }

  // TODO: Custom marker icon loader - currently using default markers
  // Uncomment and use this method to load custom marker icons for traders
  // ignore: unused_element
  Future<BitmapDescriptor> _loadIcon(
    BuildContext context,
    String assetPath, {
    bool isFirstIcon = false, // New parameter to identify the special icon
  }) async {
    try {
      // Load the original icon
      final Uint8List iconBytes = await getBytesFromAsset(
        context,
        assetPath,
        60, // Size for the icon inside the circle
      );

      // Decode the icon image
      final ui.Codec codec = await ui.instantiateImageCodec(iconBytes);
      final ui.FrameInfo frameInfo = await codec.getNextFrame();
      final ui.Image iconImage = frameInfo.image;

      // Define container properties
      const double containerSize = 150.0;
      const double iconSize = 80.0;

      // Create a PictureRecorder and Canvas
      final recorder = ui.PictureRecorder();
      final canvas = ui.Canvas(recorder);

      // Determine the background color
      final backgroundColor = isFirstIcon ? AppColor.darkBlue : AppColor.white;

      // Draw circular container with appropriate color
      final paint =
          ui.Paint()
            ..color = backgroundColor
            ..style = ui.PaintingStyle.fill;
      canvas.drawCircle(
        ui.Offset(containerSize / 2, containerSize / 2),
        containerSize / 2,
        paint,
      );

      // Draw the icon centered in the container
      canvas.drawImageRect(
        iconImage,
        ui.Rect.fromLTWH(
          0,
          0,
          iconImage.width.toDouble(),
          iconImage.height.toDouble(),
        ),
        ui.Rect.fromCenter(
          center: ui.Offset(containerSize / 2, containerSize / 2),
          width: iconSize,
          height: iconSize,
        ),
        ui.Paint(),
      );

      // Convert the canvas to an image
      final ui.Image compositeImage = await recorder.endRecording().toImage(
        containerSize.toInt(),
        containerSize.toInt(),
      );

      // Convert the composite image to bytes
      final ByteData? byteData = await compositeImage.toByteData(
        format: ui.ImageByteFormat.png,
      );
      if (byteData == null) {
        return BitmapDescriptor.defaultMarker;
      }
      return BitmapDescriptor.fromBytes(byteData.buffer.asUint8List());
    } catch (e) {
      debugPrint('Error loading icon: $assetPath - $e');
      return BitmapDescriptor.defaultMarker;
    }
  }

  Future<Uint8List> getBytesFromAsset(
    BuildContext context,
    String path,
    int width,
  ) async {
    final ByteData data = await DefaultAssetBundle.of(context).load(path);
    final ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    final ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(
      format: ui.ImageByteFormat.png,
    ))!.buffer.asUint8List();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return TraderWhoScaffold(
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_controller.filteredServices.isEmpty) {
          return Center(
            child: Text(
              'No tradespeople available',
              style: TextStyle(fontSize: 18, color: AppColor.primaryText),
            ),
          );
        }
        return GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(target: _center, zoom: 15.0),
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          markers: _markers,
        );
      }),
    );
  }
}
