part of 'pages.dart';

class TradeProfilePage extends StatefulWidget {
  const TradeProfilePage({super.key});

  @override
  State<TradeProfilePage> createState() => _TradeProfilePageState();
}

class _TradeProfilePageState extends State<TradeProfilePage> {
  final List<Map<String, dynamic>> profileOptions = [
    {
      'title': 'My Account',
      'icon': Assets.svgsProfileIcon,
      'route': AppRoutes.tradeMyaccount,
    },
    {
      'title': 'Reviews',
      'icon': Assets.svgsTradeReview,
      'route': AppRoutes.tradeCustomerFeedback,
    },
    {
      'title': 'Notifications',
      'icon': Assets.svgsNotification,
      'route': AppRoutes.notificationPage,
    },
    {
      'title': 'Custom Jobs Prices',
      'icon': Assets.svgsProvider,
      'route': AppRoutes.tradeLargeJobServices,
    },
    {
      'title': 'Quick Jobs Prices',
      'icon': Assets.svgsPound,
      'route': AppRoutes.tradeRate,
    },
    {
      'title': 'Delete Account',
      'icon': Assets.svgsDeleteAccount,
      'isDelete': true, // Flag for delete option
    },
    {
      'title': 'Change Password',
      'icon': Assets.svgsPassword,
      'route': AppRoutes.changePassword,
    },
  ];

  @override
  void initState() {
    super.initState();
    // Call refreshProfile when the page initializes
    final profileController = Get.put(TradeProfileController());
    profileController.refreshProfile();
  }

  /// Updates the smalljoblist document with new predefined services
  // Future<void> _updateSmallJobServices() async {
  //   try {
  //     // Define new main and sub categories for small jobs based on the document
  //     final Map<String, List<Map<String, dynamic>>> newPredefinedServices = {
  //       'Electrician': [
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Replace socket / switch',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Light fitting change',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Fuse replacement',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Minor rewiring (single point)',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Fault finding & repair',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //       ],
  //       'Plumber': [
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Leaky tap repair',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Toilet flush fix',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Shower head replacement',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Blocked sink / drain clearance',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Radiator bleed',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //       ],
  //       'Joiner': [
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Door adjustment / hanging',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Skirting board fitting',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Shelf / cupboard repair',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Small wood repairs',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Lock / handle fitting',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //       ],
  //       'Heating Engineer': [
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Boiler service',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Radiator replacement',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Thermostat fitting',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Power flush',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Heating system check',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //       ],
  //       'Gas Engineer': [
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Gas safety check (CP12)',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Cooker / hob installation',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Gas fire service',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Leak detection',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Capping off pipe',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //       ],
  //       'Painter / Decorator': [
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'One room repaint',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Touch-ups & patchwork',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Feature wall',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Door / window frame painting',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Fence painting',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //       ],
  //       'Plasterer': [
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Small patch repairs',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Skimming a single wall/ceiling',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Coving repair',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Minor artex removal',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Plasterboard repair',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //       ],
  //       'Tiler': [
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Re-grouting',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Tile replacement (few tiles)',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Splashback tiling',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Small floor repairs',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Shower enclosure tiling patch',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //       ],
  //       'Roofer': [
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Tile / slate replacement',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Gutter leak fix',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Flat roof patch',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Minor flashing repair',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Roof inspection',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //       ],
  //       'Flooring Specialist': [
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Carpet fitting (single room)',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Laminate repair / replacement',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Small vinyl installation',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Threshold trims fitting',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Floorboard repairs',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //       ],
  //       'Locksmith': [
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Lockout entry (gain access)',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Lock replacement',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Key cutting / rekeying',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Handle/hinge fix',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Window lock install',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //       ],
  //       'Drainage Specialist': [
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Sink unblock',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Toilet unblock',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Drain jetting (small scale)',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Gully clean',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'CCTV drain survey (single line)',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //       ],
  //       'Gutter Cleaner / Installer': [
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Gutter clean',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Downpipe unblock',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Bracket repair',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Minor leak fix',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Leaf guard install',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //       ],
  //       'Driveway / Paving Installer': [
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Small patio repair',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Jet washing / sealing',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Slab replacement',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Minor edging work',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Gravel topping',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //       ],
  //       'Scaffolder': [
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Small tower scaffolds',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Short-term domestic scaffold',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Access platform for 1–2 storeys',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Edge protection install',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Minor repair scaffolds',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //       ],
  //       'Gardener': [
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Lawn mowing',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Hedge trimming',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Weeding',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Planting beds',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Jet wash patio',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //       ],
  //       'Tree Surgeon': [
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Branch trimming',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Hedge shaping',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Small tree removal',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Stump grinding (small)',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Crown lift',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //       ],
  //       'Decking Installer': [
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Decking repair',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Step replacement',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Small decking area (balcony size)',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Joist strengthening',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Handrail replacement',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //       ],
  //       'Pest Control': [
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Wasp nest removal',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Rodent traps',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Small ant treatments',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Bird spikes',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Bed bug treatment',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //       ],
  //       'Fire Alarm / Security System Installer': [
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Smoke alarm fitting',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Heat detector replacement',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Basic home alarm setup',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Security light install',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Door entry intercom',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //       ],
  //       'CCTV Installer': [
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Single camera install',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Camera reposition',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'System maintenance',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'DVR reset',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Cabling fix',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //       ],
  //     };

  //     // Update only the smalljoblist document
  //     await FirebaseFirestore.instance
  //         .collection("Services")
  //         .doc("smalljoblist")
  //         .update({"predefinedServices": newPredefinedServices});

  //     debugPrint(
  //       "✅ Successfully updated smalljoblist with new predefined services",
  //     );
  //     debugPrint("📊 Added ${newPredefinedServices.length} main categories");

  //     // Count total services
  //     int totalServices = 0;
  //     newPredefinedServices.forEach((category, services) {
  //       totalServices += services.length;
  //     });
  //     debugPrint("🔧 Total services: $totalServices");
  //   } catch (e) {
  //     debugPrint("❌ Error updating small job services: $e");
  //     rethrow;
  //   }
  // }

  // /// Updates the largejoblist document with new predefined services
  // Future<void> _updateLargeJobServices() async {
  //   try {
  //     // Define new main and sub categories for large jobs
  //     final Map<String, List<Map<String, dynamic>>> newPredefinedServices = {
  //       'Electrician': [
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Full house rewire',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Consumer unit replacement',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Outdoor lighting installation',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'New circuit installation',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Commercial wiring project',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //       ],
  //       'Plumber': [
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Bathroom installation',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Kitchen plumbing installation',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Boiler replacement (overlaps heating engineer)',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Pipe rerouting',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Underfloor heating installation',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //       ],
  //       'Joiner': [
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Full staircase build',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Kitchen fitting',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Custom wardrobes',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Loft conversion joinery',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Large decking structures',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //       ],
  //       'Heating Engineer': [
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Full central heating installation',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Boiler replacement',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'System upgrades (unvented cylinders, etc.)',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Commercial heating projects',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Underfloor heating systems',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //       ],
  //       'Gas Engineer': [
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Full gas line installation',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Boiler installation (overlaps heating engineer)',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'New heating system',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Commercial gas works',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'LPG conversions',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //       ],
  //       'Painter / Decorator': [
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Full house redecorating',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Exterior painting',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Commercial painting project',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Large wallpapering jobs',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Multi-room projects',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //       ],
  //       'Plasterer': [
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Full room skim',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Multi-room plastering',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Rendering (external walls)',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'New build plastering',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Commercial projects',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //       ],
  //       'Tiler': [
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Full bathroom tiling',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Kitchen floor tiling',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Large format tile installations',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Outdoor patio tiling',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Commercial floor tiling',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //       ],
  //       'Roofer': [
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Full roof replacement',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Loft conversion roof work',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Flat roof installation',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Commercial roofing projects',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Large-scale reroofing',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //       ],
  //       'Flooring Specialist': [
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Whole house flooring',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Hardwood flooring installation',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Large commercial flooring',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Screeding / subfloor prep',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Complex patterned flooring',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //       ],
  //       'Locksmith': [
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Full security upgrade',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Multi-property lock change',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Master key system install',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Commercial access system',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Safe installation',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //       ],
  //       'Drainage Specialist': [
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Full drain replacement',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Large CCTV drain survey',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Soakaway installation',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Septic tank replacement',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Commercial drainage works',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //       ],
  //       'Gutter Cleaner / Installer': [
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Full gutter replacement',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Fascia & soffit installation',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Commercial guttering',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Rainwater harvesting systems',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Industrial gutter installs',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //       ],
  //       'Driveway / Paving Installer': [
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Full driveway installation',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Large paving projects',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Block paving',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Resin-bound surfacing',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Commercial paving works',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //       ],
  //       'Scaffolder': [
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Full building scaffold',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Commercial site scaffold',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Complex roof scaffolds',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Large temporary structures',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Multi-storey projects',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //       ],
  //       'Gardener': [
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Full garden redesign',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Turf laying (large area)',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Fencing installation',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Hard landscaping',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Pond / water feature build',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //       ],
  //       'Tree Surgeon': [
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Large tree felling',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Land clearance',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Emergency storm clearance',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Large stump removals',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Woodland management',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //       ],
  //       'Decking Installer': [
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Full garden decking install',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Multi-level decking',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Commercial decking areas',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Timber composite structures',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Large-scale outdoor projects',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //       ],
  //       'Pest Control': [
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Full property fumigation',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Multi-property pest control',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Commercial pest control',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Agricultural pest control',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Specialist bird control systems',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //       ],
  //       'Fire Alarm / Security System Installer': [
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Full fire alarm system',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'CCTV + alarm integration',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Commercial fire/security systems',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Multi-property installations',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Smart building security',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //       ],
  //       'CCTV Installer': [
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Full system install (multi-camera)',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Commercial CCTV network',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Smart analytics setup',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Security monitoring systems',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //         {
  //           'id': FirebaseFirestore.instance.collection("Services").doc().id,
  //           'title': 'Multi-site installs',
  //           'description': null,
  //           'isCustom': false,
  //           'isEnabled': false,
  //           'price': null,
  //         },
  //       ],
  //     };

  //     // Update only the largejoblist document
  //     await FirebaseFirestore.instance
  //         .collection("Services")
  //         .doc("largejoblist")
  //         .update({"predefinedServices": newPredefinedServices});

  //     debugPrint(
  //       "✅ Successfully updated largejoblist with new predefined services",
  //     );
  //     debugPrint(
  //       "📊 Added ${newPredefinedServices.length} main categories for large jobs",
  //     );

  //     // Count total services
  //     int totalServices = 0;
  //     newPredefinedServices.forEach((category, services) {
  //       totalServices += services.length;
  //     });
  //     debugPrint("🔧 Total large job services: $totalServices");
  //   } catch (e) {
  //     debugPrint("❌ Error updating large job services: $e");
  //     rethrow;
  //   }
  // }

  void _handleOptionTap(
    BuildContext context,
    Map<String, dynamic> option,
  ) async {
    if (option['isLogout'] == true) {
      Get.offAllNamed(AppRoutes.onboarding);
      return;
    }

    if (option['isDelete'] == true) {
      final shouldDelete = await DeleteAccountDialog.show();
      if (shouldDelete == true) {
        final controller = Get.find<TradeProfileController>();
        await controller.deleteAccount();
      }
      return;
    }

    final String? route = option['route'];
    if (route != null) {
      Get.toNamed(route, arguments: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TraderouScaffold(
      appBar: const TradeProfileAppbar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: profileOptions.length,
                    itemBuilder: (context, index) {
                      final option = profileOptions[index];
                      return ProfileCard(
                        title: option['title'],
                        svgAsset: option['icon'],
                        onTap: () => _handleOptionTap(context, option),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomButton(
              text: 'Log Out',
              onTap: () async {
                // try {
                //   // Clear existing predefinedServices and add new categories for both small and large jobs
                //   await _updateSmallJobServices();
                //   await _updateLargeJobServices();
                // } catch (e) {
                //   debugPrint("Error occurred: $e");
                // }
                try {
                  final profileController = Get.find<TradeProfileController>();
                  await profileController.logout();
                } catch (e) {
                  debugPrint('Error during logout: $e');
                  await FirebaseAuth.instance.signOut();
                  Get.offAllNamed(AppRoutes.onboarding);
                }
              },
              color: AppColor.primaryButton,
              textColor: Colors.white,
              enableIcon: true,
              icon: SvgPicture.asset(
                Assets.svgsDoorExit,
                width: 20,
                height: 20,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
