import 'package:flutter/material.dart';
import 'package:flutter_app/modles/menu.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MenuProvider with ChangeNotifier{
  List<Menu> _menus = [];

  List<Menu> get menus {
    return [..._menus];
  }



  Future<void> addMenu(String id , String meal , String image , String price) async {
    final url = 'https://food-delivery-appp-default-rtdb.firebaseio.com/menu.json';

    await http.post(Uri.parse(url),
        body: jsonEncode({
          'id' : id,
         'meal' : meal ,
          'image' : image ,
          'price' : price,
        }));
  }
}