import 'package:flutter/material.dart';
import 'package:fuel_finder/core/themes/app_palette.dart';
import 'package:fuel_finder/core/themes/text_theme.dart';
import 'package:fuel_finder/features/auth/presentation/pages/register_page.dart';
import 'package:fuel_finder/features/onboarding/widgets/onboarding_button.dart.dart';
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
      "title": "View Fuel Availabilty",
      "subtitle":
          "Check real-time fuel availabilty before you go to the station",
    },
    {
      "image": "assets/images/onboarding_three.png",
      "title": "View Official Fuel Price",
      "subtitle":
          "Stay informed with up-to-date fuel prices across all stations",
    },
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.whiteColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: TopCurvePainter(color: AppPalette.primaryColor),
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
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedScale(
                              scale:
                                  onLastPage &&
                                          index == onboardingData.length - 1
                                      ? 1.05
                                      : 1.0,
                              duration: const Duration(milliseconds: 10),
                              child: Hero(
                                tag: 'onboarding-image-$index',
                                child: Image.asset(
                                  data['image'] as String,
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                            ),
                            Text(
                              data['title'] as String,
                              style: TextThemes.textTheme.titleLarge,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            Text(
                              data['subtitle'] as String,
                              key: ValueKey(data['subtitle']),
                              style: TextThemes.textTheme.bodyLarge,
                              textAlign: TextAlign.center,
                            ),
                            const Spacer(),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Column(
                    children: [
                      SmoothPageIndicator(
                        controller: _controller,
                        count: onboardingData.length,
                        effect: ExpandingDotsEffect(
                          dotHeight: 8,
                          dotWidth: 8,
                          activeDotColor: AppPalette.primaryColor,
                          expansionFactor: 3,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                        child:
                            onLastPage
                                ? OnboardingButton(
                                  text: "Get Started",
                                  isPrimary: true,
                                  width: double.infinity,
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => RegisterPage(),
                                      ),
                                    );
                                  },
                                )
                                : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    OnboardingButton(
                                      text: "Skip",
                                      isPrimary: false,
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.35,
                                      onPressed: () {
                                        _controller.jumpToPage(
                                          onboardingData.length - 1,
                                        );
                                      },
                                    ),
                                    OnboardingButton(
                                      text: "Continue",
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.35,
                                      isPrimary: true,
                                      isIconButton: true,
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
}

