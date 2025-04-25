import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fuel_finder/features/map/presentation/bloc/geolocation_bloc.dart';
import 'package:fuel_finder/features/route/presentation/bloc/route_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fuel_finder/core/themes/app_palette.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

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

  void _centerMapOnUserLocation() {
    final state = context.read<GeolocationBloc>().state;
    if (state is GeolocationLoaded) {
      mapController.move(
        LatLng(state.latitude, state.longitude),
        getZoomLevel(context),
      );
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
  }

  @override
  Widget build(BuildContext context) {
    double zoomLevel = getZoomLevel(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppPallete.primaryColor,
        title: Row(
          children: [
            const Icon(Icons.person, color: Colors.white),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Hey There",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  "Bereket Nigussie",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: Icon(Icons.search, color: Colors.white),
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
                      initialCenter: userLocation ?? const LatLng(0, 0),
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
    );
  }
}

class TrackLocationButton extends StatelessWidget {
  final VoidCallback onTap;
  const TrackLocationButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 15, right: 15, top: 20),
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: AppPallete.whiteColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppPallete.greyColor.withOpacity(0.4),
              blurRadius: 5.0,
              spreadRadius: 0.5,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            FontAwesomeIcons.locationCrosshairs,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}

