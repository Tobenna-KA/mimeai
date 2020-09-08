import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";
import 'package:image_picker/image_picker.dart';
import 'package:mimeai/analyzing.dart';
import 'package:mimeai/services/api.dart';
import 'package:mimeai/services/camera_service.dart';
import 'package:share/share.dart';
import 'camera.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();
  final cameraService = new CameraService();
  final firstCamera = await cameraService.availableCamera();

  runApp(
    MaterialApp(
      home: HomeScreen(
        firstCamera: firstCamera,
      ),
    ),
  );
}

class HomeScreen extends StatelessWidget {
  // Obtain a list of the available cameras on the device.
  final firstCamera;

  HomeScreen({Key key, @required this.firstCamera});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xFFFFF7F1),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 30),
          Center(
            child: Container(
              width: 320,
              height: 204,
              child: Text(
                'mimeai can be used to identify diseases in plants  To get started take a picture of the leaf of the affected plant ',
                style: GoogleFonts.nunito(
                  textStyle: GoogleFonts.manrope(fontSize: 24),
                  letterSpacing: 0.03,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: 20),
          Image.asset(
            'assets/Line1.png',
          ),
          SizedBox(height: 40),
          Container(
            width: 70,
            height: 70,
            child: FloatingActionButton(
              backgroundColor: Color(0xFF569557),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TakePictureGeek(
                        camera: firstCamera,
                      ),
                    ));
              },
              child: Icon(
                FeatherIcons.camera,
                size: 35,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text('or'),
          SizedBox(height: 10),
          RaisedButton(
            textColor: Color(0xFF437344),
            color: Color.fromRGBO(223, 237, 223, 0.5),
            elevation: 0,
            child: Text(
              'Upload Picture',
              style: GoogleFonts.manrope(fontSize: 18),
            ),
            padding: EdgeInsets.fromLTRB(24, 16, 24, 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            onPressed: () async {
              var image =
                  await ImagePicker.pickImage(source: ImageSource.gallery);

              File imageFile = new File(image.path);

              // Convert to amazon requirements
              List imageBytes = imageFile.readAsBytesSync();
              String base64Image = base64Encode(imageBytes);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Analyzing(
                          imagePath: image.path,
                          base64Image: base64Image)));
            },
          )
        ],
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  final String base64Image;

  const DisplayPictureScreen({Key key, this.imagePath, this.base64Image})
      : super(key: key);

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

String _predictionLink = "";
String _disease = "";
bool _requesting = false;

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  @override
  void dispose() {
    super.dispose();
    _requesting = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Get Prediction')),
        // The image is stored as a file on the device. Use the `Image.file`
        // constructor with the given path to display the image.
        body: Builder(
            builder: (_context) => Column(
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(6, 0, 6, 20.0),
                        alignment: Alignment.center,
                        child: SizedBox(
                          height: 200,
                          child: Image.file(File(widget.imagePath)),
                        )),
                    Text('Disease Prediction:  $_disease'),
                    SizedBox(
                      height: 20,
                    ),
                    _requesting
                        ? CircularProgressIndicator()
                        : RaisedButton(
                            color: Colors.lightBlue,
                            textColor: Colors.white,
                            onPressed: () async {
                              try {
                                ApiRequests apiRequests = new ApiRequests();
                                setState(() {
                                  _requesting = true;
                                });
                                final prediction =
                                    await apiRequests.getPrediction(
                                        widget.imagePath, widget.base64Image);
                                setState(() => _requesting = false);
                                if (prediction['success']) {
                                  setState(() {
                                    _disease = prediction['disease'];
                                    _predictionLink = prediction['image_path'];
                                  });
                                  print(_disease);
                                  _neverSatisfied(
                                      context, prediction['disease']);
                                } else {
                                  _showMessage(
                                      'Error getting prediction', _context);
                                }
                                setState(() => _requesting = false);
                              } on Exception catch (error) {
                                print(error);
                              }
                            },
                            child: Text('Request Prediction'))
                  ],
                )),
        floatingActionButton: Builder(
            builder: (newContext) => FloatingActionButton(
                  onPressed: () async {
                    if (_predictionLink == "")
                      _showMessage(
                          "No prediction yet, request prediction", newContext);
                    else
                      Share.share(
                          'Hi, please I need pesticide for $_disease, here is a link to the image $_predictionLink',
                          subject: 'Look at my plant disease prediction');
                  },
                  tooltip: 'Share',
                  child: Icon(Icons.share),
                )));
  }
}

void _showMessage(String msg, BuildContext context) {
  final SnackBar snackBar = SnackBar(
    duration: Duration(seconds: 3),
    content: Text(msg),
  );
  Scaffold.of(context).showSnackBar(snackBar);
}

Future<void> _neverSatisfied(BuildContext context, String prediction) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Share prediction'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Hi, your Prediction is ready!!'),
              SizedBox(
                height: 20,
              ),
              Text('Your prediction is: $prediction'),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Yes'),
            onPressed: () {
              Share.share(
                  'Hi, please I need pesticide for $_disease, here is a link to the image $_predictionLink',
                  subject: 'Look at my plant disease prediction');
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
