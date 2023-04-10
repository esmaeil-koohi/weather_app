import 'package:weather_app/core/resources/data_state.dart';
import 'package:weather_app/core/usecase/use_case.dart';
import 'package:weather_app/features/feature_bookmark/domain/repository/city_repository.dart';

class DeleteCityUseCase extends UseCase<DataState<String>, String>{
  final CityRepository _cityRepository;
  DeleteCityUseCase(this._cityRepository);

  @override
  Future<DataState<String>> call(String param) {
       return _cityRepository.deleteCityByName(param);
  }


}