import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fuel_finder/features/gas_station/presentation/bloc/gas_station_bloc.dart';
import 'package:fuel_finder/features/gas_station/presentation/bloc/gas_station_event.dart';
import 'package:fuel_finder/features/gas_station/presentation/bloc/gas_station_state.dart';
import 'package:fuel_finder/features/map/presentation/bloc/geolocation_bloc.dart';
import 'package:fuel_finder/features/map/presentation/pages/search_page.dart';
import 'package:fuel_finder/features/map/presentation/pages/station_detail_page.dart';
import 'package:fuel_finder/features/map/presentation/widgets/custom_app_bar.dart';
import 'package:fuel_finder/features/map/presentation/widgets/explore_widgets/explore_build_cards.dart';
import 'package:fuel_finder/features/map/presentation/widgets/explore_widgets/track_location_button.dart';
import 'package:fuel_finder/features/route/presentation/bloc/route_bloc.dart';
import 'package:fuel_finder/features/user/presentation/bloc/user_bloc.dart';
import 'package:fuel_finder/features/user/presentation/bloc/user_event.dart';
import 'package:fuel_finder/shared/show_snackbar.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fuel_finder/core/themes/app_palette.dart';

class ExplorePage extends StatefulWidget {
  final String userId;
  const ExplorePage({super.key, required this.userId});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final MapController mapController = MapController();
  List<LatLng> _routePoints = [];
  LatLng? _selectedLocation;
  double? _distance;
  double? _duration;
  bool _showRouteInfo = false;
  bool _showStationInfo = false;
  Map<String, dynamic>? _selectedStation;
  bool _initialZoomDone = false;

  final String _mapTypeUrl =
      'https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}.png?key=MHrVVdsKyXBzKmc1z9Oo';

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    _fetchUserData();
  }

  void _checkLocationPermission() async {
    PermissionStatus status = await Permission.locationWhenInUse.request();

    if (status.isGranted && mounted) {
      context.read<GeolocationBloc>().add(FetchUserLocation());
    } else if (status.isDenied && mounted) {
      ShowSnackbar.show(
        context,
        "Location permission is required to access your location",
      );
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  void _centerMapOnUserLocation() async {
    final state = context.read<GeolocationBloc>().state;
    if (state is GeolocationLoaded) {
      _zoomToLocation(state.latitude, state.longitude);
      _getGasStations(state.latitude, state.longitude);
    } else {
      context.read<GeolocationBloc>().add(FetchUserLocation());
    }
  }

  void _zoomToLocation(double latitude, double longitude) {
    if (!mounted) return;

    final target = LatLng(latitude, longitude);
    final zoom = getZoomLevel(context);

    final animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    final curveAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );

    final startCenter = mapController.camera.center;
    final startZoom = mapController.camera.zoom;

    animationController.addListener(() {
      if (!mounted) return;
      final progress = curveAnimation.value;
      final newLat =
          startCenter.latitude +
          (target.latitude - startCenter.latitude) * progress;
      final newLng =
          startCenter.longitude +
          (target.longitude - startCenter.longitude) * progress;
      final newZoom = startZoom + (zoom - startZoom) * progress;

      mapController.move(LatLng(newLat, newLng), newZoom);
    });

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.dispose();
      }
    });

    animationController.forward();

    setState(() {
      _initialZoomDone = true;
    });
  }

  void _fetchUserData() {
    context.read<UserBloc>().add(GetUserByIdEvent(userId: widget.userId));
  }

  void _getGasStations(double latitude, double longitude) {
    context.read<GasStationBloc>().add(
      GetGasStationsEvent(
        latitude: latitude.toString(),
        longitude: longitude.toString(),
      ),
    );
  }

  void _getRoute() {
    if (_selectedLocation == null) return;

    final state = context.read<GeolocationBloc>().state;
    if (state is GeolocationLoaded) {
      final userLocation = LatLng(state.latitude, state.longitude);
      context.read<RouteBloc>().add(
        CalculateRoute(
          waypoints: [userLocation, _selectedLocation!],
          profile: 'driving',
          steps: true,
          overview: 'full',
          geometries: 'polyline',
        ),
      );
    }
  }

  void _handleStationTap(Map<String, dynamic> station) {
    setState(() {
      _selectedStation = station;
      _selectedLocation = LatLng(
        double.parse(station['latitude'].toString()),
        double.parse(station['longitude'].toString()),
      );
      _showStationInfo = true;
      _showRouteInfo = false;
    });
  }

  void _hideRouteInformation() {
    setState(() {
      _showRouteInfo = false;
      _showStationInfo = false;
      _routePoints = [];
      _selectedLocation = null;
    });
  }

  double getZoomLevel(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width > 1200) return 14.5;
    if (width > 800) return 14.0;
    return 13.5;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double zoomLevel = getZoomLevel(context);

    return Scaffold(
      appBar: CustomAppBar(
        userId: widget.userId,
        showUserInfo: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SearchPage()),
              );
            },
            icon: const Icon(Icons.search, color: Colors.white),
          ),
        ],
      ),
      body: Stack(
        children: [
          BlocListener<RouteBloc, RouteState>(
            listener: (context, state) {
              if (state is RouteLoaded) {
                setState(() {
                  _routePoints = state.route.coordinates;
                  _distance = state.route.distance;
                  _duration = state.route.duration;
                  _showRouteInfo = true;
                  _showStationInfo = false;
                });
              } else if (state is RouteError) {
                ShowSnackbar.show(context, state.message);
              }
            },
            child: _buildMap(zoomLevel),
          ),
          Positioned(
            bottom: 20,
            right: 15,
            child: TrackLocationButton(onTap: _centerMapOnUserLocation),
          ),
          Positioned(
            bottom: 90,
            right: 25,
            child: FloatingActionButton(
              backgroundColor: AppPallete.primaryColor,
              onPressed: () {
                final state = context.read<GasStationBloc>().state;
                if (state is GasStationSucess) {
                  _showGasStationsBottomSheet(state.gasStation ?? []);
                }
              },
              child: const Icon(Icons.local_gas_station_rounded),
            ),
          ),
          if (_showRouteInfo && _routePoints.isNotEmpty)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildRouteInfoCard(),
            ),
          if (_showStationInfo && _selectedStation != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildStationInfoCard(),
            ),
        ],
      ),
      bottomNavigationBar: BlocBuilder<GeolocationBloc, GeolocationState>(
        builder: (context, state) {
          final isLoading =
              state is GeolocationLoading || state is GeolocationInitial;
          return isLoading
              ? const LinearProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppPallete.primaryColor,
                ),
              )
              : const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildMap(double zoomLevel) {
    return BlocConsumer<GeolocationBloc, GeolocationState>(
      listener: (context, geoState) {
        if (geoState is GeolocationLoaded && !_initialZoomDone) {
          _zoomToLocation(geoState.latitude, geoState.longitude);
          _getGasStations(geoState.latitude, geoState.longitude);
        }
      },
      builder: (context, geoState) {
        final userLocation =
            geoState is GeolocationLoaded
                ? LatLng(geoState.latitude, geoState.longitude)
                : null;

        return BlocBuilder<GasStationBloc, GasStationState>(
          buildWhen: (previous, current) => previous != current,
          builder: (context, gasStationState) {
            final gasStationMarkers = _buildGasStationMarkers(gasStationState);

            return FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: userLocation ?? const LatLng(9.01, 38.75),
                initialZoom: zoomLevel,
                maxZoom: 18,
                minZoom: 3,
              ),
              children: [
                TileLayer(
                  urlTemplate: _mapTypeUrl,
                  userAgentPackageName: 'com.example.fuel_finder',
                ),
                if (userLocation != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: userLocation,
                        width: 40,
                        height: 40,
                        child: Icon(
                          Icons.location_on,
                          color: AppPallete.redColor,
                          size: 40,
                        ),
                      ),
                      ...gasStationMarkers,
                    ],
                  ),
                if (_selectedLocation != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _selectedLocation!,
                        width: 40,
                        height: 40,
                        child: SizedBox(),
                      ),
                    ],
                  ),
                if (_routePoints.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: _routePoints,
                        strokeWidth: 5,
                        color: Colors.blueAccent,
                      ),
                    ],
                  ),
              ],
            );
          },
        );
      },
    );
  }

  List<Marker> _buildGasStationMarkers(GasStationState state) {
    if (state is! GasStationSucess) return [];

    final stations = state.gasStation;
    if (stations == null) return [];

    return stations
        .map((station) {
          final stationData = station["data"] ?? station;
          final lat =
              stationData['latitude'] != null
                  ? double.tryParse(stationData['latitude'].toString())
                  : null;
          final lng =
              stationData['longitude'] != null
                  ? double.tryParse(stationData['longitude'].toString())
                  : null;

          if (lat == null || lng == null) return null;

          return Marker(
            point: LatLng(lat, lng),
            width: 40,
            height: 40,
            child: GestureDetector(
              onTap: () => _handleStationTap(station),
              child: Icon(
                Icons.local_gas_station,
                color:
                    station['suggestion'] == true
                        ? AppPallete.primaryColor
                        : AppPallete.secondaryColor,
                size: 30,
              ),
            ),
          );
        })
        .whereType<Marker>()
        .toList();
  }

  void _showGasStationsBottomSheet(List<Map<String, dynamic>> stations) {
    final geoState = context.read<GeolocationBloc>().state;
    LatLng? userLocation;

    if (geoState is GeolocationLoaded) {
      userLocation = LatLng(geoState.latitude, geoState.longitude);
    }

    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final stationsWithDistance =
            userLocation != null
                ? stations.map((station) {
                  final stationData = station["data"] ?? station;
                  final lat =
                      stationData['latitude'] != null
                          ? double.tryParse(stationData['latitude'].toString())
                          : null;
                  final lng =
                      stationData['longitude'] != null
                          ? double.tryParse(stationData['longitude'].toString())
                          : null;

                  double distance = -1;
                  if (lat != null && lng != null) {
                    distance = calculateDistance(
                      userLocation!.latitude,
                      userLocation!.longitude,
                      lat,
                      lng,
                    );
                  }

                  return {...station, 'distance': distance};
                }).toList()
                : stations;

        return Container(
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.5,
          child: Column(
            children: [
              const Text(
                'Nearby Gas Stations',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: stationsWithDistance.length,
                  itemBuilder: (context, index) {
                    final station = stationsWithDistance[index];
                    final isSuggestion = station['suggestion'] == true;
                    final distance = station['distance'] as double?;

                    return Card(
                      color: Colors.grey.shade50,
                      child: ListTile(
                        leading: Icon(
                          Icons.local_gas_station,
                          color:
                              isSuggestion
                                  ? AppPallete.primaryColor
                                  : Colors.orange,
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(station['name'] ?? 'Gas Station'),
                            if (isSuggestion)
                              Row(
                                children: [
                                  Icon(Icons.info_outline, size: 10),
                                  Text(
                                    "Suggested",
                                    style: TextStyle(fontSize: 10),
                                  ),
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
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.grey.shade300,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 16,
                                        ),
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
                          ],
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          _handleStationTap(station);
                          if (station['latitude'] != null &&
                              station['longitude'] != null) {
                            _animatedMoveToLocation(
                              LatLng(
                                double.parse(station['latitude'].toString()),
                                double.parse(station['longitude'].toString()),
                              ),
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRouteInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader('Route Information'),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.directions_car, color: Colors.blue),
              const SizedBox(width: 10),
              Text('Distance: ${(_distance! / 1000).toStringAsFixed(2)} KM'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.timer, color: Colors.blue),
              const SizedBox(width: 10),
              Text('Duration: ${(_duration! / 60).toStringAsFixed(2)} Minutes'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStationInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(_selectedStation!['name'] ?? 'Gas Station'),
          const SizedBox(height: 10),
          Text(_selectedStation!['address'] ?? 'No address provided'),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _getRoute,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppPallete.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Show Route'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (context) =>
                          StationDetailPage(station: _selectedStation!),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppPallete.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('More'),
          ),
        ],
      ),
    );
  }

  Widget _buildCardHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: _hideRouteInformation,
        ),
      ],
    );
  }

  void _animatedMoveToLocation(LatLng target) {
    if (!mounted) return;

    final zoom = getZoomLevel(context);
    final animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    final curveAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );

    final startCenter = mapController.camera.center;
    final startZoom = mapController.camera.zoom;

    animationController.addListener(() {
      if (!mounted) return;
      final progress = curveAnimation.value;
      final newLat =
          startCenter.latitude +
          (target.latitude - startCenter.latitude) * progress;
      final newLng =
          startCenter.longitude +
          (target.longitude - startCenter.longitude) * progress;
      final newZoom = startZoom + (zoom - startZoom) * progress;

      mapController.move(LatLng(newLat, newLng), newZoom);
    });

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.dispose();
      }
    });

    animationController.forward();
  }

  @override
  bool get wantKeepAlive => true;
}

