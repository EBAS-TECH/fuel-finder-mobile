import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuel_finder/core/utils/exception_handler.dart';
import 'package:fuel_finder/features/favorite/domain/usecases/get_favorite_usecase.dart';
import 'package:fuel_finder/features/favorite/domain/usecases/remove_favorite_usecase.dart';
import 'package:fuel_finder/features/favorite/domain/usecases/set_favorite_usecase.dart';
import 'package:fuel_finder/features/favorite/presentation/bloc/favorite_event.dart';
import 'package:fuel_finder/features/favorite/presentation/bloc/favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final SetFavoriteUsecase setFavoriteUsecase;
  final RemoveFavoriteUsecase removeFavoriteUsecase;
  final GetFavoriteUsecase getFavoriteUsecase;

  FavoriteBloc({
    required this.setFavoriteUsecase,
    required this.removeFavoriteUsecase,
    required this.getFavoriteUsecase,
  }) : super(FavoriteInitial()) {
    on<SetFavoriteEvent>(_onSetFavorite);
    on<RemoveFavoriteEvent>(_onRemoveFavorite);
    on<GetFavoritesEvent>(_onGetFavorites);
  }

  Future<void> _onSetFavorite(
    SetFavoriteEvent event,
    Emitter<FavoriteState> emit,
  ) async {
    emit(FavoriteLoading());
    try {
      await setFavoriteUsecase(event.stationId);
      emit(FavoriteSucess(message: "Set favorite successfully"));
    } catch (e) {
      final errorMessage = ExceptionHandler.getErrorMessage(
        ExceptionHandler.handleError(e),
      );
      emit(FavoriteFailure(error: errorMessage));
    }
  }

  Future<void> _onRemoveFavorite(
    RemoveFavoriteEvent event,
    Emitter<FavoriteState> emit,
  ) async {
    emit(FavoriteLoading());
    try {
      await removeFavoriteUsecase(event.stationId);
      emit(FavoriteSucess(message: "Removed favorite successfully"));
    } catch (e) {
      final errorMessage = ExceptionHandler.getErrorMessage(
        ExceptionHandler.handleError(e),
      );
      emit(FavoriteFailure(error: errorMessage));
    }
  }

  Future<void> _onGetFavorites(
    GetFavoritesEvent event,
    Emitter<FavoriteState> emit,
  ) async {
    emit(FavoriteLoading());
    try {
      final response = await getFavoriteUsecase();
      if (response['data'] == null) {
        emit(FavoriteFailure(error: "Favorite not found"));
      } else {
        emit(
          FetchFavoriteSucess(
            favorites: response,
            message: "Successfully fetched",
          ),
        );
      }
    } catch (e) {
      final errorMessage = ExceptionHandler.getErrorMessage(
        ExceptionHandler.handleError(e),
      );
      emit(FavoriteFailure(error: errorMessage));
    }
  }
}

