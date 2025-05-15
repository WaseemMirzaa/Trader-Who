part of 'pages.dart';



/// A page that handles the sign-up process for the application.
///
/// This widget displays the mobile view for the sign-up screen.
class SignUpPage extends StatefulWidget {
  /// Creates an instance of the [SignUpPage].
  ///
  /// The `key` is used to identify this widget in the widget tree.
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const MobileView(), 
    );
  }
}