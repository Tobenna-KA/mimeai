import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mimeai/main.dart';
import 'package:mimeai/services/camera_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';
import 'widgets.dart';

class Detected extends StatelessWidget {
  final disease;
  final accuracy;
  final description;
  final imagePath;

  const Detected({Key key, this.disease, this.accuracy, this.description, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    print(description['text'] != null ? description['text'] : '');
    final _descriptionText =  description['text'] != null ? description['text'].toString().substring(0, 120) + '...' : 'No description';
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints.tight(screenSize),
          decoration: BoxDecoration(),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(32, 70, 32, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      mimeai,
                      SizedBox(
                        height: 48,
                      ),
                      Container(
                        height: 80,
                        width: 80,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(
                            File(imagePath),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Text(
                        disease,
                        style: GoogleFonts.manrope(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Divider(
                        color: Color(0xFF27201d).withOpacity(0.5),
                        height: 48,
                      ),
                      RichText(
                        text: TextSpan(
                            text: 'mimeai',
                            style: GoogleFonts.manrope(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                  text: ' believes your plant may have ',
                                  style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.normal,
                                  )),
                              TextSpan(
                                text: disease,
                                style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5),
                              ),
                            ]),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        'DESCRIPTION',
                        style: GoogleFonts.manrope(
                          color: Color(0xFF27201d).withOpacity(0.5),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        _descriptionText,
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      ButtonRow(
                        onPressed: () async {
                          print('here');
                          final url = description['link'] != null ? description['link'] : 'google.com/search?q=$disease' ;
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            _showMessage('Could not launch $url', context);
                          }
                        },
                        shareOnPressed: () {
                          Share.share(
                              'Hi, please I need pesticide for $disease, here is a link to the image $imagePath',
                              subject: 'Look at my plant disease prediction');
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: screenSize.height * 0.19,
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Container(
                  height: 50,
                  margin: EdgeInsets.only(
                      top: 24, bottom: screenSize.height * 0.19 * 0.5),
                  child: LongButton(
                    onPressed: () async {
                      final cameraService = new CameraService();
                      final firstCamera = await cameraService.availableCamera();
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => HomeScreen(firstCamera: firstCamera)
                      ));
                    },
                    label: 'Back to home',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMessage(String msg, BuildContext context) {
    final SnackBar snackBar = SnackBar(
      duration: Duration(seconds: 3),
      content: Text(msg),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
