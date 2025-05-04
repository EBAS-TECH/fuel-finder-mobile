class FuelPriceEvent {}

class GetFuelPricesEvent extends FuelPriceEvent {
  final Map<String, dynamic> fuelPrices;

  GetFuelPricesEvent({required this.fuelPrices});
}

