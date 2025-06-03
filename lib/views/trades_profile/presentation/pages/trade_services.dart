part of 'pages.dart';

class TradeServicesPage extends StatelessWidget {
  const TradeServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: const TradeServicesAppbar(),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return ServiceCard(service: service);
        },
      ),
    );
  }
}

// Sample data
final List<Service> services = [
  Service(title: "Basic Plumbing Repair", price: 75.00),
  Service(title: "Electrical Installation", price: 120.00),
  Service(title: "Gas Eng", price: 90.00),
  Service(title: "HVAC Maintenance", price: 150.00),
  Service(title: "Roof Inspection", price: 200.00),
  Service(title: "Appliance Installation", price: 85.00),
  Service(title: "Painting Service", price: 60.00),
  Service(title: "Emergency Repair", price: 250.00),
];
