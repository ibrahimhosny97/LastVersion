import 'package:flutter/material.dart';
import 'package:flutter_app/provider/CategoryProvider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class CategoryAdd extends StatefulWidget {
  @override
  _CategoryAddState createState() => _CategoryAddState();
}

class _CategoryAddState extends State<CategoryAdd> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
      String category;
      bool _isLoading = false;

    void _showErrorDialod(String message) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error Occured!'),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ));
    }

    Future catData(BuildContext context) async {
      if (!_formKey.currentState.validate()) {
        //invalid
        return;
      }
      _formKey.currentState.save();

      try {
        final Categ = Provider.of<Categories>(context, listen: false);
        Categ.addCategory(category);
      } catch (error) {
        const errorMessage =
            'Could not complete. please check your internet connection and try again';
        _showErrorDialod(errorMessage);
      }
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Movie Data Uploded"),
      ));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Add new category",
          style: TextStyle(
              fontFamily: 'Montserrat-Light',
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.black87),
        ),
        elevation: 0.0,
      ),
      body: Builder(
        builder: (context) => Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(10),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Movie information",
                  style: TextStyle(
                    fontFamily: "Montserrat-Light",
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Theme.of(context).textTheme.headline2.color,
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).textTheme.headline6.color),
                  borderRadius: new BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      fontFamily: "Montserrat-Light",
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Theme.of(context).textTheme.headline2.color,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please Enter a title';
                      }
                      return null;
                    },
                    onSaved: (input) {
                      category = input;
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter Movie Title",
                        hintStyle: TextStyle(
                          fontFamily: "Montserrat-Light",
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.grey,
                        )),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FlatButton(
                    padding: EdgeInsets.all(10),
                    color: Colors.pinkAccent,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.transparent,
                            width: 1,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(10)),
                    child: _isLoading
                        ? Center(
                        child: SpinKitDualRing(
                          size: 20,
                          color: Colors.white,
                        ))
                        : Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Submit",
                            style: TextStyle(
                                fontFamily: 'Montserrat-Light',
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Icon(
                              Icons.done,
                              size: 25,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      await catData(context);
                      setState(() {
                        _isLoading = false;
                      });
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
