import 'package:flutter/material.dart';

class Menu with ChangeNotifier{
  final String meal;
  final String image;
  final String price;

  Menu({this.meal, this.image, this.price});
}