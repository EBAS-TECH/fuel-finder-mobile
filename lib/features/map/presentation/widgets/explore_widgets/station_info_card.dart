import 'package:flutter/material.dart';
import 'package:fuel_finder/core/themes/app_palette.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fuel_finder/features/feedback/presentation/pages/station_detail_page.dart';
import 'package:latlong2/latlong.dart';

class StationInfoCard extends StatelessWidget {
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

  String _formatDistance(BuildContext context, double? meters) {
    final l10n = AppLocalizations.of(context)!;
    if (meters == null) return l10n.loading;
    if (meters < 1000) return '${meters.toStringAsFixed(0)} m';
    return '${(meters / 1000).toStringAsFixed(1)} km';
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
    final stationData = station['data'] ?? station;
    final name = stationData['name'] ?? 'Gas Station';
    final fuels =
        (stationData['available_fuel'] as List<dynamic>?)?.join(', ') ??
        l10n.noFuelInfo;

    if (routePoints.isNotEmpty) {
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
                GestureDetector(
                  onTap: onClose,
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
                      color: AppPallete.primaryColor,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatDistance(context, distance),
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
                      _formatDuration(context, duration),
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
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onClose,
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
                  const Icon(Icons.star, color: Colors.amber, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    averageRate,
                    style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on,
                    color: AppPallete.primaryColor,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDistance(context, distance),
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
                    _formatDuration(context, duration),
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
          const Divider(),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: GestureDetector(
                  onTap: onShowRoute,
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
                          fontWeight: FontWeight.w500,
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
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (context) => StationDetailPage(
                            station: station,
                            distance: distance,
                            duration: duration,
                          ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: theme.iconTheme.color,
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        l10n.moreDetails,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: theme.textTheme.bodyMedium?.color,
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
            ],
          ),
        ],
      ),
    );
  }
}

