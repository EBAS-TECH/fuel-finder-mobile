import 'package:dio/dio.dart';
import 'package:fuel_finder/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:fuel_finder/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:fuel_finder/features/auth/domain/repositories/auth_repository.dart';
import 'package:fuel_finder/features/auth/domain/usecases/logout_usecase.dart';
import 'package:fuel_finder/features/auth/domain/usecases/signin_usecase.dart';
import 'package:fuel_finder/features/auth/domain/usecases/signup_usecase.dart';
import 'package:fuel_finder/features/auth/domain/usecases/verify_email_usecase.dart';
import 'package:fuel_finder/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fuel_finder/features/map/presentation/bloc/geolocation_bloc.dart';
import 'package:fuel_finder/features/route/data/datasources/osrm_data_source.dart';
import 'package:fuel_finder/features/route/data/repositories/route_repository.dart';
import 'package:fuel_finder/features/route/presentation/bloc/route_bloc.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;

void setUpDependencies() {
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSource());
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(authRemoteDataSource: sl<AuthRemoteDataSource>()),
  );
  sl.registerLazySingleton(
    () => SignupUsecase(authRepository: sl<AuthRepository>()),
  );
  sl.registerLazySingleton(
    () => SigninUsecase(authRepository: sl<AuthRepository>()),
  );
  sl.registerLazySingleton(
    () => VerifyEmailUsecase(authRepository: sl<AuthRepository>()),
  );
  sl.registerLazySingleton(
    () => LogoutUsecase(authRepository: sl<AuthRepository>()),
  );
  sl.registerLazySingleton(
    () => AuthBloc(
      signupUsecase: sl<SignupUsecase>(),
      signinUsecase: sl<SigninUsecase>(),
      verifyEmailUsecase: sl<VerifyEmailUsecase>(),
      logoutUsecase: sl<LogoutUsecase>(),
    ),
  );

  sl.registerLazySingleton(() => GeolocationBloc());
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(<RouteRepository>() => OSRMDataSource(sl<Dio>()));
  sl.registerLazySingleton<RouteRepository>(
    () => RouteRepositoryImpl(sl<OSRMDataSource>()),
  );
  sl.registerLazySingleton(() => RouteRepository);
  sl.registerLazySingleton(() => RouteBloc(sl<RouteRepository>()));
}

