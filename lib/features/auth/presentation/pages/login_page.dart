part of 'pages.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsiveness
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6), // Equivalent to bg-gray-100
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenWidth > 600 ? 400 : screenWidth * 0.9,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Splash Screen Image
                Image.asset(
                  Assets.imagesSplashscreen,
                  width: screenWidth > 600 ? 200 : screenWidth * 0.5,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: screenHeight * 0.05), // Space after image

                // Custom Text: Trusted TradesPeople
                Text(
                  'Trusted TradesPeople',
                  style: TextStyle(
                    fontFamily: 'HelveticaNeue',
                    fontSize: screenWidth > 600 ? 28 : 24,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),

                
              

                // Login Button (Yellow)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Add login functionality here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFC107), // Yellow
                      foregroundColor: Colors.white, // Text color
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.02,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontFamily: 'HelveticaNeue',
                        fontSize: screenWidth > 600 ? 18 : 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02), // Space between buttons

                // Create New Account Button (White)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Add create account functionality here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black, // Text color
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.02,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                    ),
                    child: Text(
                      'Create New Account',
                      style: TextStyle(
                        fontFamily: 'HelveticaNeue',
                        fontSize: screenWidth > 600 ? 18 : 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03), // Space before policy

                // Policy Text
                Text(
                  'By continuing you agree to the policy',
                  style: TextStyle(
                    fontFamily: 'HelveticaNeue',
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: const Color(0xFF6B7280), // Gray color
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}