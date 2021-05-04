import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/provider/RestaurantsProvider.dart';
import 'package:flutter_app/screen/addCategoriesPage.dart';
import 'package:flutter_app/widgets/restaurantsListWidget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
//import 'file:///F:/Omar/flutter_app/lib/screen/add_new_item.dart';
import 'add_new_item.dart';
import 'sign_up.dart';

class ListPage extends StatefulWidget {
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {

  Future _restaurantFuture;

  getRestaurant() async {
    return await Provider.of<Restaurants>(context, listen: false).retrieveRestaurants();
  }

  @override
  void initState() {
   setState(() {
     _restaurantFuture = getRestaurant();
   });
    super.initState();
  }

  Future<String> refresh() async {
    setState(() {
      _restaurantFuture = getRestaurant();
    });

    return 'success';
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        elevation: 0.0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(9.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/image/profile.jpg'),
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
                decoration: BoxDecoration(color: Colors.pinkAccent),
                child: Column(children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/image/profile.jpg'),
                  ),
                  Text('username goes here'),
                ])),
            CustomListTile("Add Restaurant", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddItem()),
              );
            }, null),
            CustomListTile("Add Category", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CategoryAdd()),
              );
            }, null),
            CustomListTile("Log out", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUp()),
              );
            }, null),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        color: Colors.black87,
        child: FutureBuilder(
            future: _restaurantFuture,
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding: const EdgeInsets.all(200),
                  child: Center(
                      child: SpinKitCircle(
                    color: Color(0xFFFFCB5F),
                    size: 12,
                  )),
                );
              } else {
                if (dataSnapshot.error != null) {
                  Center(
                    child: Text('An error occured'),
                  );
                } else {
                  return RestaurantsWidget();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 200),
                  child: Center(
                    child: Text(
                     "Check your connection",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "Montserrat-Bold",
                          color: Theme.of(context).textTheme.headline2.color),
                    ),
                  ),
                );
              }
            }),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  String txt;
  Function onTab;
  IconData icn;

  CustomListTile(this.txt, this.onTab, this.icn);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: InkWell(
        splashColor: Colors.lime,
        onTap: onTab,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  txt,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Icon(icn),
            ],
          ),
        ),
      ),
    );
  }
}
