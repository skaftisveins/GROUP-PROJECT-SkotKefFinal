import 'package:flutter/material.dart';

const LargeTextSize = 28.0;
const MediumTextSize = 24.0;
const BodyTextSize = 20.0;
const ContentTextSize = 18.0;
var noTournament = false;
var noInternet = false;

const String FontNameDefault = 'Roboto';

const Color kBackgroundColor = Color.fromRGBO(201, 209, 233, 1.0);

// Primary Background Color & News-feed Headline Color
const Color kPrimaryColor = Color.fromRGBO(34, 51, 93, 1);
const Color kAccentColor = Color.fromRGBO(91, 103, 132, 1);
const Color kGrayTextColor = Color.fromRGBO(120, 120, 120, 1);
const Color kWhite = Color.fromRGBO(255, 255, 255, 1);
const Color kAmber = Color.fromRGBO(255, 135, 0, 1);

// Dark Mode
final kDarkAppBarTextStyle = TextStyle(
  fontFamily: FontNameDefault,
  fontWeight: FontWeight.w300,
  fontSize: MediumTextSize,
  color: Colors.white,
);

const kDarkScreenTitleTextStyle = TextStyle(
  fontFamily: FontNameDefault,
  fontWeight: FontWeight.bold,
  fontSize: LargeTextSize,
  color: kAmber,
);

const kDarkBody2TextStyle = TextStyle(
  fontFamily: FontNameDefault,
  fontWeight: FontWeight.w300,
  fontSize: MediumTextSize,
);
const kDarkSubTitleTextStyle = TextStyle(
  fontFamily: FontNameDefault,
  fontWeight: FontWeight.w200,
  fontSize: BodyTextSize,
);

const kDarkTitleTextStyle = TextStyle(
  fontFamily: FontNameDefault,
  fontWeight: FontWeight.w300,
  fontSize: MediumTextSize,
  color: kAmber,
);

const kDarkBody1TextStyle = TextStyle(
  fontFamily: FontNameDefault,
  fontWeight: FontWeight.w300,
  fontSize: BodyTextSize,
  color: Colors.white,
);

const kDarkContentTextStyle = TextStyle(
  fontFamily: FontNameDefault,
  fontWeight: FontWeight.w300,
  fontSize: ContentTextSize,
  color: Colors.white,
);

// Light Mode
final kAppBarTextStyle = TextStyle(
    fontFamily: FontNameDefault,
    fontWeight: FontWeight.w300,
    fontSize: MediumTextSize,
    color: kPrimaryColor);

const kScreenTitleTextStyle = TextStyle(
  fontFamily: FontNameDefault,
  fontWeight: FontWeight.bold,
  fontSize: LargeTextSize,
  color: kPrimaryColor,
);

const kBody2TextStyle = TextStyle(
  fontFamily: FontNameDefault,
  fontWeight: FontWeight.w300,
  fontSize: MediumTextSize,
);
const kSubTitleTextStyle = TextStyle(
  fontFamily: FontNameDefault,
  fontWeight: FontWeight.w200,
  fontSize: BodyTextSize,
);

const kTitleTextStyle = TextStyle(
  fontFamily: FontNameDefault,
  fontWeight: FontWeight.w300,
  fontSize: MediumTextSize,
  color: kPrimaryColor,
);

const kBody1TextStyle = TextStyle(
  fontFamily: FontNameDefault,
  fontWeight: FontWeight.w300,
  fontSize: BodyTextSize,
  color: Colors.black,
);

const kContentTextStyle = TextStyle(
  fontFamily: FontNameDefault,
  fontWeight: FontWeight.w300,
  fontSize: ContentTextSize,
  color: Colors.black,
);

const kLinkStyle = TextStyle(
    decoration: TextDecoration.underline,
    fontFamily: FontNameDefault,
    fontWeight: FontWeight.w300,
    fontSize: BodyTextSize,
    color: kAmber);

// Info screen that is displayed if not internet connection is found
class NoInternetWarning extends StatelessWidget {
  const NoInternetWarning({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('No Internet'),
          Icon(
            Icons.warning,
            size: 35,
          ),
        ],
      ),
    );
  }
}
