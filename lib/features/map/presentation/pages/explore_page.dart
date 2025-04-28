import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fuel_finder/features/map/presentation/bloc/geolocation_bloc.dart';
import 'package:fuel_finder/features/map/presentation/pages/search_page.dart';
import 'package:fuel_finder/features/map/presentation/widgets/track_location_button.dart';
import 'package:fuel_finder/features/route/presentation/bloc/route_bloc.dart';
import 'package:fuel_finder/features/user/presentation/bloc/user_bloc.dart';
import 'package:fuel_finder/features/user/presentation/bloc/user_event.dart';
import 'package:fuel_finder/features/user/presentation/bloc/user_state.dart';
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
    with TickerProviderStateMixin {
  final MapController mapController = MapController();
  FocusScopeNode focusNode = FocusScopeNode();
  List<LatLng> _routePoints = [];
  LatLng? _selectedLocation;
  double? latitude;
  double? longitude;
  bool _showRouteInfo = false;
  double? _distance;
  double? _duration;

  final String _mapTypeUrl =
      'https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}.png?key=MHrVVdsKyXBzKmc1z9Oo';

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

  void _handleMapTap(TapPosition tapPosition, LatLng latLng) {
    setState(() {
      _selectedLocation = latLng;
      _showRouteInfo = false;
      _routePoints = [];
    });
  }

  double getZoomLevel(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width > 1200) return 14.5;
    if (width > 800) return 14.0;
    return 13.5;
  }

  Future<void> _checkLocationPermission() async {
    PermissionStatus status = await Permission.locationWhenInUse.request();

    if (status.isGranted) {
      if (!mounted) return;
      context.read<GeolocationBloc>().add(FetchUserLocation());
    } else if (status.isDenied) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Location permission is required to access your location",
          ),
        ),
      );
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  void _centerMapOnUserLocation() async {
    bool serviceEnabled = await Permission.location.serviceStatus.isEnabled;
    if (!serviceEnabled) {
      if (!mounted) return;
      ShowSnackbar.show(
        context,
        "Location Service is diabaled. Please enable GPS",
      );
    }
    final state = context.read<GeolocationBloc>().state;
    if (state is GeolocationLoaded) {
      mapController.move(
        LatLng(state.latitude, state.longitude),
        getZoomLevel(context),
      );
    } else {
      context.read<GeolocationBloc>().add(FetchUserLocation());
    }
  }

  void _hideRouteInformation() {
    setState(() {
      _showRouteInfo = false;
      _routePoints = [];
      _selectedLocation = null;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    _fetchUserData();
  }

  void _fetchUserData() {
    context.read<UserBloc>().add(GetUserByIdEvent(userId: widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    double zoomLevel = getZoomLevel(context);
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserFailure) {
          ShowSnackbar.show(context, state.error, isError: true);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppPallete.primaryColor,
          title: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserSucess) {
                final user = state.responseData;
                return Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        user["data"]["profile_pic"] ??
                            'https://avatar.iran.liara.run/public/boy?username=user',
                      ),
                      radius: 20,
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Hey There",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Text(
                          "${user["data"]["first_name"]} ${user["data"]["last_name"]}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
              return const Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      'https://avatar.iran.liara.run/public/boy?username=loading',
                    ),
                    radius: 20,
                  ),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hey There",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        "Loading...",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const SearchPage()),
                  );
                },
                icon: const Icon(Icons.search, color: Colors.white),
              ),
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
                  });
                } else if (state is RouteError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              child: BlocBuilder<GeolocationBloc, GeolocationState>(
                builder: (context, state) {
                  LatLng? userLocation;

                  if (state is GeolocationLoaded) {
                    userLocation = LatLng(state.latitude, state.longitude);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (_routePoints.isEmpty) {
                        mapController.move(userLocation!, zoomLevel);
                      }
                    });
                  }

                  return GestureDetector(
                    onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                    child: FlutterMap(
                      mapController: mapController,
                      options: MapOptions(
                        initialCenter:
                            userLocation ?? const LatLng(9.01, 38.75),
                        initialZoom: zoomLevel,
                        maxZoom: 18,
                        minZoom: 8,
                        onTap: _handleMapTap,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: _mapTypeUrl,
                          userAgentPackageName: 'com.example.fuel_finder',
                        ),
                        if (state is GeolocationLoaded)
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: userLocation!,
                                width: 40,
                                height: 40,
                                child: Icon(
                                  Icons.location_on,
                                  color: AppPallete.redColor,
                                  size: 40,
                                ),
                              ),
                            ],
                          ),
                        if (_selectedLocation != null)
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: _selectedLocation!,
                                width: 40,
                                height: 40,
                                child: const Icon(
                                  Icons.location_pin,
                                  color: Colors.blue,
                                  size: 40,
                                ),
                              ),
                            ],
                          ),
                        if (_routePoints.isNotEmpty)
                          PolylineLayer(
                            polylines: [
                              Polyline(
                                points: _routePoints,
                                strokeWidth: 5,
                                color: Colors.blue,
                              ),
                            ],
                          ),
                      ],
                    ),
                  );
                },
              ),
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
                  if (_selectedLocation != null) {
                    _getRoute();
                  }
                },
                child: const Icon(Icons.alt_route),
              ),
            ),
            if (context.read<GeolocationBloc>().state is GeolocationError)
              Positioned(
                top: 20,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: AppPallete.redColor.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Failed to get location. Please try again.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            if (_showRouteInfo && _routePoints.isNotEmpty)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
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
                          const Text(
                            'Route Information',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: _hideRouteInformation,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.directions_car, color: Colors.blue),
                          const SizedBox(width: 10),
                          Text(
                            'Distance: ${(_distance! / 1000).toStringAsFixed(2)} KM',
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.timer, color: Colors.blue),
                          const SizedBox(width: 10),
                          Text(
                            'Duration: ${(_duration! / 60).toStringAsFixed(2)} Minutes',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        bottomNavigationBar: BlocBuilder<GeolocationBloc, GeolocationState>(
          builder: (context, state) {
            final isLoading =
                (state is GeolocationLoading || state is GeolocationInitial);
            return isLoading
                ? AnimatedOpacity(
                  opacity: isLoading ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 800),
                  child: const LinearProgressIndicator(
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppPallete.primaryColor,
                    ),
                  ),
                )
                : const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

