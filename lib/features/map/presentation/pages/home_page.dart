import 'package:flutter/material.dart';
import 'package:fuel_finder/features/map/presentation/pages/explore_page.dart';
import 'package:fuel_finder/features/map/presentation/pages/favorite_page.dart';
import 'package:fuel_finder/features/map/presentation/pages/price_page.dart';
import 'package:fuel_finder/features/map/presentation/pages/profile_page.dart';
import 'package:fuel_finder/features/map/presentation/widgets/bottom_nav_bar.dart';

class HomePage extends StatefulWidget {
  final String userId;
  const HomePage({super.key, required this.userId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  final List<Widget> _pages = [
    ExplorePage(),
    FavoritePage(),
    PricePage(),
    ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      body: IndexedStack(index: currentIndex, children: _pages),
    );
  }
}

