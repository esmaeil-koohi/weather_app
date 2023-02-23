import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:weather_app/core/resources/data_state.dart';
import 'package:weather_app/features/feature_weather/domain/use_cases/get_current_weather_usecase.dart';
import 'package:weather_app/features/feature_weather/presentation/bloc/cw_state.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetCurrentWeatherUseCase getCurrentWeatherUseCase;
  HomeBloc(this.getCurrentWeatherUseCase) : super(HomeState(cwStatus: CwLoading())) {

    on<LoadCwEvent>((event, emit) async {
      emit(state.copyWith(newCwStatus: CwLoading()));
      DataState dataState = await getCurrentWeatherUseCase(event.cityName);
      if(dataState is DataSuccess){
       emit(state.copyWith(newCwStatus: CwCompleted(dataState.data)));
      }
      if(dataState is DataFailed){
       emit(state.copyWith(newCwStatus: CwError(dataState.error!)));
      }

    });

  }
}
