import 'package:flutter/material.dart';
import 'package:fuel_finder/core/themes/app_palette.dart';
import 'package:fuel_finder/features/map/presentation/widgets/custom_app_bar.dart';

class StationDetailPage extends StatefulWidget {
  final Map<String, dynamic> station;
  const StationDetailPage({super.key, required this.station});

  @override
  State<StationDetailPage> createState() => _StationDetailPageState();
}

class _StationDetailPageState extends State<StationDetailPage> {
  @override
  Widget build(BuildContext context) {
    final station = widget.station;
    final stationData = station["data"] ?? station;
    final isSuggestion = stationData['suggestion'] == true;
    final distance = stationData['distance'] as double?;
    final isFavorite = stationData['isFavorite'] == true;
    print("stationData: $stationData");

    return Scaffold(
      appBar: CustomAppBar(title: "Fuel Station Detail", centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          color: Colors.grey.shade50,
          child: ListTile(
            leading: Icon(
              Icons.local_gas_station,
              color: isSuggestion ? AppPallete.primaryColor : Colors.orange,
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(station['name'] ?? 'Gas Station'),
                if (isSuggestion)
                  Row(
                    children: [
                      Icon(Icons.info_outline, size: 10),
                      Text("Suggested", style: TextStyle(fontSize: 10)),
                    ],
                  ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (station['averageRate'] != null)
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey.shade300,
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            Text(' ${station['averageRate']}'),
                          ],
                        ),
                      ),
                      SizedBox(width: 2),

                      if (distance != null && distance >= 0)
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 12,
                            ),
                            Text(
                              '${distance.toStringAsFixed(1)} km away',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      Spacer(),
                      Row(
                        children: [
                          if (station['available_fuel'] != null)
                            Text(
                              '${station['available_fuel'].join(', ')}',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppPallete.primaryColor,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                Icon(
                  Icons.favorite,
                  color: isFavorite ? Colors.red : Colors.grey,
                ),
              ],
            ),
          ),
        ) /* Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (stationData['name'] != null)
              Text(
                stationData['name'],
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            const SizedBox(height: 16),

            if (stationData['address'] != null)
              _buildDetailRow(Icons.location_on, stationData['address']),

            if (stationData['averageRate'] != null)
              _buildDetailRow(
                Icons.star,
                'Rating: ${stationData['averageRate']}',
              ),

            if (stationData['available_fuel'] != null)
              _buildDetailRow(
                Icons.local_gas_station,
                'Available fuels: ${stationData['available_fuel'].join(', ')}',
              ),

            if (stationData['latitude'] != null &&
                stationData['longitude'] != null)
              _buildDetailRow(
                Icons.map,
                'Location: ${stationData['latitude']}, ${stationData['longitude']}',
              ),
          ],
        ), */,
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppPallete.primaryColor),
          const SizedBox(width: 16),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

