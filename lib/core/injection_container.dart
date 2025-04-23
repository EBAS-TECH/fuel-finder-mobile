import 'package:dio/dio.dart';
import 'package:fuel_finder/features/map/presentation/bloc/geolocation_bloc.dart';
import 'package:fuel_finder/features/route/data/datasources/osrm_data_source.dart';
import 'package:fuel_finder/features/route/data/repositories/route_repository.dart';
import 'package:fuel_finder/features/route/presentation/bloc/route_bloc.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;

void setUpDependencies() {
  sl.registerLazySingleton(() => GeolocationBloc());
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(<RouteRepository>() => OSRMDataSource(sl<Dio>()));
  sl.registerLazySingleton<RouteRepository>(
    () => RouteRepositoryImpl(sl<OSRMDataSource>()),
  );
  sl.registerLazySingleton(() => RouteRepository);
  sl.registerLazySingleton(() => RouteBloc(sl<RouteRepository>()));
}
