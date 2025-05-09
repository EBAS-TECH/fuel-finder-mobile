import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuel_finder/core/utils/exception_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fuel_finder/core/exceptions/app_exceptions.dart';

abstract class GeolocationEvent {}

class FetchUserLocation extends GeolocationEvent {}

abstract class GeolocationState {}

class GeolocationInitial extends GeolocationState {}

class GeolocationLoading extends GeolocationState {}

class GeolocationLoaded extends GeolocationState {
  final double latitude;
  final double longitude;

  GeolocationLoaded({required this.latitude, required this.longitude});
}

class GeolocationError extends GeolocationState {
  final String message;

  GeolocationError({required this.message});
}

class GeolocationBloc extends Bloc<GeolocationEvent, GeolocationState> {
  GeolocationBloc() : super(GeolocationInitial()) {
    on<FetchUserLocation>((event, emit) async {
      emit(GeolocationLoading());
      try {
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          throw SocketException(message: 'Location services are disabled');
        }

        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            throw UnAuthorizedException(
              message: 'Location permissions are denied',
            );
          }
        }

        if (permission == LocationPermission.deniedForever) {
          throw UnAuthorizedException(
            message:
                'Location permissions are permanently denied, we cannot request permissions',
          );
        }
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
        ).timeout(const Duration(seconds: 30));

        emit(
          GeolocationLoaded(
            latitude: position.latitude,
            longitude: position.longitude,
          ),
        );
      } catch (e) {
        final appException = ExceptionHandler.handleError(e);
        print(appException.message);
        emit(GeolocationError(message: appException.message));
      }
    });
  }
}

