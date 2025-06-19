part of 'pages.dart';

class TraderOnboardingPage extends StatefulWidget {
  const TraderOnboardingPage({super.key});

  @override
  _TraderOnboardingPageState createState() => _TraderOnboardingPageState();
}

class _TraderOnboardingPageState extends State<TraderOnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _onboardingItems = [
    OnboardingItem(
      icon: Icons.work_outline,
      title: "Welcome to the Platform!",
      description:
          "Get ready to connect with customers and grow your business with our on-demand service platform.",
      color: Colors.blue,
    ),
    OnboardingItem(
      icon: Icons.category_outlined,
      title: "Job Categories & Pricing",
      description:
          "Set fixed prices for common, straightforward jobs – these let customers book you instantly without messaging or quoting.",
      color: Colors.green,
      details: [
        "Fixed prices for instant booking",
        "Custom quotes for complex jobs",
        "Flexible pricing options",
      ],
    ),
    OnboardingItem(
      icon: Icons.flash_on,
      title: "Speed is Key",
      description:
          "The app is designed for fast, on-demand work, so the quicker you quote, the more likely you are to win the job.",
      color: Colors.orange,
      details: [
        "Quick response = more jobs",
        "Quote based on text, photos, or video",
        "Beat the competition with speed",
      ],
    ),
    OnboardingItem(
      icon: Icons.handshake_outlined,
      title: "Complete the Job",
      description:
          "Once accepted, you can chat, video call, and go do the job — all hassle-free.",
      color: Colors.purple,
      details: [
        "Built-in chat system",
        "Video calling feature",
        "Seamless job completion",
      ],
    ),
  ];

  void _completeOnboarding() {
    // Navigate to main page
    final navController = NavigationController.to;
    navController.navigateToMainPage();
  }

  @override
  Widget build(BuildContext context) {
    return TraderWhoScaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: "Getting Started",

                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: AppColor.primaryText,
                  ),
                  TextButton(
                    onPressed: () {
                      // Skip onboarding
                      _completeOnboarding();
                    },
                    child: CustomText(
                      text: "Skip",
                      color: AppColor.secondaryText,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            // Page View
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _onboardingItems.length,
                itemBuilder: (context, index) {
                  return _buildOnboardingPage(_onboardingItems[index]);
                },
              ),
            ),

            // Page Indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _onboardingItems.length,
                (index) => _buildPageIndicator(index),
              ),
            ),

            // Bottom Navigation
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Previous Button
                  _currentPage > 0
                      ? TextButton(
                        onPressed: () {
                          _pageController.previousPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: CustomText(
                          text: "Previous",
                          color: AppColor.secondaryText,
                          fontSize: 16,
                        ),
                      )
                      : SizedBox(width: 80),

                  // Next/Get Started Button
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage < _onboardingItems.length - 1) {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        // Complete onboarding
                        _completeOnboarding();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _onboardingItems[_currentPage].color,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      _currentPage < _onboardingItems.length - 1
                          ? "Next"
                          : "Get Started",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(OnboardingItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(item.icon, size: 60, color: item.color),
          ),

          SizedBox(height: 40),

          // Title
          Text(
            item.title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColor.primaryText,
              fontFamily: 'openSans',
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 20),

          // Description
          Text(
            item.description,
            style: TextStyle(
              fontSize: 15,
              color: AppColor.secondaryText,
              fontFamily: 'openSans',
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          // Details (if any)
          if (item.details != null) ...[
            SizedBox(height: 30),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: item.color.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: item.color.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                children:
                    item.details!.map((detail) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: item.color,
                              size: 20,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                detail,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'openSans',
                                  color: AppColor.secondaryText,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
            ),
          ],

          SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(int index) {
    return Container(
      width: _currentPage == index ? 24 : 8,
      height: 8,
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color:
            _currentPage == index
                ? _onboardingItems[_currentPage].color
                : Colors.grey[300],
      ),
    );
  }
}

class OnboardingItem {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final List<String>? details;

  OnboardingItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    this.details,
  });
}
