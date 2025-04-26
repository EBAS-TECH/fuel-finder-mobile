import 'package:flutter/material.dart';
import 'package:fuel_finder/core/themes/app_palette.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppPallete.primaryColor,
        title: Text(
          "Favorites",
          style: theme.textTheme.headlineSmall!.copyWith(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Image.asset("assets/images/no_fav.png")],
      ),
    );
  }
}

