import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuel_finder/features/feedback/domain/usecases/create_feed_back_usecase.dart';
import 'package:fuel_finder/features/feedback/domain/usecases/get_feed_back_usecase.dart';
import 'package:fuel_finder/features/feedback/presentation/bloc/feed_back_event.dart';
import 'package:fuel_finder/features/feedback/presentation/bloc/feed_back_state.dart';

class FeedBackBloc extends Bloc<FeedBackEvent, FeedBackState> {
  final CreateFeedBackUsecase createFeedBackUsecase;
  final GetFeedBackUsecase getFeedBackUsecase;

  String _cleanErrorMessage(dynamic error) {
    String message = error.toString();
    if (message.startsWith('Exception: ')) {
      message = message.substring('Exception: '.length);
    }
    return message;
  }

  FeedBackBloc({
    required this.createFeedBackUsecase,
    required this.getFeedBackUsecase,
  }) : super(FeedBackInitial()) {
    on<CreateFeedBackEvent>(_onCreateFeedback);
    on<GetFeedBackByStationAndUserEvent>(_onGetFeedback);
  }
  Future<void> _onCreateFeedback(
    CreateFeedBackEvent event,
    Emitter<FeedBackState> emit,
  ) async {
    emit(FeedBackLoading());
    try {
      await createFeedBackUsecase(event.stationId, event.rating, event.comment);
      emit(FeedBackSucess(message: "Create feedback successfully"));
    } on SocketException {
      emit(FeedBackFailure(error: "No Internet connection"));
    } on FormatException {
      emit(FeedBackFailure(error: "Invalid"));
    } catch (e) {
      emit(FeedBackFailure(error: _cleanErrorMessage(e)));
    }
  }

  Future<void> _onGetFeedback(
    GetFeedBackByStationAndUserEvent event,
    Emitter<FeedBackState> emit,
  ) async {
    emit(FeedBackLoading());
    try {
      final response = await getFeedBackUsecase(event.stationId, event.userId);
      if (response['data'] == null) {
        emit(FeedBackFailure(error: "Favorite not found"));
      } else {
        emit(
          FeedBackFetchSucess(
            feedback: response,
            message: "Successfully fetched",
          ),
        );
      }
    } on SocketException {
      emit(FeedBackFailure(error: "No Internet connection"));
    } on FormatException {
      emit(FeedBackFailure(error: "Invalid"));
    } catch (e) {
      emit(FeedBackFailure(error: _cleanErrorMessage(e)));
    }
  }
}

