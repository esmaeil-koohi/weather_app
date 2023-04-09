import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:weather_app/core/params/forecastParams.dart';
import 'package:weather_app/core/resources/data_state.dart';
import 'package:weather_app/features/feature_weather/domain/use_cases/get_current_weather_usecase.dart';
import 'package:weather_app/features/feature_weather/domain/use_cases/get_forecast_weather_usecase.dart';
import 'package:weather_app/features/feature_weather/presentation/bloc/cw_state.dart';
import 'package:weather_app/features/feature_weather/presentation/bloc/fw_status.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetCurrentWeatherUseCase getCurrentWeatherUseCase;
  final GetForecastWeatherUseCase _getForecastWeatherUseCase;
  HomeBloc(this.getCurrentWeatherUseCase, this._getForecastWeatherUseCase) : super(HomeState(cwStatus: CwLoading(), fwStatus: FwLoading())) {

    on<LoadCwEvent>((event, emit) async {
      emit(state.copyWith(newCwStatus: CwLoading()));
      DataState dataState = await getCurrentWeatherUseCase(event.cityName);
      print(event.cityName.toString());
      if(dataState is DataSuccess){
       emit(state.copyWith(newCwStatus: CwCompleted(dataState.data)));
      }
      if(dataState is DataFailed){
       emit(state.copyWith(newCwStatus: CwError(dataState.error!)));
      }

    });

    /// load 7 days forecast weather for city Event
    on<LoadFwEvent>((event, emit) async {
      emit(state.copyWith(newFwStatus: FwLoading()));
      DataState dataState = await _getForecastWeatherUseCase(event.forecastParams);
      if(dataState is DataSuccess){
      emit(state.copyWith(newFwStatus: FwCompleted(dataState.data)));
      }
      if(state is DataFailed){
        emit(state.copyWith(newFwStatus: FwError(dataState.error)));
      }

    });

  }
}
