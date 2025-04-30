import 'package:fuel_finder/features/gas_station/domain/repositories/gas_repository.dart';

class GetGasStationUsecase {
  final GasRepository gasRepository;

  GetGasStationUsecase({required this.gasRepository});

  Future<Map<String, dynamic>> call(String token) {
    return gasRepository.getGasStations(token);
  }
}

