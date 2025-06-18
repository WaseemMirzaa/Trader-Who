part of 'widgets.dart';
// lib/data/category_data.dart

class CategoryData {
  static final Map<String, List<Map<String, dynamic>>> subCategories = {
    'Electricians': [
      {'name': 'Replace socket', 'price': '£50-£80'},
      {'name': 'Install light fitting', 'price': '£60-£100'},
      {'name': 'Replace light switch', 'price': '£45-£75'},
      {'name': 'Install extractor fan', 'price': '£80-£150'},
      {'name': 'Replace fuse', 'price': '£40-£70'},
      {'name': 'Install outside security light', 'price': '£90-£160'},
    ],
    'Plumbers': [
      {'name': 'Fix leaking tap', 'price': '£60-£90'},
      {'name': 'Replace tap', 'price': '£70-£120'},
      {'name': 'Unblock sink or toilet', 'price': '£80-£150'},
      {'name': 'Install new kitchen or basin tap', 'price': '£90-£180'},
      {'name': 'Replace toilet flush mechanism', 'price': '£60-£110'},
      {'name': 'Fit outside tap', 'price': '£100-£180'},
      {'name': 'Seal around sink or bath', 'price': '£50-£90'},
    ],
    'Heating Engineers': [
      {'name': 'Bleed radiators', 'price': '£60-£100'},
      {'name': 'Replace thermostat', 'price': '£80-£150'},
      {'name': 'Service boiler', 'price': '£80-£120'},
      {'name': 'Replace radiator valve', 'price': '£70-£130'},
      {'name': 'Balance heating system', 'price': '£90-£160'},
      {'name': 'Fit new radiator', 'price': '£120-£200'},
    ],
    'Gas Engineers': [
      {'name': 'Gas safety check', 'price': '£60-£100'},
      {'name': 'Install gas cooker', 'price': '£80-£150'},
      {'name': 'Repair gas leak', 'price': '£100-£200'},
      {'name': 'Service gas boiler', 'price': '£80-£140'},
    ],
    'Builders': [
      {'name': 'Small wall repair', 'price': '£100-£200'},
      {'name': 'Repair brickwork', 'price': '£120-£250'},
      {'name': 'Small extension', 'price': '£2000-£5000'},
      {'name': 'Structural repair', 'price': '£150-£300'},
    ],
    // Add all other categories with their subcategories...
    // Continue with the rest of your categories in the same format
  };
}
