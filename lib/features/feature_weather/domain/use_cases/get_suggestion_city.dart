import 'package:weather_app/core/usecase/use_case.dart';
import 'package:weather_app/features/feature_weather/data/models/suggest_city_model.dart';

import '../repository/weather_repository.dart';

class GetSuggestionCityUseCase implements UseCase<List<Data>, String> {
  final WeatherRepository _weatherRepository;
  GetSuggestionCityUseCase(this._weatherRepository);

  @override
  Future<List<Data>> call(String param) {
    return _weatherRepository.fetchSuggestData(param);
  }

}
