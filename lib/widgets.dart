import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Size screenSize;

class LongButton extends StatelessWidget {
  LongButton({this.label, this.onPressed});

  final String label;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: FlatButton(
        padding: EdgeInsets.symmetric(vertical: 10),
        color: Color(0xFF569557),
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.manrope(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class ButtonRow extends StatelessWidget {
  ButtonRow({this.onPressed, this.shareOnPressed});

  final Function onPressed;
  final Function shareOnPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          width: 180,
          height: 50,
          child: FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: Color(0xFFdfeddf),
            onPressed: onPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Learn more',
                  style: GoogleFonts.manrope(
                    color: Color(0xFF437344),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Transform.rotate(
                  angle: -11 / 14,
                  child: Icon(
                    Icons.arrow_forward,
                    size: 21,
                    color: Color(0xFF437344),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 50,
          width: 60,
          decoration: BoxDecoration(
            color: Color(0xFFdfeddf),
            borderRadius: BorderRadius.circular(20),
          ),
          child: IconButton(
            icon: Icon(
                Icons.share,
                color: Color(0xFF437344)
            ),
            onPressed: shareOnPressed,
          ),
        )
      ],
    );
  }
}

Widget mimeai = RichText(
  text: TextSpan(
      text: 'mime',
      style: GoogleFonts.poppins(
        color: Color(0xFF569557),
        fontSize: 21,
        fontWeight: FontWeight.bold,
      ),
      children: [
        TextSpan(
            style: GoogleFonts.poppins(
              color: Color(0xFF437344),
              fontWeight: FontWeight.bold,
            ),
            text: 'ai')
      ]),
);

class ErrorContainer extends StatelessWidget {
  ErrorContainer({this.errorText});

  final String errorText;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      width: screenSize.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xFF816C61),
      ),
      child: Text(
        'Network error, please check your internet  connection.',
        style: GoogleFonts.manrope(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: Colors.white,
        ),
      ),
    );
  }
}
