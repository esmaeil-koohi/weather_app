import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:weather_app/core/params/forecastParams.dart';
import 'package:weather_app/core/widgets/app_background.dart';
import 'package:weather_app/core/widgets/dot_loading.dart';
import 'package:weather_app/features/feature_weather/data/models/forcast_days_model.dart';
import 'package:weather_app/features/feature_weather/domain/entities/current_city_entity.dart';
import 'package:weather_app/features/feature_weather/domain/entities/forecase_day_entity.dart';
import 'package:weather_app/features/feature_weather/domain/use_cases/get_suggestion_city.dart';
import 'package:weather_app/features/feature_weather/presentation/bloc/cw_state.dart';
import 'package:weather_app/features/feature_weather/presentation/bloc/fw_status.dart';
import 'package:weather_app/features/feature_weather/presentation/bloc/home_bloc.dart';
import 'package:weather_app/features/feature_weather/presentation/widgets/days_weather_view.dart';
import 'package:weather_app/locator.dart';

import '../../../../core/utils/date_converter.dart';
import '../../../feature_bookmark/presentation/bloc/bookmark_bloc.dart';
import '../../data/models/suggest_city_model.dart';
import '../widgets/bookmark_icon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController textEditingController = TextEditingController();
  GetSuggestionCityUseCase getSuggestionCityUseCase = GetSuggestionCityUseCase(locator());
  String cityName = 'Tehran';
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<HomeBloc>(context).add(LoadCwEvent(cityName));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: height * 0.02,),
          Padding(padding: EdgeInsets.symmetric(horizontal: width * 0.03)),
          Row(
            children: [
            Expanded(child: TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                onSubmitted: (String prefix) {
                  textEditingController.text = prefix;
                  BlocProvider.of<HomeBloc>(context)
                      .add(LoadCwEvent(prefix));
                },
                controller: textEditingController,
                style: DefaultTextStyle.of(context).style.copyWith(
                  fontSize: 20,
                  color: Colors.white,
                ),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  hintText: "Enter a City...",
                  hintStyle: TextStyle(color: Colors.white),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),),
              suggestionsCallback: (String prefix) {
                return getSuggestionCityUseCase(prefix);
              },
              itemBuilder: (context, Data model) {
                return ListTile(
                  leading:  const Icon(Icons.location_on),
                  title: Text(model.name!),
                  subtitle: Text("${model.region}, ${model.country}"),
                );
              },
              onSuggestionSelected:(Data model) {
                textEditingController.text = model.name!;
                BlocProvider.of<HomeBloc>(context).add(LoadCwEvent(model.name!));
              }, ), ),
            const SizedBox(width: 10,),
              BlocBuilder<HomeBloc, HomeState>(
                  buildWhen: (previous, current){
                    if(previous.cwStatus == current.cwStatus){
                      return false;
                    }
                    return true;
                  },
                  builder: (context, state){
                    /// show Loading State for Cw
                    if (state.cwStatus is CwLoading) {
                      return const CircularProgressIndicator();
                    }

                    /// show Error State for Cw
                    if (state.cwStatus is CwError) {
                      return IconButton(
                        onPressed: (){
                          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          //   content: Text("please load a city!"),
                          //   behavior: SnackBarBehavior.floating, // Add this line
                          // ));
                        },
                        icon: const Icon(Icons.error,color: Colors.white,size: 35),);
                    }

                    if(state.cwStatus is CwCompleted){
                      final CwCompleted cwComplete = state.cwStatus as CwCompleted;
                      BlocProvider.of<BookmarkBloc>(context).add(GetCityByNameEvent(cwComplete.currentCityEntity.name!));
                      return BookMarkIcon(name: cwComplete.currentCityEntity.name!);
                    }

                    return Container();

                  }
              ),
          ],),


          BlocBuilder<HomeBloc, HomeState>(
            buildWhen: (previous, current) {
              if(previous.cwStatus == current.cwStatus){
                return false;
              }
              return true;
            },
            builder: (context, state) {
              if (state.cwStatus is CwLoading) {
                return const Expanded(child: DotLoadingWidget());
              }
              if (state.cwStatus is CwCompleted) {
                final CwCompleted cwCompleted = state.cwStatus as CwCompleted;
                final CurrentCityEntity currentCityEntity = cwCompleted.currentCityEntity;
                final ForecastParams forecastParams = ForecastParams (currentCityEntity.coord!.lat!, currentCityEntity.coord!.lon!);
                BlocProvider.of<HomeBloc>(context).add(LoadFwEvent(forecastParams));
                final sunrise = DateConverter.changeDtToDateTimeHour(currentCityEntity.sys!.sunrise,currentCityEntity.timezone);
                final sunset =  DateConverter.changeDtToDateTimeHour(currentCityEntity.sys!.sunset,currentCityEntity.timezone);
                return Expanded(
                    child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: height * 0.02),
                      child: SizedBox(
                        width: width,
                        height: 400,
                        child: PageView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          allowImplicitScrolling: true,
                          controller: _pageController,
                          itemCount: 2,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 50),
                                    child: Text(
                                      currentCityEntity.name!,
                                      style: TextStyle(
                                          fontSize: 30, color: Colors.white),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 20),
                                    child: Text(
                                      currentCityEntity
                                          .weather![0].description!,
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.grey),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 20),
                                    child: AppBackground.setIconForMain(
                                      currentCityEntity
                                          .weather![0].description!,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 20),
                                    child: Text(
                                      '${currentCityEntity.main!.temp!.round()}\u00B0',
                                      style: TextStyle(
                                          fontSize: 50, color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          const Text(
                                            'max',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            '${currentCityEntity.main!.tempMax!.round()}\u00b0',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          right: 10,
                                          left: 10,
                                        ),
                                        child: Container(
                                          width: 2,
                                          height: 40,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          const Text(
                                            'min',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            '${currentCityEntity.main!.tempMin!.round()}\u00b0',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              );
                            } else {
                              return Container(
                                color: Colors.amber,
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: SmoothPageIndicator(
                        controller: _pageController,
                        count: 2,
                        effect: const ExpandingDotsEffect(
                          dotWidth: 10,
                          dotHeight: 10,
                          spacing: 5,
                          activeDotColor: Colors.white,
                        ),
                        onDotClicked: (index) => _pageController.animateToPage(
                          index,
                          duration: const Duration(microseconds: 500),
                          curve: Curves.bounceOut,
                        ),
                      ),
                    ),

                    /// divider
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Container(
                        color: Colors.white24,
                        height: 2,
                        width: double.infinity,
                      ),
                    ),

                    /// forecast weather for 7 days
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: SizedBox(
                        width: double.infinity,
                        height: 100,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Center(
                            child: BlocBuilder<HomeBloc, HomeState>(
                              builder: (BuildContext context, state) {

                                /// show Loading State for Fw
                                if (state.fwStatus is FwLoading) {
                                  return const DotLoadingWidget();
                                }

                                /// show Completed State for Fw
                                if (state.fwStatus is FwCompleted) {
                                  /// casting
                                  final FwCompleted fwCompleted = state.fwStatus as FwCompleted;
                                  final ForecastDaysEntity forecastDaysEntity = fwCompleted.forecastDaysEntity;
                                  final List<Daily> mainDaily = forecastDaysEntity.daily!;

                                  return ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 8,
                                    itemBuilder: (BuildContext context,
                                        int index,) {
                                      return DaysWeatherView(
                                        daily: mainDaily[index],);
                                    },);
                                }

                                /// show Error State for Fw
                                if (state.fwStatus is FwError) {
                                  final FwError fwError = state.fwStatus as FwError;
                                  return Center(
                                    child: Text(fwError.message!),
                                  );
                                }

                                /// show Default State for Fw
                                return Container();
                              },
                            ),
                          ),
                        ),
                      ),
                    ),

                    /// divider
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Container(
                        color: Colors.white24,
                        height: 2,
                        width: double.infinity,
                      ),
                    ),

                    const SizedBox(height: 30,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text("wind speed",
                              style: TextStyle(
                                fontSize: height * 0.017, color: Colors.amber,),),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                "${currentCityEntity.wind!.speed!} m/s",
                                style: TextStyle(
                                  fontSize: height * 0.016,
                                  color: Colors.white,),),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Container(
                            color: Colors.white24,
                            height: 30,
                            width: 2,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            children: [
                              Text("sunrise",
                                style: TextStyle(
                                  fontSize: height * 0.017,
                                  color: Colors.amber,),),
                              Padding(
                                padding:
                                const EdgeInsets.only(top: 10.0),
                                child: Text(sunrise,
                                  style: TextStyle(
                                    fontSize: height * 0.016,
                                    color: Colors.white,),),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Container(
                            color: Colors.white24,
                            height: 30,
                            width: 2,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(children: [
                            Text("sunset",
                              style: TextStyle(
                                fontSize: height * 0.017, color: Colors.amber,),),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(sunset,
                                style: TextStyle(
                                  fontSize: height * 0.016,
                                  color: Colors.white,),),
                            ),
                          ],),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Container(
                            color: Colors.white24,
                            height: 30,
                            width: 2,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(children: [
                            Text("humidity",
                              style: TextStyle(
                                fontSize: height * 0.017, color: Colors.amber,),),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                "${currentCityEntity.main!.humidity!}%",
                                style: TextStyle(
                                  fontSize: height * 0.016,
                                  color: Colors.white,),),
                            ),
                          ],),
                        ),
                      ],),

                     const SizedBox(height: 30,),
                  ],
                ));
              }

              if (state.cwStatus is CwError) {
                return const Text('Error');
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
