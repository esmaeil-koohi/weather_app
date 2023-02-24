import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/features/feature_weather/presentation/bloc/cw_state.dart';
import 'package:weather_app/features/feature_weather/presentation/bloc/home_bloc.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({Key? key}) : super(key: key);

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<HomeBloc>(context).add(LoadCwEvent('Tehran'));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if(state.cwStatus is CwLoading){
            return const Center(child: Text('loading ...'),);
          }
          
          if(state.cwStatus is CwCompleted){
            return const Center(child: Text('completed'),);
          }

          if(state.cwStatus is CwError){
            return const Center(child: Text('error'),);
          }

          return Container(child: const Text('هیچکدام'),);
        }),
      );
  }
}

