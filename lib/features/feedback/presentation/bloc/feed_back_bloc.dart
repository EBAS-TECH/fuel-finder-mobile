import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuel_finder/core/exceptions/app_exceptions.dart';
import 'package:fuel_finder/core/utils/exception_handler.dart';
import 'package:fuel_finder/features/feedback/domain/usecases/create_feed_back_usecase.dart';
import 'package:fuel_finder/features/feedback/domain/usecases/get_feed_back_usecase.dart';
import 'package:fuel_finder/features/feedback/presentation/bloc/feed_back_event.dart';
import 'package:fuel_finder/features/feedback/presentation/bloc/feed_back_state.dart';

class FeedBackBloc extends Bloc<FeedBackEvent, FeedBackState> {
  final CreateFeedBackUsecase createFeedBackUsecase;
  final GetFeedBackUsecase getFeedBackUsecase;

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
      if (event.rating < 1 && event.comment.isEmpty) {
        emit(FeedBackFailure(error: "Please provide a rating or comment"));
        return;
      }

      await createFeedBackUsecase(
        event.stationId,
        event.rating,
        event.comment.trim().isEmpty ? "" : event.comment.trim(),
      );
      final updatedFeedback = await getFeedBackUsecase(event.stationId);
      emit(
        FeedBackSucess(
          message: "Feedback submitted successfully!",
          feedback: updatedFeedback,
        ),
      );
    } catch (e) {
      final exception = ExceptionHandler.handleError(e);
      emit(FeedBackFailure(error: ExceptionHandler.getErrorMessage(exception)));
    }
  }

  Future<void> _onGetFeedback(
    GetFeedBackByStationAndUserEvent event,
    Emitter<FeedBackState> emit,
  ) async {
    emit(FeedBackLoading());
    try {
      final response = await getFeedBackUsecase(event.stationId);
      if (response['data'] == null) {
        emit(
          FeedBackFetchSucess(feedback: response, message: "No feedback found"),
        );
      } else {
        emit(
          FeedBackFetchSucess(
            feedback: response,
            message: "Successfully fetched",
          ),
        );
      }
    } catch (e) {
      final exception = ExceptionHandler.handleError(e);
      if (exception is NotFoundException) {
        emit(
          FeedBackFetchSucess(
            feedback: {'data': null},
            message: "No feedback found",
          ),
        );
      } else {
        emit(
          FeedBackFailure(error: ExceptionHandler.getErrorMessage(exception)),
        );
      }
    }
  }
}

