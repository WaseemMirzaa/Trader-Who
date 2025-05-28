part of 'widgets.dart';

class TradeJobHistoryMapScreen extends StatelessWidget {
  const TradeJobHistoryMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _TradeJobHistoryMapScreenView();
  }
}

class _TradeJobHistoryMapScreenView extends StatefulWidget {
  const _TradeJobHistoryMapScreenView();

  @override
  State<_TradeJobHistoryMapScreenView> createState() =>
      _TradeJobHistoryMapScreenState();
}

class _TradeJobHistoryMapScreenState
    extends State<_TradeJobHistoryMapScreenView> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(33.6844, 73.0479);
  final Set<Marker> _completedJobMarkers = {};
  List<JobHistory> _currentJobs = [];
  bool _isLoading = true;
  final Set<Marker> _newJobMarkers = {};
  String _selectedTab = 'New Jobs';
  // Panel state
  bool _showJobsPanel = false;

  bool _showingCompletedJobs = false;

  @override
  void initState() {
    super.initState();
    _loadMarkers();
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

  Future<BitmapDescriptor> _loadIcon(
    BuildContext context,
    String assetPath,
  ) async {
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
      const double containerSize = 150.0; // Size of the circular container
      const double iconSize = 80.0; // Size of the icon within the circle

      // Create a PictureRecorder and Canvas
      final recorder = ui.PictureRecorder();
      final canvas = ui.Canvas(recorder);

      // Draw white circular container
      final paint =
          ui.Paint()
            ..color =
                AppColor
                    .white // Using your AppColor.white
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
      final Uint8List compositeBytes = byteData.buffer.asUint8List();

      return BitmapDescriptor.fromBytes(compositeBytes);
    } catch (e) {
      debugPrint('Error loading icon: $assetPath - $e');
      return BitmapDescriptor.defaultMarker;
    }
  }

  Future<void> _loadMarkers() async {
    try {
      final List<BitmapDescriptor> newJobIcons = await Future.wait([
        _loadIcon(context, Assets.imagesMapIcon),
        _loadIcon(context, Assets.imagesTradeMapicon),
        _loadIcon(context, Assets.imagesPlumber),
      ]);

      final List<BitmapDescriptor> completedJobIcons = await Future.wait([
        _loadIcon(context, Assets.imagesTradeComp),
        _loadIcon(context, Assets.imagesTradeHouse),
        _loadIcon(context, Assets.imagesTradeHome),
      ]);

      final List<LatLng> newJobLocations = [
        const LatLng(33.6844, 73.0479),
        const LatLng(33.6900, 73.0500),
        const LatLng(33.6800, 73.0400),
      ];

      final List<LatLng> completedJobLocations = [
        const LatLng(33.6860, 73.0550),
        const LatLng(33.6780, 73.0450),
        const LatLng(33.6920, 73.0600),
      ];

      setState(() {
        _newJobMarkers.clear();
        _completedJobMarkers.clear();

        _newJobMarkers.addAll(
          newJobLocations.asMap().entries.map((entry) {
            final index = entry.key;
            return _createMarker(
              position: entry.value,
              icon: newJobIcons[index % newJobIcons.length],
              id: 'new_job_marker_$index',
              isCompleted: false,
            );
          }),
        );

        _completedJobMarkers.addAll(
          completedJobLocations.asMap().entries.map((entry) {
            final index = entry.key;
            return _createMarker(
              position: entry.value,
              icon: completedJobIcons[index % completedJobIcons.length],
              id: 'completed_job_marker_$index',
              isCompleted: true,
            );
          }),
        );

        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading markers: $e');
      _setDefaultMarkers();
    }
  }

  void _setDefaultMarkers() {
    final List<LatLng> newJobLocations = [
      const LatLng(33.6844, 73.0479),
      const LatLng(33.6900, 73.0500),
      const LatLng(33.6800, 73.0400),
    ];

    final List<LatLng> completedJobLocations = [
      const LatLng(33.6860, 73.0550),
      const LatLng(33.6780, 73.0450),
      const LatLng(33.6920, 73.0600),
    ];

    setState(() {
      _newJobMarkers.clear();
      _completedJobMarkers.clear();

      _newJobMarkers.addAll(
        newJobLocations.asMap().entries.map((entry) {
          final index = entry.key;
          return Marker(
            markerId: MarkerId('new_job_marker_$index'),
            position: entry.value,
            infoWindow: InfoWindow(title: 'New Job ${index + 1}'),
          );
        }),
      );

      _completedJobMarkers.addAll(
        completedJobLocations.asMap().entries.map((entry) {
          final index = entry.key;
          return Marker(
            markerId: MarkerId('completed_job_marker_$index'),
            position: entry.value,
            infoWindow: InfoWindow(title: 'Completed Job ${index + 1}'),
          );
        }),
      );

      _isLoading = false;
    });
  }

  Marker _createMarker({
    required LatLng position,
    required BitmapDescriptor icon,
    required String id,
    required bool isCompleted,
  }) {
    return Marker(
      markerId: MarkerId(id),
      position: position,
      icon: icon,
      onTap: () {
        setState(() {
          _currentJobs = _getSampleJobs(isCompleted);
          _showingCompletedJobs = isCompleted;
          _showJobsPanel = true;
        });
      },
    );
  }

  List<JobHistory> _getSampleJobs(bool isCompleted) {
    return List.generate(
      1,
      (index) => JobHistory(
        title: 'Electrical',
        svgIcon: Assets.svgsElectric,
        jobType: "Electrical",
        price: 120.0 + (index * 50),
        preferredTime: "ASAP",
        address: "${index + 3} miles away",
        status: isCompleted ? "Completed" : "New",
        tradesPerson: TradesPerson(
          name: "Technician ${index + 1}",
          expertise: "Electrician",
          description:
              "Leaking kitchen sink, Pipe may be cracked. Water dripping into cabinet below. Happened after turning on garbage disposal.",
          price: "\$${50 + (index * 10)}/hr",
          imageUrl: "",
          rating: 4.5 - (index * 0.1),
        ),
        showQuoteButtons: !isCompleted,
      ),
    );
  }

  Widget _buildJobsPanel() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      left: 0,
      right: 0,
      bottom: _showJobsPanel ? 0 : -400,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        decoration: BoxDecoration(
          color: AppColor.customOffWhite,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.zero, // Square bottom-left corner
            bottomRight: Radius.zero, // Square bottom-right corner
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),

              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _showingCompletedJobs ? 'Completed Jobs' : 'Available Jobs',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColor.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: _currentJobs.length,
                itemBuilder:
                    (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: MapViewCard(
                        job: _currentJobs[index],
                        onTap: () {
                          setState(() => _showJobsPanel = false);
                          // Handle job selection
                        },
                      ),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 15.0,
                ),
                markers:
                    _selectedTab == 'New Jobs'
                        ? _newJobMarkers
                        : _completedJobMarkers,
                onTap: (_) => setState(() => _showJobsPanel = false),
              ),

          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CustomToggleButton(
                      text: 'New Jobs',
                      isActive: _selectedTab == 'New Jobs',
                      onTap: () {
                        setState(() {
                          _selectedTab = 'New Jobs';
                          _showJobsPanel = false;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: CustomToggleButton(
                      text: 'Completed',
                      isActive: _selectedTab == 'Completed',
                      onTap: () {
                        setState(() {
                          _selectedTab = 'Completed';
                          _showJobsPanel = false;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          _buildJobsPanel(),
        ],
      ),
    );
  }
}
