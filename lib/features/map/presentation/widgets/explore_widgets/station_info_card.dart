import 'package:flutter/material.dart';
import 'package:fuel_finder/core/themes/app_palette.dart';

class StationInfoCard extends StatelessWidget {
  final Map<String, dynamic> station;
  final VoidCallback onClose;
  final VoidCallback onShowRoute;
  final VoidCallback onShowDetails;

  const StationInfoCard({
    super.key,
    required this.station,
    required this.onClose,
    required this.onShowRoute,
    required this.onShowDetails,
  });

  @override
  Widget build(BuildContext context) {
    final stationData = station['data'] ?? station;
    final name = stationData['name'] ?? 'Gas Station';
    final averageRate = stationData['averageRate']?.toString() ?? 'Not rated';
    final fuels =
        (stationData['available_fuel'] as List<dynamic>?)?.join(', ') ??
        'No fuel info';
    final distance =
        stationData['distance'] != null
            ? '${(stationData['distance'] as double).toStringAsFixed(1)} km'
            : 'Distance unknown';
    final duration =
        stationData['duration'] != null
            ? '${(stationData['duration'] / 60).toStringAsFixed(0)} min'
            : '';
    final isSuggested = stationData['suggestion'] == true;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onClose,
                child: const Icon(Icons.close, size: 22),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 18),
                  const SizedBox(width: 4),
                  Text(averageRate),
                ],
              ),
              const SizedBox(width: 16),
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.blue, size: 18),
                  const SizedBox(width: 4),
                  Text('$distance $duration'),
                ],
              ),
              if (isSuggested) ...[
                const SizedBox(width: 16),
                Row(
                  children: [
                    const Icon(
                      Icons.thumb_up,
                      color: AppPallete.primaryColor,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    const Text('Suggested'),
                  ],
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.local_gas_station,
                color: Colors.orange,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text('$fuels available'),
            ],
          ),
          const Divider(),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: GestureDetector(
                  onTap: onShowRoute,
                  child: const Row(
                    children: [
                      Icon(
                        Icons.route,
                        color: AppPallete.primaryColor,
                        size: 22,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Show route',
                        style: TextStyle(
                          color: AppPallete.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.chevron_right, color: Colors.grey, size: 22),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: onShowDetails,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.black87, size: 22),
                      SizedBox(width: 12),
                      Text(
                        'More details',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Spacer(),
                      Icon(Icons.chevron_right, color: Colors.grey, size: 22),
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

