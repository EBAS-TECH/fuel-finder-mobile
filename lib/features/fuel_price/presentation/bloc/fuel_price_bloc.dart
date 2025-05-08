import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuel_finder/core/utils/exception_handler.dart';
import 'package:fuel_finder/features/fuel_price/domain/usecases/get_fuel_price_usecase.dart';
import 'package:fuel_finder/features/fuel_price/presentation/bloc/fuel_price_event.dart';
import 'package:fuel_finder/features/fuel_price/presentation/bloc/fuel_price_state.dart';

class FuelPriceBloc extends Bloc<FuelPriceEvent, FuelPriceState> {
  final GetFuelPriceUsecase getFuelPriceUsecase;

  FuelPriceBloc({required this.getFuelPriceUsecase})
    : super(FuelPriceInitial()) {
    on<GetFuelPricesEvent>(_onFuelPrice);
  }

  Future<void> _onFuelPrice(
    GetFuelPricesEvent event,
    Emitter<FuelPriceState> emit,
  ) async {
    emit(FuelPriceLoading());
    try {
      final response = await getFuelPriceUsecase();
      if (response["data"] == null) {
        emit(FuelPriceFailure(error: "Fuel price not found"));
      } else {
        emit(
          FuelPriceSucess(
            fuelPrices: response,
            message: "Price fetched successfully",
          ),
        );
        debugPrint("Fuel Price Data: ${response["data"]}");
      }
    } catch (e) {
      final exception = ExceptionHandler.handleError(e);
      emit(
        FuelPriceFailure(error: ExceptionHandler.getErrorMessage(exception)),
      );
    }
  }
}

