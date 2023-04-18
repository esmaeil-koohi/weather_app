import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:weather_app/features/feature_bookmark/data/data_source/local/city_dao.dart';
import 'package:weather_app/features/feature_bookmark/domain/entity/city_entity.dart';

part 'database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [City])
abstract class AppDatabase extends FloorDatabase {
  CityDao get cityDao;
}