import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_square1/home_page/bloc/home_page_bloc.dart';
import 'home_page/ui/home_page_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Sample Asignment',
      home: BlocProvider<HomePageBloc>(
        create: (context) =>
            HomePageBloc()..add(HomePageEventType.homePageInitialized),
        child: HomePageView(),
      ),
    );
  }
}
