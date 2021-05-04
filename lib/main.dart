import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/provider/CategoryProvider.dart';
import 'package:flutter_app/provider/RestaurantsProvider.dart';
import 'package:flutter_app/provider/my_provider.dart';
import 'package:flutter_app/screen/add_new_item.dart';
import 'package:flutter_app/screen/login_page.dart';
import 'package:flutter_app/screen/sign_up.dart';
import 'package:flutter_app/screen/welcome_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/provider/my_provider.dart';
import 'modles/Restaurant.dart';
import 'screen/resturant_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MyProvider()),
       ChangeNotifierProvider.value(value: Categories()),
        ChangeNotifierProvider.value(value: Restaurants()),
        ChangeNotifierProvider.value(value: Restaurant())

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'food deleivery app',
        theme: ThemeData(
          primarySwatch: Colors.lightGreen,
        ),
        //home: LoginPage(),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (index, sncpshot) {
              if (sncpshot.hasData) {
                return ListPage();
              }
              return welcomepage();
            }),
      ),
    );
  }
}
