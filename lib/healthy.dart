import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share/share.dart';
import 'widgets.dart';

class Healthy extends StatelessWidget {
  final predictionLink;
  final imagePath;

  const Healthy({Key key, this.predictionLink, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints.tight(screenSize),
          child: Column(
            children: <Widget>[
              Container(
                child: Expanded(
                  flex: 1,
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
                          'Healthy plant',
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
                                    text:
                                        ' sees nothing wrong with your plant.',
                                    style: GoogleFonts.manrope(
                                      fontWeight: FontWeight.normal,
                                    )),
                                TextSpan(
                                  text:
                                      '\nYou might want to check with an expert on that.',
                                  style: GoogleFonts.manrope(
                                      fontWeight: FontWeight.normal,
                                      letterSpacing: 0.5),
                                ),
                              ]),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        ButtonRow(
                          onPressed: () {},
                          shareOnPressed: () {
                            Share.share(
                                'Hi, can you please that this plant is healthy, here is a link to the image $predictionLink',
                                subject: 'Look at my plant disease prediction');
                          },
                        ),
                      ],
                    ),
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
                    onPressed: () {},
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
}
