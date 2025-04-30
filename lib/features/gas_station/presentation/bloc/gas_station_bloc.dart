import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuel_finder/features/gas_station/domain/usecases/get_gas_station_usecase.dart';
import 'package:fuel_finder/features/gas_station/presentation/bloc/gas_station_event.dart';
import 'package:fuel_finder/features/gas_station/presentation/bloc/gas_station_state.dart';

class GasStationBloc extends Bloc<GasStationEvent, GasStationState> {
  final GetGasStationUsecase getGasStationUsecase;

  GasStationBloc({required this.getGasStationUsecase})
    : super(GasStationInitial()) {
    on<GetGasStationsEvent>(_getGasStations);
  }

  Future<void> _getGasStations(
    GetGasStationsEvent event,
    Emitter<GasStationState> emit,
  ) async {
    emit(GasStationLoading());
    try {
      final response = await getGasStationUsecase(event.token);
      if (response["data"] == null) {
        emit(GasStationNull(message: "No gas stations found"));
      } else if (response["data"] != null) {
        emit(
          GasStationSucess(
            message: "Gas stations fetched",
            gasStation: response["data"],
          ),
        );
      }
    } catch (e) {
      emit(GasStationFailure(error: e.toString()));
    }
  }
}

