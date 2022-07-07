import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:rwa/components/general.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<EditProfilePage> {
  String user_id = '';
  String member_name = '';
  String member_code = '';
  String mobile = '';
  String member_type = '';
  Future<dynamic> _profiles;
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final memberIdController = TextEditingController();
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();
  String api_token = "";
  bool _autoValidate = false;

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
      _profiles = _profileData();
    });
  }

  Future _profileData() async {
    final msg = jsonEncode({"member_id": user_id.toString()});
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $api_token',
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/dashboard"),
      body: {"member_id": user_id.toString()},
      headers: headers,
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data);
      return data;
    } else {
      throw Exception('Something went wrong');
    }
  }

  TextStyle normalText5 = GoogleFonts.montserrat(
      fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfff5f5f5),
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          title: Container(
            child: Text("Edit Profile", style: normalText5),
          ),
          leading: InkWell(
              onTap: () {
                Navigator.of(context).pop(false);
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.black54,
              )),
          flexibleSpace: Container(
            height: 100,
            color: Color(0xffcbf3eb),
          ),
          actions: <Widget>[],
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          backgroundColor: Colors.transparent,
        ),
        body: Stack(
          children: <Widget>[
            ClipPath(
              child: Container(
                decoration: BoxDecoration(color: Color(0xffcbf3eb)),
                height: 100,
              ),
            ),
            CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: <Widget>[
                SliverPadding(
                  padding:
                      const EdgeInsets.only(left: 16, bottom: 16, right: 16),
                  sliver:
                      SliverToBoxAdapter(child: _buildCategoryItem(context)),
                ),
              ],
            ),
          ],
        ));
  }

  TextStyle normalText6 = GoogleFonts.montserrat(
      fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black);
  TextStyle normalText1 = GoogleFonts.montserrat(
      fontSize: 15, fontWeight: FontWeight.w300, color: Colors.black54);

  Widget profileList(double height) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return FutureBuilder(
      future: _profiles,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var errorCode = snapshot.data['ErrorCode'];
          var response = snapshot.data['userData'];
          if (errorCode == 0) {
            return Container(
                margin: EdgeInsets.only(right: 8.0, left: 8, top: height * 0.09),
                child: Column(children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      child: Text(
                        "Name",
                        textAlign: TextAlign.left,
                        style: normalText1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Container(
                    child: TextFormField(
                        initialValue: response['member_name'],
                        enabled: false,
                        keyboardType: TextInputType.text,
                        cursorColor: Color(0xff000000),
                        style: normalText6,
                        textCapitalization: TextCapitalization.sentences,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please Enter Member Name';
                          }
                          return null;
                        },
                        onSaved: (String value) {
                          nameController.text = value;
                        },
                        decoration: InputDecoration(
                            suffixIcon: InkWell(
                              onTap: () {},
                              child: Icon(Icons.person, color: Colors.black54),
                            ),
                            isDense: true,
                            contentPadding: EdgeInsets.fromLTRB(10, 30, 30, 0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Color(0xffDFDFDF),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Color(0xffDFDFDF),
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Color(0xffDFDFDF),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Color(0xffDFDFDF),
                              ),
                            ),
                            hintStyle:
                                TextStyle(color: Color(0xff686868), fontSize: 16),
                            fillColor: Color(0xffffffff),
                            filled: true)),
                  ),
                  const SizedBox(height: 15.0),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      child: Text(
                        "Member Id",
                        textAlign: TextAlign.left,
                        style: normalText1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Container(
                    child: TextFormField(
                        enabled: false,
                        initialValue: response['member_code'],
                        keyboardType: TextInputType.text,
                        cursorColor: Color(0xff000000),
                        style: normalText6,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                            suffixIcon: InkWell(
                              onTap: () {},
                              child: Icon(Icons.perm_identity,
                                  color: Colors.black54),
                            ),
                            isDense: true,
                            contentPadding: EdgeInsets.fromLTRB(10, 30, 30, 0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Color(0xffDFDFDF),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Color(0xffDFDFDF),
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Color(0xffDFDFDF),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Color(0xffDFDFDF),
                              ),
                            ),
                            hintStyle:
                                TextStyle(color: Color(0xff686868), fontSize: 16),
                            fillColor: Color(0xffffffff),
                            filled: true)),
                  ),
                  const SizedBox(height: 15.0),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      child: Text(
                        "Email Id",
                        textAlign: TextAlign.left,
                        style: normalText1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Container(
                    child: TextFormField(
                        initialValue: response['email'] ?? '',
                        keyboardType: TextInputType.text,
                        cursorColor: Color(0xff000000),
                        style: normalText6,
                        textCapitalization: TextCapitalization.sentences,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Your Email Address';
                          } else if (!regex.hasMatch(value)) {
                            return "Enter Valid Email";
                          }
                          return null;
                        },
                        onSaved: (String value) {
                          emailController.text = value;
                        },
                        decoration: InputDecoration(
                            suffixIcon: InkWell(
                              onTap: () {},
                              child: Icon(Icons.email, color: Colors.black54),
                            ),
                            isDense: true,
                            contentPadding: EdgeInsets.fromLTRB(10, 30, 30, 0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Color(0xffDFDFDF),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Color(0xffDFDFDF),
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Color(0xffDFDFDF),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Color(0xffDFDFDF),
                              ),
                            ),
                            hintStyle:
                                TextStyle(color: Color(0xff686868), fontSize: 16),
                            fillColor: Color(0xffffffff),
                            filled: true)),
                  ),
                  const SizedBox(height: 15.0),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      child: Text(
                        "Mobile No.",
                        textAlign: TextAlign.left,
                        style: normalText1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Container(
                    child: TextFormField(
                        maxLength: 10,
                        initialValue: response['mobile'] ?? '',
                        keyboardType: TextInputType.text,
                        cursorColor: Color(0xff000000),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please Enter Mobile No.';
                          }
                          return null;
                        },
                        onSaved: (String value) {
                          mobileController.text = value;
                        },
                        style: normalText6,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                            counterText: "",
                            suffixIcon: InkWell(
                              onTap: () {},
                              child: Icon(Icons.phone_android,
                                  color: Colors.black54),
                            ),
                            isDense: true,
                            contentPadding: EdgeInsets.fromLTRB(10, 30, 30, 0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Color(0xffDFDFDF),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Color(0xffDFDFDF),
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Color(0xffDFDFDF),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Color(0xffDFDFDF),
                              ),
                            ),
                            hintStyle:
                                TextStyle(color: Color(0xff686868), fontSize: 16),
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
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 80),
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
                              "mobile": mobileController.text,
                              "email": emailController.text,
                              "username": nameController.text,
                              "member_id": user_id
                            });
                            Map<String, String> headers = {
                              'Accept': 'application/json',
                              'Authorization': 'Bearer $api_token',
                            };
                            var response = await http.post(
                              new Uri.https(
                                  BASE_URL, API_PATH + "/account-setting"),
                              body: {
                                "mobile": mobileController.text,
                                "email": emailController.text,
                                "username": nameController.text,
                                "member_id": user_id
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
                                SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                                prefs.setString('mobile', data['Response']['mobile']??'' );
                                prefs.setString('email', data['Response']['email']??'' );


                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                Navigator.pushNamed(context, '/dashboard');
                                Fluttertoast.showToast(msg: "Profile Updated Successfully");
                              } else {
                                setState(() {
                                  _loading = false;
                                });
                                showAlertDialog(
                                    context, ALERT_DIALOG_TITLE, errorMessage);
                              }
                            }
                          } else {
                            setState(() {
                              _autoValidate = true;
                            });
                          }
                        },
                        child: Text(
                          "Submit",
                          style: TextStyle(
                              fontSize: 16,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                ]),
              );

          } else {
            return Container();
          }
        } else {
          return Center(child: Container(child: CircularProgressIndicator()));
        }
      },
    );
  }

  Widget _buildAccountDetail() {
    return Container(
      padding: EdgeInsets.only(
        left: 15.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            member_name,
            style: TextStyle(
              fontSize: 17.0,
              color: Colors.black87,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 4.0),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Mobile No.: ',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black87,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(
                width: 3.0,
              ),
              Text(
                mobile,
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black87,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Column(children: <Widget>[
      Container(
        padding: EdgeInsets.only(left: 20),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              width: 75,
              height: 75,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xffffffff),
                image: DecorationImage(
                  image: AssetImage("assets/images/rwa_logo.png"),
                  fit: BoxFit.cover,
                ),
                border: Border.all(
                  color: Color(0xff54d3c0),
                  width: 1.0,
                ),
              ),
            ),
            _buildAccountDetail(),
          ],
        ),
      ),
      Form(key: _formKey, child: profileList(height),
      )
    ]);
  }
}
