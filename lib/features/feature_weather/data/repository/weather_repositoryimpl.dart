import 'package:dio/dio.dart';
import 'package:weather_app/core/resources/data_state.dart';
import 'package:weather_app/features/feature_weather/data/data_sources/remote/api_provider.dart';
import 'package:weather_app/features/feature_weather/data/models/current_city_model.dart';
import 'package:weather_app/features/feature_weather/domain/entities/current_city_entity.dart';
import 'package:weather_app/features/feature_weather/domain/repository/weather_repository.dart';

class WeatherRepositoryImpl extends WeatherRepository{
  ApiProvider apiProvider;

  WeatherRepositoryImpl(this.apiProvider);

  @override
  Future<DataState<CurrentCityEntity>> fetchCurrentWeatherData(String cityName) async {
      try{
        Response response = await apiProvider.callCurrentWeather(cityName);
        if(response.statusCode == 200){
          CurrentCityEntity currentCityEntity = CurrentCityModel.fromJson(response.data);
          return DataSuccess(currentCityEntity);
        }else{
          return const DataFailed('something Went Wrong. try again...');
        }
      }catch(e){
        return const DataFailed('Please check your connection...');
      }
  }

}