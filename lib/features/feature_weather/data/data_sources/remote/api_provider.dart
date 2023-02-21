import 'package:dio/dio.dart';
import 'package:weather_app/core/utils/constant.dart';

class ApiProvider{
  final Dio _dio = Dio();

  var apiKey = Constant.apiKey1;

 Future<dynamic> callCurrentWeather(cityName) async{
    var response = await _dio.get(
      '${Constant.baseUrl}/data/2.5/weather',
      queryParameters: {
        'q' : cityName,
        'appid' : apiKey,
        'units' : 'metric'
      }
    );
    print(response.data);
    return response;
  }
}