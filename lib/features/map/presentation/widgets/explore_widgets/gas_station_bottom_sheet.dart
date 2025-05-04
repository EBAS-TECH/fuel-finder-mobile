import 'package:flutter/material.dart';
import 'package:fuel_finder/core/themes/app_palette.dart';

class GasStationBottomSheet extends StatefulWidget {
  final List<Map<String, dynamic>> stations;
  final Function(Map<String, dynamic>) onStationTap;

  const GasStationBottomSheet({
    super.key,
    required this.stations,
    required this.onStationTap,
  });

  @override
  State<GasStationBottomSheet> createState() => _GasStationBottomSheetState();
}

class _GasStationBottomSheetState extends State<GasStationBottomSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> _allStations = [];
  List<Map<String, dynamic>> _petrolStations = [];
  List<Map<String, dynamic>> _dieselStations = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _categorizeStations();
  }

  void _categorizeStations() {
    _allStations = widget.stations;
    _petrolStations =
        widget.stations.where((station) {
          final fuels = station['available_fuel'] as List<dynamic>? ?? [];
          return fuels.any(
            (fuel) => fuel.toString().toUpperCase().contains('PETROL'),
          );
        }).toList();
    _dieselStations =
        widget.stations.where((station) {
          final fuels = station['available_fuel'] as List<dynamic>? ?? [];
          return fuels.any(
            (fuel) => fuel.toString().toUpperCase().contains('DIESEL'),
          );
        }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.55,
      child: Column(
        children: [
          const Text(
            'Nearby Gas Stations',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          TabBar(
            controller: _tabController,
            labelColor: AppPallete.primaryColor,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Petrol'),
              Tab(text: 'Diesel'),
            ],
          ),
          const SizedBox(height: 5),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildStationList(_allStations),
                _buildStationList(_petrolStations),
                _buildStationList(_dieselStations),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStationList(List<Map<String, dynamic>> stations) {
    if (stations.isEmpty) {
      return const Center(child: Text('No stations found'));
    }

    return ListView.builder(
      itemCount: stations.length,
      itemBuilder: (context, index) {
        final station = stations[index];
        final isSuggestion = station['suggestion'] == true;

        return Card(
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
                      const Icon(Icons.info_outline, size: 10),
                      const Text("Suggested", style: TextStyle(fontSize: 10)),
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
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey.shade300,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 16,
                            ),
                            Text(' ${station['averageRate']}'),
                          ],
                        ),
                      ),
                      const Spacer(),
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
              ],
            ),
            onTap: () {
              Navigator.pop(context);
              widget.onStationTap(station);
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

