import 'package:flutter/material.dart';
import 'package:flutter_app/screen/RestaurantDetails.dart';
import 'package:provider/provider.dart';
import '../provider/RestaurantsProvider.dart';

class RestaurantsWidget extends StatefulWidget {
  @override
  _RestaurantsWidgetState createState() => _RestaurantsWidgetState();
}

class _RestaurantsWidgetState extends State<RestaurantsWidget> {
  @override
  Widget build(BuildContext context) {
    final restaurantsData =
    Provider
        .of<Restaurants>(context, listen: false)
        .restaurant
        .toList();
    print(restaurantsData.length);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery
            .of(context)
            .size
            .height,
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: restaurantsData.length,
            itemBuilder: (context, i) {
              return ChangeNotifierProvider.value(
                value: restaurantsData[i],
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              RestaurantDetails(restaurantsData[i].id)));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        restaurantsData[i].imageUrl),
                                    fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                restaurantsData[i].name,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 22),
                              ),

                              Column(
                                children: [
                                  Container(
                                    width: 170,
                                    child: Text(
                                      restaurantsData[i].location,
                                      maxLines: 2,
                                      style: TextStyle(
                                          color: Theme
                                              .of(context)
                                              .textTheme
                                              .headline6
                                              .color
                                              .withOpacity(0.5),
                                          fontSize: 18),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
