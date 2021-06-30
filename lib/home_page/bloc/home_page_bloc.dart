import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_square1/home_page/model/home_page_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum HomePageEventType {
  homePageInitialized,
}

abstract class HomePageState {}

class Initial extends HomePageState {}

class Loading extends HomePageState {}

class Success extends HomePageState {}

class Error extends HomePageState {}

class HomePageBloc extends Bloc<HomePageEventType, HomePageState> {
  List<HomePageModel> restaurantsList = [];
  HomePageBloc() : super(Initial());
  @override
  Stream<HomePageState> mapEventToState(HomePageEventType event) async* {
    switch (event) {
      case HomePageEventType.homePageInitialized:
        yield Loading();
        try {
          final response =
              await http.get(Uri.parse('https://bit.ly/caboodle_restaurants'));
          if (response.statusCode == 200) {
            var jsonInfo = jsonDecode(response.body);
            for (var item in jsonInfo['data']) {
              HomePageModel restaurant = HomePageModel.fromJson(item);
              for (var category in item['categories']) {
                restaurant.categories.add(category['name']);
              }
              restaurantsList.add(restaurant);
            }
            yield Success();
            break;
          } else {
            yield Error();
          }
        } catch (e) {
          print('getRestaurants -> $e');
          yield Error();
        }
        break;
    }
  }
}
