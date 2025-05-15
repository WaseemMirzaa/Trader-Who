part of 'pages.dart';
/// A page that handles the login process for the application.
///
/// This widget displays the mobile view for the login screen.
class LoginPage extends StatelessWidget {
  /// Creates an instance of the [LoginPage].
  ///
  /// The `key` is used to identify this widget in the widget tree.
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (BuildContext context, AuthState state) {
          return const MobileView();
        },
      ),
    );
  }
}