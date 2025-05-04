import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuel_finder/core/themes/app_palette.dart';
import 'package:fuel_finder/features/favorite/presentation/bloc/favorite_bloc.dart';
import 'package:fuel_finder/features/favorite/presentation/bloc/favorite_event.dart';
import 'package:fuel_finder/features/favorite/presentation/bloc/favorite_state.dart';
import 'package:fuel_finder/features/favorite/presentation/widgets/favorites_shimmer.dart';
import 'package:fuel_finder/features/map/presentation/widgets/custom_app_bar.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  void initState() {
    super.initState();
    _fetchFavorites();
  }

  void _fetchFavorites() {
    context.read<FavoriteBloc>().add(GetFavoritesEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: CustomAppBar(title: "Favorites", centerTitle: true),
      body: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {
          if (state is FetchFavoriteSucess) {
            final favorites = state.favorites["data"];
            if (favorites == null) {
              return _buildEmptyFavorite(context);
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final item = favorites[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: const Icon(
                      Icons.local_gas_station,
                      color: AppPallete.primaryColor,
                    ),
                    title: Text(item['en_name'] ?? 'Gas Station'),
                    subtitle: Text(item['address'] ?? 'Address'),
                    trailing: IconButton(
                      icon: Icon(Icons.favorite, color: AppPallete.redColor),
                      onPressed: () {
                        setState(() {
                          favorites.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              },
            );
          } else if (state is FavoriteLoading) {
            return ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return FavoritesShimmer();
              },
            );
          } else if (state is FavoriteFailure) {
            return _buildErrorState(state.error);
          }
          return _buildEmptyFavorite(context);
        },
      ),
    );
  }

  Widget _buildEmptyFavorite(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
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
    );
  }

  Widget _buildErrorState(String error) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error, size: 80, color: Colors.red),
        const SizedBox(height: 16),
        Text(
          "Error loading favorites",
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey[600],
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          error,
          style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        ElevatedButton(onPressed: _fetchFavorites, child: const Text("Retry")),
      ],
    );
  }
}

