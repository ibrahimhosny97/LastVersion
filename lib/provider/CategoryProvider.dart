import 'package:flutter/material.dart';
import '../modles/Categories.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Categories with ChangeNotifier {
  List<Category> _categories = [];

  List<Category> get categories {
    return [..._categories];
  }



  Future<void> addCategory(String category) async {
    final url = 'https://food-delivery-appp-default-rtdb.firebaseio.com/Categories.json';

    await http.post(Uri.parse(url),
        body: jsonEncode({
          'category' : category
        }));
  }
}