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
      builder:
          (context) => CustomBottomSheet(
            professionalName: "Stephen Saville",
            profession: "Electrician",
            rating: 4.7,
            description:
                "Qualified electrician with extensive experience in both residential and commercial projects.",
            qualifications: "NICEIC approved",
          ),
    );
  }

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

  Future<void> _loadMarkers() async {
    try {
      final List<BitmapDescriptor> customIcons = await Future.wait([
        _loadIcon(context, Assets.imagesTradeMapicon, isFirstIcon: true),
        _loadIcon(context, Assets.imagesMapIcon),
        _loadIcon(context, Assets.imagesPlaster),
        _loadIcon(context, Assets.imagesTilers),
        _loadIcon(context, Assets.imagesTradeHouse),
        _loadIcon(context, Assets.imagesTradeComp),
        _loadIcon(context, Assets.imagesTradeHome),
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
        _markers =
            markerLocations.asMap().entries.map((entry) {
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
      _markers =
          markerLocations.asMap().entries.map((entry) {
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
    return TraderWhoScaffold(
      body:
          _isLoading
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
    );
  }
}
