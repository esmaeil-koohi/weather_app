import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:weather_app/features/feature_weather/domain/entities/forecase_day_entity.dart';



@immutable
abstract class FwStatus extends Equatable {}

/// loading state
class FwLoading extends FwStatus{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

/// loaded state
class FwCompleted extends FwStatus{
  final ForecastDaysEntity forecastDaysEntity;
  FwCompleted(this.forecastDaysEntity);

  @override
  // TODO: implement props
  List<Object?> get props => [forecastDaysEntity];
}

/// error state
class FwError extends FwStatus{
  final String? message;
  FwError(this.message);

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}