import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mimeai/detected.dart';
import 'package:mimeai/healthy.dart';
import 'package:mimeai/services/api.dart';
import 'package:mimeai/widgets.dart';
import 'dart:io';

class Analyzing extends StatefulWidget {
  Analyzing({this.imagePath, this.base64Image});

  final imagePath;
  final base64Image;
  @override
  _AnalyzingState createState() => _AnalyzingState();
}

class _AnalyzingState extends State<Analyzing> {
  String _predictionLink = "";
  String _disease = "";
  bool _requesting = false;
  bool _error = false;

  @override
  void initState() {
    setState(() => _requesting = false);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final value = 0.5;
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(32, 70, 32, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              mimeai,
              SizedBox(
                height: 48,
              ),
              Container(
                height: screenSize.width - 64,
                width: screenSize.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(
                    File(widget.imagePath),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Text(
                'Please wait, while we analyze the image',
                style: GoogleFonts.manrope(
                  color: Color(0xFF27201D),
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: 24,
              ),
              _requesting ? Text(
                'Analyzing',
                style: GoogleFonts.manrope(
                  color: Color(0xFF27201D),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ): Container(),
              SizedBox(
                height: 8,
              ),
              _requesting ?
              LinearProgressIndicator(
                  backgroundColor: Color(0xFFB4B4B4),
                  valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF437344))
              ):
              Center(
                child: RaisedButton(
                  textColor: Color(0xFF437344),
                  color: Color.fromRGBO(223, 237, 223, 0.5),
                  elevation: 0,
                  child: Text(
                    'Start Analysis',
                    style: GoogleFonts.manrope(fontSize: 18),
                  ),
                  padding: EdgeInsets.fromLTRB(24, 16, 24, 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onPressed: () async {
                    try {
                      ApiRequests apiRequests = new ApiRequests();
                      setState(() =>_requesting = true);

//                      setState(() => _requesting = false);
                      final prediction =
                      await apiRequests.getPrediction(
                          widget.imagePath, widget.base64Image);
                      setState(() => _requesting = false);
                      print(prediction);
                      if (prediction['success']) {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
//                              return Healthy(predictionLink: prediction['image_path']);
                              if (prediction['disease'] != 'healthy') {
                                return Detected(
                                  imagePath: widget.imagePath,
                                  accuracy: prediction['accuracy'],
                                  description: prediction['description'],
                                  disease: prediction['disease'],
                                );
                              } else {
                                return Healthy(imagePath: widget.imagePath, predictionLink: prediction['image_path']);
                              }
                            }));
                        print(_disease);
                        // take user to detected/healthy screen
                      } else {
                        // show error
                      }
                      setState(() => _requesting = false);
                    } on Exception catch (error) {
                      print(error);
                    }
                  },
                ),
              ),
              SizedBox(
                height: 16,
              ),
              _requesting ? RichText(
                text: TextSpan(
                  text: '',
                  style: GoogleFonts.manrope(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  children: [
                    TextSpan(
                      text: 'This shouldn\'t take too long',
                      style: GoogleFonts.manrope(fontWeight: FontWeight.normal),
                    )
                  ],
                ),
              ): Container(),
              SizedBox(
                height: 28,
              ),
              _error ? ErrorContainer() : Container(),
              SizedBox(
                height: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    setState(() => _requesting = false);
  }
}
