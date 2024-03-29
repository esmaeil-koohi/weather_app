import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/core/resources/data_state.dart';
import 'package:weather_app/features/feature_weather/domain/entities/current_city_entity.dart';
import 'package:weather_app/features/feature_weather/domain/use_cases/get_current_weather_usecase.dart';
import 'package:weather_app/features/feature_weather/domain/use_cases/get_forecast_weather_usecase.dart';
import 'package:weather_app/features/feature_weather/presentation/bloc/cw_state.dart';
import 'package:weather_app/features/feature_weather/presentation/bloc/fw_status.dart';
import 'package:weather_app/features/feature_weather/presentation/bloc/home_bloc.dart';

import 'home_bloc_test.mocks.dart';

@GenerateMocks([GetCurrentWeatherUseCase, GetForecastWeatherUseCase])
void main(){
  MockGetCurrentWeatherUseCase mockGetCurrentWeatherUseCase = MockGetCurrentWeatherUseCase();
  MockGetForecastWeatherUseCase mockGetForecastWeatherUseCase = MockGetForecastWeatherUseCase();

  String cityName = 'Tehran';
  String error = 'error';
  
  group('cw Event test', () {
    when(mockGetCurrentWeatherUseCase.call(any)).thenAnswer((_) async => Future.value(DataSuccess(CurrentCityEntity())));

    blocTest<HomeBloc, HomeState>(
      'emit loading and completed',
      build: () => HomeBloc(mockGetCurrentWeatherUseCase, mockGetForecastWeatherUseCase),
      act: (bloc) {
        bloc.add(LoadCwEvent(cityName));
      },
      expect: () => <HomeState>[
      HomeState(cwStatus: CwLoading(), fwStatus: FwLoading()),
      HomeState(cwStatus: CwCompleted(CurrentCityEntity()), fwStatus: FwLoading()),
      ],
    );

    //second way
    test('emit loading and Error state', () {
      when(mockGetCurrentWeatherUseCase.call(any)).thenAnswer((realInvocation) async => Future.value(DataFailed(error)));

      final bloc =  HomeBloc(mockGetCurrentWeatherUseCase, mockGetForecastWeatherUseCase);
      bloc.add(LoadCwEvent(cityName));

      expectLater(bloc.stream, emitsInOrder([
        HomeState(cwStatus: CwLoading(), fwStatus: FwLoading()),
        HomeState(cwStatus: CwError(error), fwStatus: FwLoading()),
      ]));

    },);



  },);

  

}

