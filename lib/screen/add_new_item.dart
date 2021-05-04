import 'package:flutter/material.dart';
import 'package:flutter_app/provider/RestaurantsProvider.dart';
import 'package:flutter_app/widgets/textField.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';


class AddItem extends StatefulWidget {
  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String imageUrl;

  File _image;
  var _isLoading = false;
  int numberPlay = 1;

  int count = 0;

  Map<String, String> dateOFMovie = {
    '1': '',
    '2': '',
    '3': '',
    '4': '',
  };

  Map<String, String> _restaurantData = {
    'name': '',
    'location': '',
    'imageUrl': '',
  };
  @override
  Widget build(BuildContext context) {

    Future getImageGallery() async {
      var image = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = File(image.path);
        print('image path $_image');
      });
    }


    Future getImageCamera() async {
      var image = await ImagePicker.platform.pickImage(source: ImageSource.camera);
      setState(() {
        _image = File(image.path);
        print('image path $_image');
      });
    }

    Future uploadPic(BuildContext context) async {
      String fileName = basename(_image.path);
      Reference firebaseStorageRef =
      FirebaseStorage.instance.ref().child('RestaurantPics/$fileName');
      UploadTask uploadTask = firebaseStorageRef.putFile(_image);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
      final url = await snapshot.ref.getDownloadURL();
      setState(() {
        imageUrl = url as String;
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Photo Uploaded"),
        ));
      });
    }

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



    void _onButtonPressed() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              height: 300,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.pinkAccent,
                      ),
                      height: 3,
                      width: 80,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Center(
                      child: Column(
                        children: [
                          Text("Add Image", style: TextStyle(
                              fontFamily: "Montserrat-Bold",
                              fontSize: 20,
                              color: Theme
                                  .of(context)
                                  .textTheme
                                  .headline2
                                  .color
                          ) ,),
                          SizedBox(height: 10,),
                          ListTile(
                            leading: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.sd_storage_rounded,
                                size: 30,
                              ),
                            ),
                            title:Text(
                              "Pick image from device",
                              style: TextStyle(
                                  color: Theme
                                      .of(context)
                                      .textTheme
                                      .headline2
                                      .color,
                                  fontFamily: "Montserrat-Bold",
                                  fontSize: 15
                              ),
                            ),
                            subtitle: Text(
                              "Pick movie poster from your phone storage",
                              style: TextStyle(
                                  color: Theme
                                      .of(context)
                                      .textTheme
                                      .headline2
                                      .color,
                                  fontFamily: "Montserrat-Light",
                                  fontSize: 10
                              ),
                            ),
                            trailing: Icon(
                              Icons.chevron_right,
                              color:
                              Theme.of(context).textTheme.headline2.color,
                              size: 25,
                            ),
                            onTap: getImageGallery,
                          ),
                          ListTile(
                            leading: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.camera_alt,
                                size: 30,
                              ),
                            ),
                            title:Text(
                              "Capture image from camera",
                              style: TextStyle(
                                  color: Theme
                                      .of(context)
                                      .textTheme
                                      .headline2
                                      .color,
                                  fontFamily: "Montserrat-Bold",
                                  fontSize: 15
                              ),
                            ),
                            subtitle: Text(
                              "Pick movie poster using your camera to capture",
                              style: TextStyle(
                                  color: Theme
                                      .of(context)
                                      .textTheme
                                      .headline2
                                      .color,
                                  fontFamily: "Montserrat-Light",
                                  fontSize: 10
                              ),
                            ),
                            trailing: Icon(
                              Icons.chevron_right,
                              color:
                              Theme.of(context).textTheme.headline2.color,
                              size: 25,
                            ),
                            onTap: getImageCamera,
                          )
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            );
          });
    }

    Future restaurantData(BuildContext context) async {
      print(_restaurantData['name']);
      if (!_formKey.currentState.validate()) {
        //invalid
        return;
      }
      _formKey.currentState.save();
      try {
        await Provider.of<Restaurants>(context, listen: false).addRestaurant(
            _restaurantData['name'],
          _restaurantData['location'],
          imageUrl
        );
      } catch (error) {
        const errorMessage =
            'Could not complete. please check your internet connection and try again';
        _showErrorDialod(errorMessage);
      }
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Movie Data Uploaded"),
      ));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor:  Colors.white,
        centerTitle: true,
        title: Text(
          "Add new Restaurant",
          style: TextStyle(
              fontFamily: 'Montserrat-Light',
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.headline2.color),
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
              _image != null
                  ? Center(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.pinkAccent),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: FileImage(
                            _image,
                          ))),
                  height: 200,
                  width: 150,
                ),
              )
                  : Center(
                child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.pinkAccent),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    height: 200,
                    width: 150,
                    child: Icon(
                      Icons.add,
                      size: 80,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 15, left: 12, right: 12, bottom: 15),
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: Colors.transparent,
                          width: 1,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(10)),
                  color: Colors.pinkAccent,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Add Image",
                          style: TextStyle(
                              fontFamily: "Montserrat-Light",
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color:
                              Theme.of(context).textTheme.headline2.color),
                        ),
                        Icon(
                          Icons.add,
                          size: 22,
                          color: Theme.of(context).textTheme.headline2.color,
                        ),
                      ],
                    ),
                  ),
                  onPressed: _onButtonPressed,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Restaurant information",
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
                        return 'Please Enter a Restaurant name';
                      }
                      return null;
                    },
                    onSaved: (input) {
                      _restaurantData['name'] = input;
                      print(_restaurantData['name']);
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter Restaurant name",
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

              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).textTheme.headline6.color),
                  borderRadius: new BorderRadius.circular(10.0),
                ),
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'please Enter Restaurant location';
                      }
                      return null;
                    },
                    onSaved: (input) {
                      _restaurantData['location'] = input;
                      print(_restaurantData['location']);
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter Restaurant location",
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
                      await uploadPic(context);
                      await restaurantData(context);
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
