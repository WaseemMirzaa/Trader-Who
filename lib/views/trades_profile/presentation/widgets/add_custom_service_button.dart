part of 'widgets.dart';

class AddCustomServiceButton extends StatelessWidget {
  const AddCustomServiceButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColor.primaryButton,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.add_circle_outline,
              color: AppColor.primaryText,
              size: 24,
            ),
            SizedBox(width: 12),
            Text(
              'Add Custom Service',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'openSans',
                color: AppColor.primaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
