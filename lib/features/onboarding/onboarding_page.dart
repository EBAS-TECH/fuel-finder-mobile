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

  final List<Map<String, dynamic>> onboardingData = [
    {
      "image": "assets/images/onboarding_one.png",
      "title": "Find Nearby Fuel Stations",
      "subtitle": "Discover fuel stations near you using only your phone",
    },
    {
      "image": "assets/images/onboarding_two.png",
      "title": "View Fuel Availability",
      "subtitle": "Check real-time fuel availability before you go to the station",
    },
    {
      "image": "assets/images/onboarding_three.png",
      "title": "View Official Fuel Price",
      "subtitle": "Stay informed with up-to-date fuel prices across all stations",
    },
  ];

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
      backgroundColor: AppPallete.whiteColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: TopCurvePainter(color: AppPallete.primaryColor),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: onboardingData.length,
                    onPageChanged: (index) {
                      setState(() {
                        onLastPage = index == onboardingData.length - 1;
                      });
                    },
                    itemBuilder: (context, index) {
                      final data = onboardingData[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05,
                          vertical: isSmallScreen ? 10 : 15,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedScale(
                              scale: onLastPage && index == onboardingData.length - 1
                                  ? 1.05
                                  : 1.0,
                              duration: const Duration(milliseconds: 10),
                              child: Hero(
                                tag: 'onboarding-image-$index',
                                child: Image.asset(
                                  data['image'] as String,
                                  height: isSmallScreen 
                                      ? screenHeight * 0.25 
                                      : screenHeight * 0.35,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            SizedBox(height: isSmallScreen ? 15 : 25),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                data['title'] as String,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge
                                    ?.copyWith(
                                      fontSize: isSmallScreen ? 22 : 28,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: isSmallScreen ? 8 : 12),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                data['subtitle'] as String,
                                key: ValueKey(data['subtitle']),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontSize: isSmallScreen ? 14 : 16,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
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
                        count: onboardingData.length,
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
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                        child: onLastPage
                            ? OnboardingButton(
                                text: "Get Started",
                                isPrimary: true,
                                width: double.infinity,
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => const RegisterPage(),
                                    ),
                                  );
                                },
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  OnboardingButton(
                                    text: "Skip",
                                    isPrimary: false,
                                    width: screenWidth * 0.4,
                                    onPressed: () {
                                      _controller.jumpToPage(onboardingData.length - 1);
                                    },
                                  ),
                                  OnboardingButton(
                                    text: "Continue",
                                    width: screenWidth * 0.4,
                                    isPrimary: true,
                                    isIconButton: true,
                                    onPressed: () {
                                      _controller.nextPage(
                                        duration: const Duration(milliseconds: 200),
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
}

