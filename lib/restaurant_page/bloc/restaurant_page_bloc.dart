import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:test_square1/restaurant_page/model/restaurant_page_model.dart';

enum RestaurantPageEventType {
  restaurantPageInitialized,
  showDescriptionPressed,
  showInfoPressed,
}

abstract class RestaurantPageState {}

class RestaurantInitial extends RestaurantPageState {}

class RestaurantLoading extends RestaurantPageState {}

class RestaurantSuccess extends RestaurantPageState {}

class RestaurantError extends RestaurantPageState {}

class RestaurantPageBloc
    extends Bloc<RestaurantPageEventType, RestaurantPageState> {
  RestaurantPageModel restaurant = RestaurantPageModel();
  bool showInfo = false;
  bool showDescription = false;
  RestaurantPageBloc() : super(RestaurantInitial());
  @override
  Stream<RestaurantPageState> mapEventToState(
      RestaurantPageEventType event) async* {
    switch (event) {
      case RestaurantPageEventType.restaurantPageInitialized:
        yield RestaurantLoading();
        try {
          final response = await http
              .get(Uri.parse('https://bit.ly/caboodle_restaurant_detail'));
          if (response.statusCode == 200) {
            var jsonInfo = jsonDecode(response.body);
            restaurant = RestaurantPageModel.fromJson(jsonInfo['data']);
            yield RestaurantSuccess();
            break;
          } else {
            yield RestaurantError();
          }
        } catch (e) {
          print('getRestaurant -> $e');
          yield RestaurantError();
        }
        break;
      case RestaurantPageEventType.showDescriptionPressed:
        showDescription = !showDescription;
        yield RestaurantSuccess();
        break;
      case RestaurantPageEventType.showInfoPressed:
        showInfo = !showInfo;
        yield RestaurantSuccess();
        break;
    }
  }
}
