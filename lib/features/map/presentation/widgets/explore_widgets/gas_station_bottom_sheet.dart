import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuel_finder/core/themes/app_palette.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fuel_finder/features/gas_station/presentation/bloc/gas_station_bloc.dart';
import 'package:fuel_finder/features/gas_station/presentation/bloc/gas_station_state.dart';
import 'package:fuel_finder/features/gas_station/presentation/bloc/gas_station_event.dart';

class GasStationBottomSheet extends StatefulWidget {
  final List<Map<String, dynamic>> stations;
  final Function(Map<String, dynamic>) onStationTap;
  final double latitude;
  final double longitude;

  const GasStationBottomSheet({
    super.key,
    required this.stations,
    required this.onStationTap,
    required this.latitude,
    required this.longitude,
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
  final List<String> stationImages = [
    "assets/images/station1.png",
    "assets/images/station2.png",
    "assets/images/station3.png",
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchGasStations();
  }

  void _fetchGasStations() {
    context.read<GasStationBloc>().add(
      GetGasStationsEvent(
        latitude: widget.latitude.toString(),
        longitude: widget.longitude.toString(),
      ),
    );
  }

  void _categorizeStations(List<Map<String, dynamic>> stations) {
    _allStations = stations;
    _petrolStations =
        stations.where((station) {
          final fuels = station['available_fuel'] as List<dynamic>? ?? [];
          return fuels.any(
            (fuel) => fuel.toString().toUpperCase().contains('PETROL'),
          );
        }).toList();
    _dieselStations =
        stations.where((station) {
          final fuels = station['available_fuel'] as List<dynamic>? ?? [];
          return fuels.any(
            (fuel) => fuel.toString().toUpperCase().contains('DIESEL'),
          );
        }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<GasStationBloc, GasStationState>(
      listener: (context, state) {
        if (state is GasStationSucess) {
          _categorizeStations(state.gasStation);
        }
      },
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.55,
          decoration: BoxDecoration(
            color: isDarkMode ? theme.cardColor : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Text(
                l10n.nearbyGasStations,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: 10),
              TabBar(
                controller: _tabController,
                labelColor: AppPallete.primaryColor,
                unselectedLabelColor: theme.textTheme.bodyMedium?.color,
                indicatorColor: AppPallete.primaryColor,
                tabs: [
                  Tab(text: l10n.all),
                  Tab(text: l10n.petrol),
                  Tab(text: l10n.diesel),
                ],
              ),
              const SizedBox(height: 5),
              Expanded(child: _buildContent(state, context)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(GasStationState state, BuildContext context) {
    if (state is GasStationLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is GasStationFailure) {
      return Center(child: Text(state.error));
    } else if (state is GasStationNull) {
      return Center(child: Text(state.message));
    } else {
      return TabBarView(
        controller: _tabController,
        children: [
          _buildStationList(context, _allStations, showAllFuels: true),
          _buildStationList(context, _petrolStations, fuelType: 'PETROL'),
          _buildStationList(context, _dieselStations, fuelType: 'DIESEL'),
        ],
      );
    }
  }

  Widget _buildStationList(
    BuildContext context,
    List<Map<String, dynamic>> stations, {
    bool showAllFuels = false,
    String? fuelType,
  }) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    if (stations.isEmpty) {
      return Center(
        child: Text(
          l10n.noStationsFound,
          style: TextStyle(color: theme.textTheme.bodyMedium?.color),
        ),
      );
    }

    return ListView.builder(
      itemCount: stations.length,
      itemBuilder: (context, index) {
        final station = stations[index];
        final isSuggestion = station['suggestion'] == true;
        final fuels = station['available_fuel'] as List<dynamic>? ?? [];
        final displayedFuels =
            showAllFuels
                ? fuels
                : fuels
                    .where(
                      (fuel) => fuel.toString().toUpperCase().contains(
                        fuelType ?? '',
                      ),
                    )
                    .toList();

        final fuelsText = displayedFuels.join(', ');

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            leading: Image(image: NetworkImage(station["logo"])),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    station['name'] ?? 'Gas Station',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                ),
                if (isSuggestion)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 12,
                        color: theme.iconTheme.color,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        l10n.suggested,
                        style: TextStyle(
                          fontSize: 10,
                          color: theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (station['averageRate'] != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: theme.colorScheme.surface,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 14,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '${station['averageRate']}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: theme.textTheme.bodyMedium?.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (station["distance"] != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 14,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${station['distance'].toStringAsFixed(2)} km away',
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.textTheme.bodyMedium?.color,
                              ),
                            ),
                          ],
                        ),
                        if (displayedFuels.isNotEmpty)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.7,
                                ),
                                child: Text(
                                  fuelsText,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: AppPallete.primaryColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                ],
              ),
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

