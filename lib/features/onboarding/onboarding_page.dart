import 'package:flutter/material.dart';
import 'package:fuel_finder/core/themes/app_palette.dart';
import 'package:fuel_finder/features/auth/presentation/pages/register_page.dart';
import 'package:fuel_finder/features/onboarding/widgets/onboarding_button..dart';
import 'package:fuel_finder/features/onboarding/widgets/top_curve_painter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  bool onLastPage = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenHeight < 600;

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _controller,
                    onPageChanged: (index) {
                      setState(() {
                        onLastPage = index == 2;
                      });
                    },
                    children: [
                      _buildOnboardingPage(
                        context,
                        'assets/images/onboarding_one.png',
                        "Find Nearby Fuel Stations",
                        "Discover fuel stations near you using only your phone",
                        isSmallScreen,
                      ),
                      _buildOnboardingPage(
                        context,
                        'assets/images/onboarding_two.png',
                        "View Fuel Availabilty",
                        "Check real-time fuel availabilty before you go to the station",
                        isSmallScreen,
                      ),
                      _buildOnboardingPage(
                        context,
                        'assets/images/onboarding_three.png',
                        "View Official Fuel Prices",
                        "Stay informed with up-to-date fuel prices across all stations",
                        isSmallScreen,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                    vertical: isSmallScreen ? 10 : 20,
                  ),
                  child: Column(
                    children: [
                      SmoothPageIndicator(
                        controller: _controller,
                        count: 3,
                        effect: ExpandingDotsEffect(
                          dotHeight: 8,
                          dotWidth: 8,
                          activeDotColor: AppPallete.primaryColor,
                          expansionFactor: 3,
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 15 : 25),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder:
                            (child, animation) =>
                                ScaleTransition(scale: animation, child: child),
                        child:
                            onLastPage
                                ? OnboardingButton(
                                  key: const ValueKey('get_started'),
                                  text: "Get Started",
                                  isPrimary: true,
                                  width: double.infinity,
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder:
                                            (context) => const RegisterPage(),
                                      ),
                                    );
                                  },
                                )
                                : Row(
                                  key: const ValueKey('navigation_buttons'),
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    OnboardingButton(
                                      text: "Skip",
                                      isPrimary: false,
                                      isShade: true,
                                      width: screenWidth * 0.4,
                                      onPressed: () {
                                        _controller.jumpToPage(2);
                                      },
                                    ),
                                    OnboardingButton(
                                      text: "Continue",
                                      width: screenWidth * 0.4,
                                      isPrimary: true,

                                      onPressed: () {
                                        _controller.nextPage(
                                          duration: const Duration(
                                            milliseconds: 200,
                                          ),
                                          curve: Curves.easeInOut,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingPage(
    BuildContext context,
    String imagePath,
    String title,
    String description,
    bool isSmallScreen,
  ) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        CustomPaint(
          painter: TopCurvePainter(color: AppPallete.primaryColor),
          child: SizedBox(
            height: screenHeight * 0.55,
            width: double.infinity,
            child: Center(
              child: Image.asset(
                imagePath,
                height: screenHeight * 0.35,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: isSmallScreen ? 24 : 30,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                description,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: isSmallScreen ? 16 : 18,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

