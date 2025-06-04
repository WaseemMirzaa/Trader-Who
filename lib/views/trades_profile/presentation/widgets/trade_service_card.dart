part of 'widgets.dart';

class ServiceCard extends StatelessWidget {
  final Service service;
  final Function(Service) onEdit;
  final Function(Service) onDelete;

  const ServiceCard({
    super.key,
    required this.service,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        constraints: const BoxConstraints(minHeight: 60),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    service.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColor.black,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '£${service.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColor.darkerGray,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      height: 32, // Reduced container height
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColor.midGray, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero, // Remove default padding
                            constraints:
                                const BoxConstraints(), // Remove default constraints
                            icon: const Icon(
                              Icons.edit,
                              size: 16,
                            ), // Smaller icon
                            color: AppColor.mediumGray,
                            onPressed: () {
                              // Show edit dialog
                              showDialog(
                                context: context,
                                builder:
                                    (context) => CustomDialogs.editService(
                                      service: service,
                                      onSave: (updatedService) {
                                        if (updatedService != null) {
                                          onEdit(updatedService);
                                        }
                                        Navigator.pop(
                                          context,
                                        ); // Close the dialog
                                      },
                                    ),
                              );
                            },
                          ),
                          Container(
                            height: 16, // Smaller divider
                            width: 1,
                            color: AppColor.mediumGray,
                          ),
                          IconButton(
                            padding: EdgeInsets.zero, // Remove default padding
                            constraints:
                                const BoxConstraints(), // Remove default constraints
                            icon: const Icon(
                              Icons.delete,
                              size: 16, // Smaller icon
                              color: Colors.red,
                            ),
                            onPressed: () {
                              // Show delete confirmation dialog
                              showDialog(
                                context: context,
                                builder:
                                    (context) =>
                                        CustomDialogs.deleteServiceConfirmation(
                                          serviceName: service.title,
                                          onConfirm: () {
                                            onDelete(service);
                                          },
                                        ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (service.description != null) ...[
              const SizedBox(height: 6),
              Text(
                service.description!,
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class Service {
  final String title;
  final double price;
  final String? description;

  Service({
    required this.title, // Make sure these are named parameters
    required this.price,
    this.description,
  });
}
