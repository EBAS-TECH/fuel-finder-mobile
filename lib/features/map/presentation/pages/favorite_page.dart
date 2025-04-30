import 'package:flutter/material.dart';
import 'package:fuel_finder/core/themes/app_palette.dart';
import 'package:fuel_finder/features/map/presentation/widgets/custom_app_bar.dart';
import 'package:fuel_finder/shimmer/favorites_shimmer.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final List<Map<String, dynamic>> _favorites = [{}, {}];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(title: "Favorites", centerTitle: true),
      body:
          _favorites.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/no_fav.png"),
                    Text(
                      "No Favorites yet",
                      style: theme.textTheme.headlineLarge?.copyWith(
                        color: AppPallete.primaryColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Text(
                        "Tap the heart icon on a gas station to favorite it",
                        style: theme.textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                // padding: EdgeInsets.all(16),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return FavoritesShimmer();
                },
              ),
      /*  ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _favorites.length,
                itemBuilder: (context, index) {
                  final item = _favorites[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const Icon(
                        Icons.local_gas_station,
                        color: AppPallete.primaryColor,
                      ),
                      title: Text(item['name'] ?? 'Gas Station'),
                      subtitle: Text(item['address'] ?? 'Address'),
                      trailing: IconButton(
                        icon: Icon(Icons.favorite, color: AppPallete.redColor),
                        onPressed: () {
                          setState(() {
                            _favorites.removeAt(index);
                          });
                        },
                      ),
                    ),
                  );
                },
              ) */
    );
  }
}

