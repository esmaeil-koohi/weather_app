import 'package:equatable/equatable.dart';

import '../../domain/entity/city_entity.dart';

abstract class SaveCityStatus extends Equatable{}

class SaveCityInitial extends SaveCityStatus{
  @override
  List<Object?> get props => [];
}

class SaveCityLoading extends SaveCityStatus{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class SaveCityCompeted extends SaveCityStatus{
  final City city;

  SaveCityCompeted(this.city);

  @override
  List<Object?> get props => [city];
}

class SaveCityError extends SaveCityStatus{
  final String message;

  SaveCityError(this.message);

  @override
  List<Object?> get props => [message];

}