import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:test_square1/home_page/bloc/home_page_bloc.dart';
import 'package:test_square1/home_page/model/home_page_model.dart';
import 'package:test_square1/restaurant_page/bloc/restaurant_page_bloc.dart';
import 'package:test_square1/restaurant_page/ui/restaurant_page_view.dart';

class HomePageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<HomePageModel> restaurantsList = context
        .select((HomePageBloc homePageBloc) => homePageBloc.restaurantsList);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: BlocBuilder<HomePageBloc, HomePageState>(
          builder: (context, state) {
            switch (state.runtimeType) {
              case Loading:
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Center(child: CircularProgressIndicator()),
                );
                break;
              case Success:
                return ListView(
                  children: restaurantsList
                      .map<Widget>((restaurant) =>
                          RestaurantCard(restaurant: restaurant))
                      .toList(),
                );
                break;
              default:
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Center(child: Text('Something went wrong.')),
                );
                break;
            }
          },
        ),
      ),
    );
  }
}

class RestaurantCard extends StatelessWidget {
  final HomePageModel restaurant;
  RestaurantCard({@required this.restaurant});
  @override
  Widget build(BuildContext context) {
    int maxTime = restaurant.eta + restaurant.etaBuffer;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider<RestaurantPageBloc>(
              create: (context) => RestaurantPageBloc()
                ..add(RestaurantPageEventType.restaurantPageInitialized),
              child: RestaurantPageView(),
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 30.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4.0,
              offset: Offset(0.0, 2.0),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5.0),
                    topLeft: Radius.circular(5.0)),
                image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: restaurant.mediaURL == ''
                      ? AssetImage('lib/images/image_not_found.png')
                      : NetworkImage(restaurant.mediaURL),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(restaurant.name),
                      Text('${restaurant.eta} - $maxTime min'),
                    ],
                  ),
                  if (restaurant.categories.length > 0) ...[
                    Divider(height: 10.0, color: Colors.transparent),
                    Text(restaurant.categories.join(", "),
                        style: TextStyle(fontSize: 10.0)),
                  ],
                  Divider(height: 10.0, color: Colors.transparent),
                  restaurant.isOpenNow
                      ? Text('Open Now', style: TextStyle(color: Colors.green))
                      : Text('Closed', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
