import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuel_finder/features/user/domain/usecases/get_user_by_id_usecase.dart';
import 'package:fuel_finder/features/user/presentation/bloc/user_event.dart';
import 'package:fuel_finder/features/user/presentation/bloc/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUserByIdUsecase getUserByIdUsecase;

  UserBloc({required this.getUserByIdUsecase}) : super(UserInitial()) {
    on<GetUserByIdEvent>(_getUserById);
  }

  Future<void> _getUserById(
    GetUserByIdEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      final response = await getUserByIdUsecase(event.userId);
      emit(UserSucess(response, message: "Sucessfully fetched"));
    } catch (e) {
      emit(UserFailure(error: e.toString()));
      throw e.toString();
    }
  }
}

