import 'package:flutter/material.dart';

const String ALERT_DIALOG_TITLE = "Alert";

const String BASE_URL = "dev.techstreet.in";
const String API_PATH = "/rwa/public/api";
const String URL = "https://dev.techstreet.in/rwa/public/api/";

// const String BASE_URL = "member.avrwanoida.com";
// const String API_PATH = "/api";
// const String URL = "https://member.avrwanoida.com/api/";

final String path = 'assets/images/';

final List<Draw> drawerItems = [
  Draw(title: 'Home'),
  Draw(title: 'Profile'),
  Draw(title: 'Complaints'),
  Draw(title: 'Dues'),
  Draw(title: 'Member search'),
  Draw(title: 'Notice board'),
  Draw(title: 'Documents'),
  Draw(title: "Emergency no."),
  Draw(title: "Change password"),
];

class Draw {
  final String title;
  Draw({this.title});
}
