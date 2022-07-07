import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:rwa/components/general.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../constants.dart';

class ComplaintDetails extends StatefulWidget {
  final Object argument;

  const ComplaintDetails({Key key, this.argument}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<ComplaintDetails> {
  String user_id = '';
  String member_name = '';
  String member_code = '';
  String mobile = '';
  String member_type = '';
  String c_id = '';
  Future<dynamic> _profiles;
  String api_token = "";
  bool _loading = false;
  String urgent = "";
  final DateController = TextEditingController();
  final completeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    var encodedJson = json.encode(widget.argument);
    var data = json.decode(encodedJson);
    c_id = data['complaint_id'];
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
      _profiles = _getComplaintCategories();
    });
  }

  Widget _emptyOrders() {
    return Center(
      child: Container(child: Text('NO RECORD FOUND!')),
    );
  }

  Future _getComplaintCategories() async {
    final msg = jsonEncode({
      "member_id": user_id.toString(),
      "complaint_id": c_id,
    });
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $api_token',
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/complaint-details"),
      body: {
        "member_id": user_id.toString(),
        "complaint_id": c_id,
      },
      headers: headers,
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      return data;
    } else {
      throw Exception('Something went wrong');
    }
  }

  TextStyle normalText5 = GoogleFonts.montserrat(
      fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black);
  TextStyle normalText2 = GoogleFonts.montserrat(
      fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black);

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Color(0xfff5f5f5),
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          title: Container(
            child: Text("Complaint Detail", style: normalText5),
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
        body: ModalProgressHUD(
          inAsyncCall: _loading,
          child: Container(
            decoration: BoxDecoration(color: Color(0xfff5f5f5)),
            child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: deviceSize.width * 0.03,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 5),
                      child: _buildCategoryItem(context, deviceSize),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                  ],
                )),
          ),
        ));
  }

  TextStyle normalText6 = GoogleFonts.montserrat(
      fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black);
  TextStyle normalText1 = GoogleFonts.montserrat(
      fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black54);
  TextStyle normalText3 = GoogleFonts.montserrat(
      fontSize: 13, fontWeight: FontWeight.w300, color: Colors.black54);
  File _image;

  Widget _buildCategoryItem(BuildContext context, Size deviceSize) {
    return FutureBuilder(
      future: _profiles,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var errorCode = snapshot.data['ErrorCode'];
          var response = snapshot.data['Response'];
          if (errorCode == 0) {
            if (response.length != 0) {
              return InkWell(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(6),
                      bottomLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                      bottomRight: Radius.circular(6),
                    ),
                  ),
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Center(
                    child: Container(
                      width: deviceSize.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(6),
                          bottomLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                          bottomRight: Radius.circular(6),
                        ),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.85,
                        margin: EdgeInsets.only(left: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Text(response['activity'],
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: normalText2),
                            ),
                            SizedBox(
                              height: 4.0,
                            ),
                            Container(
                              child: Row(children: <Widget>[
                                Image.asset(
                                  "assets/images/calendar.png",
                                  height: 11,
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(response['created_at'],
                                    style: normalText1),
                              ]),
                            ),
                            SizedBox(
                              height: 4.0,
                            ),
                            Container(
                              child: Row(children: <Widget>[
                                Image.asset(
                                  "assets/images/category.png",
                                  height: 11,
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Expanded(
                                  child: Text(response['category'] ?? '',
                                      maxLines: 2,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      style: normalText1),
                                ),
                              ]),
                            ),
                            SizedBox(
                              height: 4.0,
                            ),
                            /* Container(
                                child: Row(children: <Widget>[
                                  Image.asset(
                                    "assets/images/user.png",
                                    height: 11,
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Expanded(
                                    child: Text(
                                        "Assigned to: " +
                                            response['assigned_to'],
                                        maxLines: 2,
                                        softWrap: true,
                                        overflow:
                                        TextOverflow.ellipsis,
                                        style: normalText1),
                                  ),
                                ]),
                              ),

                              SizedBox(
                                height: 4.0,
                              ),*/
                            Container(
                              child: Row(children: <Widget>[
                                Text("Compliant status: ",
                                    maxLines: 2,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    style: normalText3),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Expanded(
                                  child: Text(response['complaint_status'],
                                      maxLines: 2,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      style: normalText1),
                                ),
                              ]),
                            ),
                            SizedBox(
                              height: 6.0,
                            ),
                            response['complaint_image'] != ""
                                ? Container(
                                    height: 160,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              response['complaint_image']),
                                          fit: BoxFit.cover),
                                    ),
                                  )
                                : Container(),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              child:
                                  Text("Service Details", style: normalText6),
                            ),

                            SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            child:
                                            Text("Resolved by: ", style: normalText1),
                                          ),
                                          Container(
                                            child:
                                            Text("Date:", style: normalText1),
                                          ),

                                        ]
                                    ),



                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                        child:
                                        Text(response['updated_by']??'', style: normalText1),
                                      ),
                                          Container(
                                            child:
                                            Text(response['closed_at']??'', style: normalText1),
                                          ),

                                        ]
                                    ),

                                  ]
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Center(
                              child: Icon(
                                Icons.arrow_upward,
                                color: Colors.blueGrey,
                                size: 24,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Center(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            child:
                                            Text("Assigned to: ", style: normalText1),
                                          ),
                                          Container(
                                            child:
                                            Text("Date:", style: normalText1),
                                          ),
                                        ]
                                    ),


                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                        child:
                                        Text(response['assigned_to']??'', style: normalText1),
                                      ),
                                          Container(
                                            child:
                                            Text(response['assigned_at']??'', style: normalText1),
                                          ),
                                        ]
                                    ),

                                  ]
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Center(
                              child: Icon(
                                Icons.arrow_upward,
                                color: Colors.blueGrey,
                                size: 24,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      child:
                                      Text("Created On: ", style: normalText1),
                                    ),

                                    Container(
                                      child:
                                      Text(response['createdAt']??'', style: normalText1),
                                    ),

                                  ]
                              ),
                            ),



                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return _emptyOrders();
            }
          } else {
            return Container();
          }
        } else {
          return Center(child: Container(child: CircularProgressIndicator()));
        }
      },
    );
  }
}
