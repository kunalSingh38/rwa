import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:rwa/components/general.dart';


import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';


class ChangePassword extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<ChangePassword> {
  final passwordController = TextEditingController();
  final cPasswordController = TextEditingController();
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();
  bool _isHidden = true;
  bool _isHidden1 = true;
  bool _autoValidate = false;
  String user_id = '';
  String member_name = '';
  String member_code = '';
  String mobile = '';
  String member_type = '';
  String api_token = "";
  @override
  void initState() {
    super.initState();
    _getUser();
  }
  _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user_id = prefs.getString('user_id').toString();
      member_name = prefs.getString('member_name').toString();
      member_code = prefs.getString('member_code').toString();
      mobile = prefs.getString('mobile').toString();
      member_type = prefs.getString('member_type').toString();
      api_token = prefs.getString('api_token').toString();
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
                controller: passwordController,
                obscureText: _isHidden1,
                // maxLength: 10,
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
                          _isHidden1 = !_isHidden1;
                        });
                      },
                      child: Icon(
                          _isHidden ? Icons.visibility_off : Icons.visibility,
                          color: Colors.black87),
                    ),
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
                    hintText: 'Password',
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
                controller: cPasswordController,
                keyboardType: TextInputType.text,
                cursorColor: Color(0xff000000),
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter confirm password';
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
                    hintText: 'Confirm Password',
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
                      "member_id": user_id,
                      "password": passwordController.text,
                      "cpassword": cPasswordController.text,
                    });
                    Map<String, String> headers = {
                      'Accept': 'application/json',
                      'Authorization': 'Bearer $api_token',
                    };
                    var response = await http.post(
                      new Uri.https(BASE_URL, API_PATH + "/password-update"),
                      body: {
                        "member_id": user_id,
                        "password": passwordController.text,
                        "cpassword": cPasswordController.text,
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

                        Navigator.of(context).pop();
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
                  "Change Password",
                  style: TextStyle(fontSize: 16, letterSpacing: 1,fontWeight: FontWeight.w600),
                ),
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
                child: Image.asset(
                  "assets/images/login_rectangle.png",
                  // height: bannerHeight,
                  alignment: Alignment.topCenter,
                  fit: BoxFit.fitWidth,
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
                        SizedBox(height: height * .26),
                        Text(
                            "Change Password",
                            style:
                            normalText
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
