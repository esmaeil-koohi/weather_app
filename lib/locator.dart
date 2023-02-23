import 'package:get_it/get_it.dart';
import 'package:weather_app/features/feature_weather/data/data_sources/remote/api_provider.dart';
import 'package:weather_app/features/feature_weather/data/repository/weather_repositoryimpl.dart';
import 'package:weather_app/features/feature_weather/domain/repository/weather_repository.dart';
import 'package:weather_app/features/feature_weather/domain/use_cases/get_current_weather_usecase.dart';
import 'package:weather_app/features/feature_weather/presentation/bloc/home_bloc.dart';

GetIt locator = GetIt.instance();

setUp(){
  locator.registerSingleton<ApiProvider>(ApiProvider());

  /// repositories
  locator.registerSingleton<WeatherRepository>(WeatherRepositoryImpl(locator()));

  ///use case
  locator.registerSingleton<GetCurrentWeatherUseCase>(GetCurrentWeatherUseCase(locator()));

  locator.registerSingleton<HomeBloc>(HomeBloc(locator()));
}