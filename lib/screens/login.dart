import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:rwa/components/general.dart';


import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';


class Login extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<Login> {
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();
  bool _isHidden = true;
  bool _autoValidate = false;
  String fcmToken="";
  Stream<String> _tokenStream;
  StreamSubscription iosSubscription;
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance
        .getToken()
        .then(setToken);
    _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
    _tokenStream.listen(setToken);
  }
  void setToken(String token) {
    print('FCM Token: $token');
    setState(() {
      fcmToken = token;
    });
  }
  Widget _loginContent() {
    return Container(

      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 15.0),
          Container(
            margin: const EdgeInsets.only(right: 8.0, left: 8),
            child: TextFormField(
                controller: mobileController,
                // maxLength: 10,
                keyboardType: TextInputType.text,
                cursorColor: Color(0xff000000),
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter HouseId';
                  }
                  return null;
                },
                decoration: InputDecoration(
                   /* prefixIcon: Container(
                      padding: EdgeInsets.all(16),
                      margin: const EdgeInsets.only(right: 8.0),
                      child: Container(
                        width: 16,
                        height: 12,
                        child: Image.asset(
                          'assets/images/person.png',
                        ),
                      ),
                    ),*/
                    isDense: true,
                    contentPadding: EdgeInsets.fromLTRB(10, 30, 30, 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                        color: Color(0xffDFDFDF),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                        color: Color(0xffDFDFDF),
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                        color: Color(0xffDFDFDF),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                        color: Color(0xffDFDFDF),
                      ),
                    ),
                    counterText: "",
                    hintText: 'House Id',
                    hintStyle:
                    TextStyle(color: Colors.black, fontSize: 16),
                    fillColor: Color(0xffffffff),
                    filled: true)),
          ),
          const SizedBox(height: 15.0),
          Container(
            margin: const EdgeInsets.only(right: 8.0, left: 8),
            child: TextFormField(
                obscureText: _isHidden,
                controller: passwordController,
                keyboardType: TextInputType.text,
                cursorColor: Color(0xff000000),
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter password';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          _isHidden = !_isHidden;
                        });
                      },
                      child: Icon(
                          _isHidden ? Icons.visibility_off : Icons.visibility,
                          color: Colors.black87),
                    ),
                   /* prefixIcon: Container(
                      padding: EdgeInsets.all(16),
                      margin: const EdgeInsets.only(right: 8.0),
                      child: Container(
                        width: 16,
                        height: 12,
                        child: Image.asset(
                          'assets/images/key.png',
                        ),
                      ),
                    ),*/
                    isDense: true,
                    contentPadding: EdgeInsets.fromLTRB(10, 30, 30, 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                        color: Color(0xffDFDFDF),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                        color: Color(0xffDFDFDF),
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                        color: Color(0xffDFDFDF),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                        color: Color(0xffDFDFDF),
                      ),
                    ),
                    hintText: 'Password',
                    hintStyle:
                    TextStyle(color: Colors.black, fontSize: 16),
                    fillColor: Color(0xffffffff),
                    filled: true)),
          ),
          const SizedBox(height: 50.0),
          Container(
            width: MediaQuery.of(context).size.height * 0.80,
            margin: const EdgeInsets.only(right: 8.0, left: 8),
            child: ButtonTheme(
              height: 28.0,
              child: RaisedButton(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                textColor: Colors.white,
                color: Color(0xff54d3c0),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    setState(() {
                      _loading = true;
                    });
                    final msg = jsonEncode({
                      "email": mobileController.text,
                      "password": passwordController.text,
                      "device_token": fcmToken
                    });
                    Map<String, String> headers = {
                      'Accept': 'application/json',
                    };
                    var response = await http.post(
                      new Uri.https(BASE_URL, API_PATH + "/member-login"),
                      body: {
                        "email": mobileController.text,
                        "password": passwordController.text,
                        "device_token":fcmToken
                      },
                      headers: headers,
                    );
                    print(msg);

                    if (response.statusCode == 200) {
                      setState(() {
                        _loading = false;
                      });
                      var data = json.decode(response.body);

                      print(data);
                      var errorCode = data['ErrorCode'];
                      var errorMessage = data['ErrorMessage'];
                      if (errorCode == 0) {
                        setState(() {
                          _loading = false;
                        });
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setBool('logged_in', true);
                        prefs.setString('user_id', data['Response']['id'].toString());
                        prefs.setString('member_name', data['Response']['member_name']) ;
                        prefs.setString('member_code', data['Response']['member_code'].toString()) ;
                        prefs.setString('mobile', data['Response']['mobile']??'' );
                        prefs.setString('email', data['Response']['email']??'' );
                        prefs.setString('house_number', data['Response']['house_number'] ??'');
                        prefs.setString('api_token', data['Response']['api_token']);
                        Navigator.pushNamed(context, '/dashboard');
                      } else {
                        setState(() {
                          _loading = false;
                        });
                        showAlertDialog(
                            context, ALERT_DIALOG_TITLE, errorMessage);
                      }
                    }
                  }
                  else {

                    setState(() {
                      _autoValidate = true;
                    });
                  }
                },
                child: Text(
                  "Log in",
                  style: TextStyle(fontSize: 16, letterSpacing: 1,fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30.0),
          InkWell(
            onTap: (){
             // Navigator.pushNamed(context, '/get-otp');
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8.0, left: 8),
              child: Center(
                child:  Text(
                    "Forgot Password",
                    style:normalText2),
              ),

            ),

          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }

  Future<bool> onWillPop() {
    SystemNavigator.pop();
    return Future.value(true);
  }

  TextStyle normalText = GoogleFonts.montserrat(
      fontSize: 32, fontWeight: FontWeight.w600, color: Colors.black);
  TextStyle normalText1 = GoogleFonts.montserrat(
      fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black);
  TextStyle normalText2 = GoogleFonts.montserrat(
      fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black);

  Widget _title() {
    return  SizedBox(
      width: 100,
      height: 100,
      child: Image.asset("assets/images/rwa_logo.png"),
    );
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    double bannerHeight = 150;
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        child:Container(
          height: height,
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 100,
                child: Image.asset(
                  "assets/images/login_rectangle.png",
                   alignment: Alignment.topCenter,
                   fit: BoxFit.fill,
                ),
              ),
              Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: height * .15),
                        _title(),
                        SizedBox(height: height * .02),
                        Text(
                          "Login",
                          style:
                          normalText
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Welcome back",
                          style: normalText1,
                        ),
                        SizedBox(height: 40),
                        _loginContent(),

                      ],
                    ),
                  ),
                ),
              ),
              /* Positioned(top: 40, left: 0, child: _backButton()),*/
            ],
          ),
        ),
      ),
    );
  }
}
