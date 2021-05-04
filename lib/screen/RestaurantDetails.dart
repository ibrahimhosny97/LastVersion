import 'package:flutter/material.dart';
import 'package:flutter_app/provider/RestaurantsProvider.dart';
import 'package:provider/provider.dart';
import '../widgets/textField.dart';

class RestaurantDetails extends StatefulWidget {
  final String id;
  RestaurantDetails(this.id);
  @override
  _RestaurantDetailsState createState() => _RestaurantDetailsState();
}

class _RestaurantDetailsState extends State<RestaurantDetails> {
  @override
  Widget build(BuildContext context) {
    final _restaurant = Provider.of<Restaurants>(context , listen: false).findById(widget.id);

    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: MediaQuery.of(context).size.height/4,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                        _restaurant.imageUrl),
                      fit: BoxFit.cover),
              ),
            ),
          ),

          RaisedButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>TextFieldWidget(widget.id)));
          } , child: Text('add menu'),)
        ],
      ),
    );
  }
}
