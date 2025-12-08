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
      title: "You’re all set!",
      description:
          "You’re ready to start getting job alerts, connect with customers in real-time, and get paid instantly - no more chasing leads, quotes or late payments!",
      color: Colors.blue,
    ),
    OnboardingItem(
      icon: Icons.category_outlined,
      title: "Job Categories & Pricing",
      description: "There are two ways to price your jobs on Traderou:",
      color: Colors.green,
      details: [
        "1. Quick Job Rates\nSet fixed prices for small, straightforward jobs that you're comfortable having pre-set prices for. When you're online, your prices show instantly to nearby customers - no need for you to quote. If they're happy they can book you straight away. You accept their booking, complete the job, get paid.\n• Same day jobs\n• Faster work opportunities, less admin",
        "2. Custom Job Rates\nCreate quotes for bigger or more complex work that needs a site visit or more information.\n• Full control over pricing\n• Great for larger or bespoke jobs",
        "You can utilise both pricing options - it's your call. Use quick rates for speed and more opportunity, and use custom quotes for flexibility.",
      ],
    ),

    OnboardingItem(
      icon: Icons.handshake_outlined,
      title: "Complete the Job",
      description:
          "Once a customer accepts, everything stays in-app: chat, video calls, job updates and payments. No chasing, no confusion.",
      color: Colors.purple,
      details: [
        "In-app chat and video call features",
        "Keep everything in one place",
        "Receive automated invoices",
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
