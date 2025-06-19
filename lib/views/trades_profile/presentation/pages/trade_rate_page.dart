part of 'pages.dart';

class TradeRatePage extends StatefulWidget {
  const TradeRatePage({super.key});

  @override
  TraderSetupScreenState createState() => TraderSetupScreenState();
}

class TraderSetupScreenState extends State<TradeRatePage> {
  String? selectedCategory;

  final Map<String, List<ServiceItem>> tradeServices = {
    'Custom Services': [], // New category for user-added services
    'Electrician': [
      ServiceItem(title: 'Replace socket'),
      ServiceItem(title: 'Install light fitting'),
      ServiceItem(title: 'Replace light switch'),
      ServiceItem(title: 'Install extractor fan'),
      ServiceItem(title: 'Replace fuse'),
      ServiceItem(title: 'Install outside security light'),
    ],
    'Plumber': [
      ServiceItem(title: 'Fix leaking tap'),
      ServiceItem(title: 'Replace tap'),
      ServiceItem(title: 'Unblock sink or toilet'),
      ServiceItem(title: 'Install new kitchen or basin tap'),
      ServiceItem(title: 'Replace toilet flush mechanism'),
      ServiceItem(title: 'Fit outside tap'),
      ServiceItem(title: 'Seal around sink or bath'),
    ],
    'Heating Engineer / Gas Engineer': [
      ServiceItem(title: 'Bleed radiators'),
      ServiceItem(title: 'Replace thermostat'),
      ServiceItem(title: 'Service boiler'),
      ServiceItem(title: 'Replace radiator valve'),
      ServiceItem(title: 'Balance heating system'),
      ServiceItem(title: 'Fit new radiator'),
    ],
    'Carpenter / Joiner': [
      ServiceItem(title: 'Hang internal door'),
      ServiceItem(title: 'Trim door'),
      ServiceItem(title: 'Fit door handles or locks'),
      ServiceItem(title: 'Fit skirting board'),
      ServiceItem(title: 'Install shelves'),
      ServiceItem(title: 'Repair floorboard'),
      ServiceItem(title: 'Box in pipework'),
    ],
    'Painter & Decorator': [
      ServiceItem(title: 'Paint a single wall'),
      ServiceItem(title: 'Touch up marked walls'),
      ServiceItem(title: 'Paint internal door'),
      ServiceItem(title: 'Paint front door'),
    ],
    'Tiler': [
      ServiceItem(title: 'Re-grout tiles'),
      ServiceItem(title: 'Replace cracked tile'),
      ServiceItem(title: 'Tile kitchen splashback'),
      ServiceItem(title: 'Seal around tiles'),
    ],
    'Plasterer': [
      ServiceItem(title: 'Patch repair small wall'),
      ServiceItem(title: 'Skim ceiling'),
      ServiceItem(title: 'Plaster small boxing-in section'),
    ],
    'Roofer': [
      ServiceItem(title: 'Replace broken tile'),
      ServiceItem(title: 'Seal flashing'),
      ServiceItem(title: 'Patch flat roof'),
      ServiceItem(title: 'Clear blocked gutter'),
      ServiceItem(title: 'Soffit repair'),
      ServiceItem(title: 'Re-seal leaking gutter joint'),
    ],
    'Flooring Specialist': [
      ServiceItem(title: 'Repair lifted floor plank'),
      ServiceItem(title: 'Fit door threshold strip'),
      ServiceItem(title: 'Replace carpet gripper'),
    ],
    'Bricklayer / Builder': [
      ServiceItem(title: 'Re-point small wall section'),
      ServiceItem(title: 'Repair step or brick crack'),
      ServiceItem(title: 'Patch render/masonry'),
    ],
    'Window Fitter / Glazier': [
      ServiceItem(title: 'Replace single-glazed pane'),
      ServiceItem(title: 'Adjust stiff window'),
      ServiceItem(title: 'Reseal draughty window'),
      ServiceItem(title: 'Replace handle or hinge'),
    ],
    'Locksmith': [
      ServiceItem(title: 'Replace front door lock'),
      ServiceItem(title: 'Fit night latch or deadbolt'),
      ServiceItem(title: 'Adjust misaligned lock'),
      ServiceItem(title: 'Unlock jammed internal door'),
    ],
    'Drainage Specialist': [
      ServiceItem(title: 'Unblock outdoor drain'),
      ServiceItem(title: 'Jet-wash drain'),
      ServiceItem(title: 'Reseal gully trap'),
      ServiceItem(title: 'Clear debris from downpipe'),
    ],
    'Gutter Cleaner / Installer': [
      ServiceItem(title: 'Clean gutters on one side of house'),
      ServiceItem(title: 'Fix gutter bracket'),
      ServiceItem(title: 'Install leaf guard'),
      ServiceItem(title: 'Seal leaking corner joint'),
    ],
    'Fence Installer': [
      ServiceItem(title: 'Replace fence panel'),
      ServiceItem(title: 'Repair or re-secure post'),
      ServiceItem(title: 'Fit new gate latch'),
      ServiceItem(title: 'Straighten leaning fence section'),
    ],
    'Driveway / Paving Installer': [
      ServiceItem(title: 'Re-sand block paving'),
      ServiceItem(title: 'Clean driveway surface'),
      ServiceItem(title: 'Repair 1–2 sunken blocks'),
      ServiceItem(title: 'Edge tarmac border'),
    ],
    'Scaffolder': [
      ServiceItem(
        title: 'Install small scaffold tower (e.g. for gutter access)',
      ),
      ServiceItem(title: 'Dismantle small scaffolding section'),
      ServiceItem(title: 'Add handrail or guard rail'),
      ServiceItem(title: 'Provide temporary working platform'),
    ],
    'Gardener / Landscaper': [
      ServiceItem(title: 'Mow lawn'),
      ServiceItem(title: 'Trim hedges'),
      ServiceItem(title: 'Remove garden waste'),
      ServiceItem(title: 'Weed flower beds'),
      ServiceItem(title: 'Lay small turf patch'),
      ServiceItem(title: 'Install edging or border'),
    ],
    'Tree Surgeon / Arborist': [
      ServiceItem(title: 'Prune low branches'),
      ServiceItem(title: 'Remove small tree'),
      ServiceItem(title: 'Trim overhanging limb'),
      ServiceItem(title: 'Grind small stump'),
    ],
    'Decking Installer': [
      ServiceItem(title: 'Replace deck board'),
      ServiceItem(title: 'Clean and treat decking'),
      ServiceItem(title: 'Fit handrail or edging'),
      ServiceItem(title: 'Secure loose board'),
    ],
    'Pest Control': [
      ServiceItem(title: 'Treat wasp nest'),
      ServiceItem(title: 'Lay traps or bait for rodents'),
      ServiceItem(title: 'Spray for ants or insects'),
      ServiceItem(title: 'Block common rodent entry point'),
    ],
    'Fire Alarm / Security System Installer': [
      ServiceItem(title: 'Install smoke or heat alarm'),
      ServiceItem(title: 'Replace alarm battery or sensor'),
      ServiceItem(title: 'Service alarm system'),
      ServiceItem(title: 'Test and reconfigure home alarm'),
    ],
    'CCTV Installer': [
      ServiceItem(title: 'Install basic external camera'),
      ServiceItem(title: 'Re-align or adjust CCTV angle'),
      ServiceItem(title: 'Connect CCTV to app or Wi-Fi'),
      ServiceItem(title: 'Replace camera unit'),
    ],
  };

  final Map<String, IconData> categoryIcons = {
    'Custom Services': Icons.add_circle_outline,
    'Electrician': Icons.electrical_services,
    'Plumber': Icons.plumbing,
    'Heating Engineer / Gas Engineer': Icons.local_fire_department,
    'Carpenter / Joiner': Icons.handyman,
    'Painter & Decorator': Icons.brush,
    'Tiler': Icons.grid_4x4,
    'Plasterer': Icons.construction,
    'Roofer': Icons.roofing,
    'Flooring Specialist': Icons.chair,
    'Bricklayer / Builder': Icons.engineering,
    'Window Fitter / Glazier': Icons.window,
    'Locksmith': Icons.lock,
    'Drainage Specialist': Icons.water_damage,
    'Gutter Cleaner / Installer': Icons.grain,
    'Fence Installer': Icons.fence,
    'Driveway / Paving Installer': Icons.directions_walk,
    'Scaffolder': Icons.stairs,
    'Gardener / Landscaper': Icons.grass,
    'Tree Surgeon / Arborist': Icons.park,
    'Decking Installer': Icons.deck,
    'Pest Control': Icons.bug_report,
    'Fire Alarm / Security System Installer': Icons.security,
    'CCTV Installer': Icons.videocam,
  };

  void _showPriceDialog(ServiceItem service, int index) {
    final titleController = TextEditingController(text: service.title);
    final descController = TextEditingController(
      text: service.description ?? '',
    );
    final priceController = TextEditingController(
      text: service.price?.toStringAsFixed(0) ?? '',
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              service.isCustom ? 'Add Custom Service' : 'Set Fixed Price',
            ),
            content: SingleChildScrollView(
              child: SizedBox(
                width:
                    MediaQuery.of(context).size.width *
                    0.8, // 80% of screen width
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (service.isCustom) ...[
                      TextField(
                        style: TextStyle(color: AppColor.secondaryText),
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: 'Service Title',
                          labelStyle: TextStyle(
                            color: AppColor.secondaryText,
                            fontFamily: 'openSans',
                          ),
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.all(12),
                        ),
                        autofocus: true,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        style: TextStyle(color: AppColor.secondaryText),
                        controller: descController,
                        decoration: const InputDecoration(
                          labelText: 'Description (Optional)',
                          labelStyle: TextStyle(
                            color: AppColor.secondaryText,
                            fontFamily: 'openSans',
                          ),
                          border: OutlineInputBorder(),
                          hintText: 'Brief description of what\'s included',
                          hintStyle: TextStyle(
                            color: AppColor.secondaryText,
                            fontFamily: 'openSans',
                          ),
                          contentPadding: EdgeInsets.all(12),
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),
                    ],
                    TextField(
                      style: TextStyle(color: AppColor.secondaryText),
                      controller: priceController,
                      decoration: const InputDecoration(
                        labelText: 'Fixed Price (£)',
                        border: OutlineInputBorder(),
                        prefixText: '£ ',
                        contentPadding: EdgeInsets.all(12),
                      ),
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,2}'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              if (service.isCustom)
                TextButton(
                  onPressed: () {
                    setState(() {
                      tradeServices[selectedCategory!]!.removeAt(index);
                    });
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryButton, // Background color
                  foregroundColor: Colors.white, // Text color (optional)
                  // You can add other styling properties here as needed
                ),
                onPressed: () {
                  setState(() {
                    if (service.isCustom) {
                      service.title = titleController.text.trim();
                      service.description =
                          descController.text.trim().isEmpty
                              ? null
                              : descController.text.trim();
                    }
                    service.price = double.tryParse(priceController.text);
                    service.isEnabled =
                        service.price != null && service.price! > 0;
                  });
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  void _addCustomService() {
    final service = ServiceItem(title: '', isCustom: true);
    setState(() {
      tradeServices['Custom Services']!.add(service);
      selectedCategory = 'Custom Services';
    });
    _showPriceDialog(service, tradeServices['Custom Services']!.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    return TraderWhoScaffold(
      appBar: TradeRatesAppbar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Set Your Prices',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColor.primaryText,
              ),
              const SizedBox(height: 8),
              CustomText(
                text:
                    'Configure your small job services and set fixed prices for instant bookings.',
                fontSize: 13,
                maxLines: 2,
                color: AppColor.secondaryText,
              ),
              const SizedBox(height: 18),

              if (selectedCategory == null) ...[
                const CustomText(
                  text: 'Select your trade category:',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColor.primaryText,
                ),
                const SizedBox(height: 16),
                ...tradeServices.keys.map((category) {
                  int enabledServices =
                      tradeServices[category]!.where((s) => s.isEnabled).length;
                  int totalServices = tradeServices[category]!.length;

                  return CategoryCard(
                    category: category,
                    icon: categoryIcons[category] ?? Icons.build,
                    enabledServices: enabledServices,
                    totalServices: totalServices,
                    onTap: () {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                  );
                }),
                const SizedBox(height: 20),
                // Add Custom Service Button (always visible)
                AddCustomServiceButton(onPressed: _addCustomService),
                const SizedBox(height: 20),
                // Continue Button
                CustomButton(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TraderOnboardingPage(),
                      ),
                    );
                  },
                  color: AppColor.primaryButton,
                  text: 'Continue',
                  textColor: AppColor.white,
                ),
              ] else ...[
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = null;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6B35).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        categoryIcons[selectedCategory] ?? Icons.build,
                        color: const Color(0xFFFF6B35),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        selectedCategory!,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3A8A),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Configure your services:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColor.secondaryText,
                    fontFamily: 'openSans',
                  ),
                ),
                const SizedBox(height: 16),

                // Service Cards List
                ...tradeServices[selectedCategory]!.asMap().entries.map((
                  entry,
                ) {
                  int index = entry.key;
                  ServiceItem service = entry.value;
                  return ServiceCardWidget(
                    service: service,
                    onEditPressed: () => _showPriceDialog(service, index),
                  );
                }),

                // Add Custom Service Button (in category view)
                const SizedBox(height: 16),
                AddCustomServiceButton(onPressed: _addCustomService),
                const SizedBox(height: 32),

                // Save Configuration Button
                CustomButton(
                  onTap: () {},
                  color: AppColor.primaryButton,
                  text: 'Save Configuration',
                  textColor: AppColor.white,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
