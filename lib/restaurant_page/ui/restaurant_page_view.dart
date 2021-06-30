import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:test_square1/restaurant_page/bloc/restaurant_page_bloc.dart';
import 'package:test_square1/restaurant_page/model/restaurant_page_model.dart';
import 'package:html/parser.dart';
import 'package:flutter/gestures.dart';

class RestaurantPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    RestaurantPageModel restaurant = context.select(
        (RestaurantPageBloc restaurantPageBloc) =>
            restaurantPageBloc.restaurant);
    return Scaffold(
      body: BlocBuilder<RestaurantPageBloc, RestaurantPageState>(
        builder: (context, state) {
          switch (state.runtimeType) {
            case RestaurantLoading:
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Center(child: CircularProgressIndicator()),
              );
              break;
            case RestaurantSuccess:
              return ListView(children: [
                RestaurantThumb(restaurant: restaurant),
                RestaurantIdent(restaurant: restaurant),
                RestaurantInfo(restaurant: restaurant),
                RestaurantDeliver(restaurant: restaurant)
              ]);
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
    );
  }
}

class RestaurantThumb extends StatelessWidget {
  final RestaurantPageModel restaurant;
  RestaurantThumb({@required this.restaurant});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(5.0), topLeft: Radius.circular(5.0)),
        image: DecorationImage(
          fit: BoxFit.fitWidth,
          image: restaurant.mediaURL == ''
              ? AssetImage('lib/images/image_not_found.png')
              : NetworkImage(restaurant.mediaURL),
        ),
      ),
    );
  }
}

class RestaurantIdent extends StatelessWidget {
  final RestaurantPageModel restaurant;
  RestaurantIdent({@required this.restaurant});
  @override
  Widget build(BuildContext context) {
    bool showExpandDescription = false;
    bool showDescription = context.select(
        (RestaurantPageBloc restaurantPageBloc) =>
            restaurantPageBloc.showDescription);
    String description = _parseHtmlString(restaurant.description);
    if (description.length > 100) {
      showExpandDescription = true;
      description = description.substring(0, 100) + '...';
    }
    return Container(
      padding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 12.0),
      decoration: BoxDecoration(
        color: Color(0xFFF3F3F3),
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 1.0,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            restaurant.name,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          Divider(height: 5.0, color: Colors.transparent),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: showDescription
                      ? _parseHtmlString(restaurant.description)
                      : description,
                  style: TextStyle(fontSize: 11.0, color: Colors.grey),
                ),
                if (showExpandDescription) ...[
                  TextSpan(
                    text: showDescription ? ' see less' : ' see more',
                    style: TextStyle(color: Colors.green, fontSize: 11.0),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        context.read<RestaurantPageBloc>().add(
                            RestaurantPageEventType.showDescriptionPressed);
                      },
                  ),
                ]
              ],
            ),
          ),
          Divider(height: 10.0, color: Colors.transparent),
          restaurant.isOpenNow
              ? Text('Open Now', style: TextStyle(color: Colors.green))
              : Text('Closed', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class RestaurantInfo extends StatelessWidget {
  final RestaurantPageModel restaurant;
  RestaurantInfo({@required this.restaurant});
  @override
  Widget build(BuildContext context) {
    bool showInfo = context.select(
        (RestaurantPageBloc restaurantPageBloc) => restaurantPageBloc.showInfo);
    return Container(
      padding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 0.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Information'),
              GestureDetector(
                onTap: () {
                  context
                      .read<RestaurantPageBloc>()
                      .add(RestaurantPageEventType.showInfoPressed);
                },
                child: Icon(
                  showInfo
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.green,
                  size: 25.0,
                ),
              ),
            ],
          ),
          Divider(height: 12.0, color: Colors.transparent),
          if (showInfo) ...[
            Divider(height: 12.0, color: Colors.transparent),
            Text(restaurant.address,
                style: TextStyle(fontWeight: FontWeight.bold)),
            Divider(height: 12.0, color: Colors.transparent),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (restaurant.phone != '') ...[
                  Divider(height: 12.0, color: Colors.transparent),
                  Text(restaurant.phone,
                      style: TextStyle(color: Colors.green),
                      textAlign: TextAlign.left),
                ],
                if (restaurant.email != '') ...[
                  Divider(height: 12.0, color: Colors.transparent),
                  Text(restaurant.email,
                      style: TextStyle(color: Colors.green),
                      textAlign: TextAlign.left),
                ],
              ],
            )
          ],
        ],
      ),
    );
  }
}

class RestaurantDeliver extends StatelessWidget {
  final RestaurantPageModel restaurant;
  RestaurantDeliver({@required this.restaurant});
  @override
  Widget build(BuildContext context) {
    int maxTime = restaurant.eta + restaurant.etaBuffer;
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: Color(0xFFF3F3F3),
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withOpacity(0.2),
              width: 1.0,
            ),
            top: BorderSide(
              color: Colors.grey.withOpacity(0.2),
              width: 1.0,
            ),
          ),
        ),
        child: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                  text: 'Deliver in ',
                  style: TextStyle(fontSize: 12.0, color: Colors.black)),
              TextSpan(
                  text: ' ${restaurant.eta} - $maxTime min',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black)),
            ],
          ),
        ));
  }
}

String _parseHtmlString(String htmlString) {
  final document = parse(htmlString);
  final String parsedString = parse(document.body.text).documentElement.text;

  return parsedString;
}
