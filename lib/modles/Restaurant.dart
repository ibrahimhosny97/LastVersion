import 'package:flutter/material.dart';
import 'menu.dart';

class Restaurant with ChangeNotifier{
  final String id;
  final String name;
  final String location;
  final String imageUrl;

  final List<Menu> menus;

  Restaurant({this.id , this.name, this.imageUrl , this.location , this.menus});
}