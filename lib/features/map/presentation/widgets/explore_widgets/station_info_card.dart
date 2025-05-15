import 'package:flutter/material.dart';
import 'package:fuel_finder/core/themes/app_palette.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fuel_finder/features/feedback/presentation/pages/station_detail_page.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuel_finder/features/favorite/presentation/bloc/favorite_bloc.dart';
import 'package:fuel_finder/features/favorite/presentation/bloc/favorite_event.dart';

class StationInfoCard extends StatefulWidget {
  final Map<String, dynamic> station;
  final VoidCallback onClose;
  final VoidCallback onShowRoute;
  final double? distance;
  final double? duration;
  final List<LatLng> routePoints;

  const StationInfoCard({
    super.key,
    required this.station,
    required this.onClose,
    required this.onShowRoute,
    this.distance,
    this.duration,
    required this.routePoints,
  });

  static const stationImages = [
    "assets/images/station1.png",
    "assets/images/station2.png",
    "assets/images/station3.png",
  ];

  @override
  State<StationInfoCard> createState() => _StationInfoCardState();
}

class _StationInfoCardState extends State<StationInfoCard> {
  late bool isFavorite;
  @override
  void initState() {
    super.initState();
    isFavorite = widget.station["isFavorite"] == true;
  }

  String _formatDistance(BuildContext context, double? meters) {
    final l10n = AppLocalizations.of(context)!;
    if (meters == null) return l10n.loading;
    if (meters < 1000) return '${meters.toStringAsFixed(0)} m';
    return '${(meters / 1000).toStringAsFixed(1)} km away';
  }

  String _formatDuration(BuildContext context, double? seconds) {
    final l10n = AppLocalizations.of(context)!;
    if (seconds == null) return l10n.loading;
    if (seconds < 60) return '${seconds.toStringAsFixed(0)} sec';
    if (seconds < 3600) return '${(seconds / 60).toStringAsFixed(0)} min';
    return '${(seconds / 3600).toStringAsFixed(1)} hr';
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final stationData = widget.station['data'] ?? widget.station;
    final name = stationData['name'] ?? 'Gas Station';
    final imageIndex =
        (stationData['name']?.hashCode ?? 0).abs() % StationInfoCard.stationImages.length;
    final fuels =
        (stationData['available_fuel'] as List<dynamic>?)?.join(', ') ??
        l10n.noFuelInfo;

    if (widget.routePoints.isNotEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? theme.cardColor : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Image.asset(
                        StationInfoCard.stationImages[imageIndex],
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: widget.onClose,
                  child: Icon(
                    Icons.close,
                    size: 22,
                    color: theme.iconTheme.color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.location_on, color: Colors.red, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      _formatDistance(context, widget.distance),
                      style: TextStyle(
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time_filled,
                      color: AppPallete.primaryColor,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatDuration(context, widget.duration),
                      style: TextStyle(
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.local_gas_station,
                      color: AppPallete.primaryColor,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$fuels ${l10n.available}',
                      style: TextStyle(
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    final stationId = widget.station['id']?.toString();
                    if (stationId != null) {
                      setState(() {
                        isFavorite = !isFavorite;
                      });

                      if (isFavorite) {
                        context.read<FavoriteBloc>().add(
                          SetFavoriteEvent(stationId: stationId),
                        );
                      } else {
                        context.read<FavoriteBloc>().add(
                          RemoveFavoriteEvent(stationId: stationId),
                        );
                      }
                    }
                  },
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : theme.iconTheme.color,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    final averageRate = stationData['averageRate']?.toString() ?? l10n.notRated;
    final isSuggested = stationData['suggestion'] == true;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? theme.cardColor : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    StationInfoCard.stationImages[imageIndex],
                    width: 48,
                    height: 48,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            averageRate,
                            style: TextStyle(
                              color: theme.textTheme.bodyMedium?.color,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              GestureDetector(
                onTap: widget.onClose,
                child: Icon(
                  Icons.close,
                  size: 22,
                  color: theme.iconTheme.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDistance(context, widget.distance),
                    style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.access_time_filled,
                    color: AppPallete.primaryColor,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDuration(context, widget.duration),
                    style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                  ),
                ],
              ),
              if (isSuggested)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.suggested,
                      style: TextStyle(
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              l10n.suggestionTooltip,
                              style: TextStyle(
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            duration: const Duration(seconds: 3),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: theme.colorScheme.surface,
                          ),
                        );
                      },
                      child: Icon(
                        Icons.info_outline,
                        color: theme.iconTheme.color,
                        size: 16,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.local_gas_station,
                color: AppPallete.primaryColor,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                '$fuels ${l10n.available}',
                style: TextStyle(color: theme.textTheme.bodyMedium?.color),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: GestureDetector(
                  onTap: widget.onShowRoute,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.route,
                          color: AppPallete.primaryColor,
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          l10n.showRoute,
                          style: TextStyle(
                            color: AppPallete.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.chevron_right,
                          color: theme.iconTheme.color,
                          size: 22,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => StationDetailPage(
                          station: widget.station,
                          distance: widget.distance,
                          duration: widget.duration,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppPallete.primaryColor,
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          l10n.moreDetails,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppPallete.primaryColor,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.chevron_right,
                          color: theme.iconTheme.color,
                          size: 22,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

