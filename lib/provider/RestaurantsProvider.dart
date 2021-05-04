import 'package:flutter/material.dart';
import 'package:flutter_app/modles/menu.dart';
import 'package:http/http.dart' as http;
import '../modles/Restaurant.dart';
import 'dart:convert';

class Restaurants with ChangeNotifier {
  List<Restaurant> _restaurant = [];

  List<Restaurant> get restaurant {
    return [..._restaurant];
  }

  Future<void> addRestaurant(
      String name, String location, String imageUrl,) async {
    final url =
        'https://food-delivery-appp-default-rtdb.firebaseio.com/Restaurants.json';
    try {
      await http.post(Uri.parse(url),
          body: jsonEncode({
            'name': name,
            'location': location,
            'imageUrl': imageUrl,
          }));
    } catch (e) {
      throw (e);
    }
  }

  Restaurant findById(String id){
     return _restaurant.firstWhere((element) => element.id == id);
  }

  Future<void> retrieveRestaurants() async {
    final url =
        'https://food-delivery-appp-default-rtdb.firebaseio.com/Restaurants.json';
    try {
      final response = await http.get(Uri.parse(url));
      final allRestaurants = jsonDecode(response.body) as Map<String, dynamic>;
      print(response.body);
      final List<Restaurant> retrievedRestaurant = [];
      allRestaurants.forEach((id, restaurantData) {
        retrievedRestaurant.add(Restaurant(
          id: id,
          name: restaurantData['name'],
          location: restaurantData['location'],
          imageUrl: restaurantData['imageUrl'],
        ));
      });
      _restaurant = retrievedRestaurant.toList();
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
