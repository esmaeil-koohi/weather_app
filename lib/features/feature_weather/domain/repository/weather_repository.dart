import 'package:weather_app/core/params/forecastParams.dart';
import 'package:weather_app/core/resources/data_state.dart';
import 'package:weather_app/features/feature_weather/data/models/suggest_city_model.dart';
import 'package:weather_app/features/feature_weather/domain/entities/current_city_entity.dart';
import 'package:weather_app/features/feature_weather/domain/entities/forecase_day_entity.dart';

abstract class WeatherRepository{

Future<DataState<CurrentCityEntity>> fetchCurrentWeatherData(String cityName);

Future<DataState<ForecastDaysEntity>> fetchForecastWeatherData(ForecastParams params);

Future<List<Data>> fetchSuggestData(cityName);

}