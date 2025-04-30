class GasStationEvent {}

class GetGasStationsEvent extends GasStationEvent {
  final String token;

  GetGasStationsEvent({required this.token});
}

