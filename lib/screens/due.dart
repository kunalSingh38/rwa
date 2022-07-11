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

class Dues extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Dues> {
  String user_id = '';
  String member_name = '';
  String member_code = '';
  String mobile = '';
  String member_type = '';
  String total_due = '';
  String total_advance = '';
  Future<dynamic> _profiles;
  String api_token = "";
  bool _loading = false;
  String urgent = "";
  final DateController = TextEditingController();
  final completeController = TextEditingController();

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
    });
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $api_token',
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/due-charges-list"),
      body: {
        "member_id": user_id.toString(),
      },
      headers: headers,
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data);

      setState(() {
        total_due = data['totalDue'].toString();
        total_advance = data['totalAdvance'].toString();
      });

      return data;
    } else {
      throw Exception('Something went wrong');
    }
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0.0,
      // centerTitle: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            'Welcome!',
            style: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: 5,
          ),
        ],
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(
            Icons.notifications,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  TextStyle normalText5 = GoogleFonts.montserrat(
      fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black);
  TextStyle normalText2 = GoogleFonts.montserrat(
      fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black);
  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Color(0xfff5f5f5),
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          title: Container(
            child: Text("Dues List", style: normalText5),
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
        floatingActionButton: Container(
          child: FloatingActionButton.extended(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/billing-details',
              );
            },
            backgroundColor: Color(0xff54d3c0),
            label: Text("Make Payment"),
            icon: Icon(
              Icons.payment,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterFloat,
        body: ModalProgressHUD(
          inAsyncCall: _loading,
          child: Container(
            decoration: BoxDecoration(color: Color(0xfff5f5f5)),
            child: Container(
                child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(children: <Widget>[
                          Text("Dues",
                              maxLines: 2,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: normalText1),
                          Text(total_due,
                              maxLines: 2,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: normalText7),
                        ]),
                        Column(children: <Widget>[
                          Text("Total Advance",
                              maxLines: 2,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: normalText1),
                          Text(total_advance,
                              maxLines: 2,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: normalText8),
                        ]),
                      ]),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: deviceSize.width * 0.03,
                    ),
                    padding: EdgeInsets.only(bottom: 5),
                    child: _buildCategoryItem(context, deviceSize),
                  ),
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
  TextStyle normalText7 = GoogleFonts.montserrat(
      fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xfff9533d));
  TextStyle normalText8 = GoogleFonts.montserrat(
      fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xff5ab1e9));
  TextStyle normalText1 = GoogleFonts.montserrat(
      fontSize: 13, fontWeight: FontWeight.w400, color: Colors.black54);
  File _image;

  Widget _buildCategoryItem(BuildContext context, Size deviceSize) {
    return FutureBuilder(
      future: _profiles,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var errorCode = snapshot.data['ErrorCode'];
          var response = snapshot.data['Response']['duesList'];
          if (errorCode == 0) {
            if (response.length != 0) {
              return Container(
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: response.length,
                    itemBuilder: (BuildContext context, index) {
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
                          margin:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 8),
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
                                  boxShadow: [
                                    //background color of box
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 3.0, // soften the shadow
                                      spreadRadius: 3.0, //extend the shadow
                                      offset: Offset(
                                        1.0, // Move to right 10  horizontally
                                        1.0, // Move to bottom 10 Vertically
                                      ),
                                    )
                                  ]),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.85,
                                margin: EdgeInsets.only(left: 5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                          response[index]['charge_type'] +
                                              " (Up to ${response[index]['dueDate']} )",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: normalText2),
                                    ),
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                    Container(
                                      child: Row(children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 15),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: response[index]
                                                          ['paidStatus'] ==
                                                      "Paid"
                                                  ? Color(0xff5ab1e9)
                                                  : Color(0xfff9533d)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                response[index]['paidStatus'] ??
                                                    '',
                                                // snapshot.data['cart_quantity'] > 0 ? 'Go to Basket' : 'Add to Basket',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8.0,
                                        ),
                                      ]),
                                    ),
                                    SizedBox(
                                      height: 4.0,
                                    ),
                                    Container(
                                      child: Row(children: <Widget>[
                                        Image.asset(
                                          "assets/images/rupee.png",
                                          height: 11,
                                        ),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        Expanded(
                                          child: Text(
                                              response[index]['due_amount'],
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
                                    Container(
                                      child: Row(children: <Widget>[
                                        Image.asset(
                                          "assets/images/date.png",
                                          height: 11,
                                        ),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        Expanded(
                                          child: Text(
                                              "DUE DATE: " +
                                                  response[index]['due_date'],
                                              maxLines: 2,
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                              style: normalText1),
                                        ),
                                      ]),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
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
