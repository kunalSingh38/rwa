import 'dart:convert';
import 'dart:io';
import 'package:flutter/gestures.dart';
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
import 'package:url_launcher/url_launcher.dart';
import '../constants.dart';
import 'package:rwa/components/full_image.dart';

class NotificationsList extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<NotificationsList> {
  String user_id = '';
  String member_name = '';
  String member_code = '';
  String mobile = '';
  String member_type = '';
  Future<dynamic> _profiles;
  String api_token = "";
  bool _loading = false;
  String urgent="";
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
      child: Container(


          child: Text('NO RECORD FOUND!')),
    );
  }
  Future _getComplaintCategories() async {


    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $api_token',
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/notification-list"),
      body: {
        "member_id":user_id
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
          icon: const Icon(Icons.notifications,color: Colors.white,), onPressed: () {  },

        ),
      ],
    );
  }
  TextStyle normalText5 = GoogleFonts.montserrat(
      fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black);
  TextStyle normalText6 = GoogleFonts.montserrat(
      fontSize: 13, fontWeight: FontWeight.w400, color: Colors.black38);
  TextStyle normalText2 = GoogleFonts.montserrat(
      fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black);
  @override
  Widget build(BuildContext context){
    Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Color(0xfff5f5f5),
        appBar:AppBar(
          elevation: 0.0,
          centerTitle: true,
          title: Container(
            child: Text("Notification List", style: normalText2),
          ),
          leading: InkWell(
              onTap: (){
                Navigator.of(context).pop(false);
              },
              child: Icon(Icons.arrow_back,color: Colors.black54,)),
          flexibleSpace: Container(
            height: 100,
            color: Color(0xffcbf3eb),
          ),
          actions: <Widget>[

          ],
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          backgroundColor: Colors.transparent,
        ),
        body: ModalProgressHUD(
          inAsyncCall: _loading,
          child: Container(
            decoration: BoxDecoration(
                color: Color(0xfff5f5f5)
            ),
            child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: deviceSize.width * 0.03,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    SizedBox(
                      height: 10.0,
                    ),



                    Expanded(child:
                    Container(
                      padding: EdgeInsets.only(bottom: 5),
                      child: _buildCategoryItem(context,deviceSize),
                    ),

                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                  ],
                )),
          ),
        )
    );
  }



  TextStyle normalText1 = GoogleFonts.montserrat(
      fontSize: 13, fontWeight: FontWeight.w400, color: Colors.black54);
  TextStyle normalText3 = GoogleFonts.montserrat(
      fontSize: 14, fontWeight: FontWeight.w400, color: Colors.blue);
  File _image;
  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildCategoryItem(BuildContext context, Size deviceSize) {

    return FutureBuilder(
      future: _profiles,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var errorCode = snapshot.data['ErrorCode'];
          var response = snapshot.data['Response']['notice_list'];
          if (errorCode == 0) {

            if(response.length!=0) {
              return

                Container(
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: response.length,
                      itemBuilder: (BuildContext context, index) {
                        return InkWell(
                          onTap: () {

                          },
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
                            margin: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 8),
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
                                    ]
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.0,
                                    horizontal: 10
                                ),

                                child:
                                Container(
                                  width:
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .width *
                                      0.85,
                                  margin: EdgeInsets.only(left: 5.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[

                                      Container(
                                        child: Row(children: <Widget>[
                                          Image.asset(
                                            "assets/images/date.png",
                                            height: 11,
                                          ),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                          Text(
                                              response[index]
                                              ['created_at']??'',
                                              style: normalText1),
                                        ]),
                                      ),
                                      SizedBox(
                                        height: 6.0,
                                      ),
                                      Container(
                                        child: Text(
                                            response[index]['subject'],
                                            overflow:
                                            TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: normalText5),
                                      ),

                                      SizedBox(
                                        height: 4.0,
                                      ),
                                      Container(
                                        child: Text(
                                            response[index]['message'],
                                            overflow:
                                            TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: normalText6),
                                      ),
                                      SizedBox(
                                        height: 6.0,
                                      ),

                                      response[index]['noticeFile'] != ""
                                          ? InkWell(
                                        onTap: (){
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (_) {
                                                return FullScreenImage(
                                                  imageUrl:
                                                  response[index]['noticeFile'],
                                                  tag: "generate_a_unique_tag",
                                                );
                                              }));
                                        },
                                        child: Container(

                                          height: 150,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    response[index]['noticeFile']),
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                      )
                                          : Container(),
                                    ],
                                  ),
                                ),


                              ),
                            ),
                          ),
                        );
                      }),
                );
            }
            else{
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
