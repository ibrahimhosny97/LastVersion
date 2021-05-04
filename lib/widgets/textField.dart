import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/provider/menuProvider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class TextFieldWidget extends StatefulWidget {
  final String id ;
  TextFieldWidget(this.id);
  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String meal;
  String image;
  String price;

  String imageUrl;

  File _image;

  Future getImageGallery() async {
    var image =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image.path);
      print('image path $_image');
    });
  }



  @override
  Widget build(BuildContext context) {
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

    Future restaurantData(BuildContext context) async {
      if (!_formKey.currentState.validate()) {
        //invalid
        return;
      }
      _formKey.currentState.save();
      try {
        await Provider.of<MenuProvider>(context, listen: false).addMenu(
          widget.id,
            meal,
          imageUrl,
          price
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
                          Text(
                            "Add Image",
                            style: TextStyle(
                                fontFamily: "Montserrat-Bold",
                                fontSize: 20,
                                color:
                                Theme.of(context).textTheme.headline2.color),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ListTile(
                            leading: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.sd_storage_rounded,
                                size: 30,
                              ),
                            ),
                            title: Text(
                              "Pick image from device",
                              style: TextStyle(
                                  color:
                                  Theme.of(context).textTheme.headline2.color,
                                  fontFamily: "Montserrat-Bold",
                                  fontSize: 15),
                            ),
                            subtitle: Text(
                              "Pick movie poster from your phone storage",
                              style: TextStyle(
                                  color:
                                  Theme.of(context).textTheme.headline2.color,
                                  fontFamily: "Montserrat-Light",
                                  fontSize: 10),
                            ),
                            trailing: Icon(
                              Icons.chevron_right,
                              color: Theme.of(context).textTheme.headline2.color,
                              size: 25,
                            ),
                            onTap: getImageGallery,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
    }
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
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

            Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).textTheme.headline6.color),
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
                    meal = input;
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
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).textTheme.headline6.color),
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
                    price = input;
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
            FlatButton(
                onPressed: _onButtonPressed, child: Text("Upload image")),

            FlatButton(onPressed: () async{
              await uploadPic(context);
              await restaurantData(context);
            }, child: Text("add menu"))
          ],
        ),
      ),
    );
  }
}
