import 'package:weather_app/core/resources/data_state.dart';
import 'package:weather_app/core/usecase/use_case.dart';
import 'package:weather_app/features/feature_weather/domain/entities/current_city_entity.dart';
import 'package:weather_app/features/feature_weather/domain/repository/weather_repository.dart';

class GetCurrentWeatherUseCase extends UseCase<DataState<CurrentCityEntity>, String>{
  final WeatherRepository _weatherRepository;
  GetCurrentWeatherUseCase(this._weatherRepository);

  @override
  Future<DataState<CurrentCityEntity>> call(String param) {
    return _weatherRepository.fetchCurrentWeatherData(param);
  }

}