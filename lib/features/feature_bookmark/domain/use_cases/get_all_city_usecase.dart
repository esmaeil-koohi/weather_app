import 'package:weather_app/core/resources/data_state.dart';
import 'package:weather_app/core/usecase/use_case.dart';
import 'package:weather_app/features/feature_bookmark/domain/repository/city_repository.dart';

import '../entity/city_entity.dart';

class GetAllCityUseCase extends UseCase<DataState<List<City>>, String>{
  final CityRepository _cityRepository;
  GetAllCityUseCase(this._cityRepository);

  @override
  Future<DataState<List<City>>> call(String param) {
    return _cityRepository.getAllCityFromDB();
  }

}
