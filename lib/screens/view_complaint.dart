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

class ViewComplaint extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<ViewComplaint> {
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
  List<UserDetails> _userDetails = [];
  List<UserDetails> _searchResult = [];
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
    _searchResult.clear();
    _userDetails.clear();
    completeController.text = "";
    final msg = jsonEncode({
      "member_id":user_id.toString(),
      "from_date":"",
      "to_date":"",
      "search":""
    });
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $api_token',
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/complaint-list"),
      body: {
        "member_id":user_id.toString(),
        "from_date":"",
        "to_date":"",
        "search":""
      },
      headers: headers,
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      var result = data['Response']['complaintList'];
      setState(() {
        for (Map user in result) {
          _userDetails.add(UserDetails.fromJson(user));
        }
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
          icon: const Icon(Icons.notifications,color: Colors.white,), onPressed: () {  },

        ),
      ],
    );
  }
  TextStyle normalText5 = GoogleFonts.montserrat(
      fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black);
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
            child: Text("View Complaint", style: normalText5),
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
                      height: 20.0,
                    ),

                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: new TextField(
                          enabled: true,
                          controller: completeController,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding: EdgeInsets.fromLTRB(10, 30, 30, 0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Color(0xffF8F2EE),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Color(0xffF8F2EE),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Color(0xffF8F2EE),
                              ),
                            ),
                            counterText: "",
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Color(0xffF8F2EE),
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Color(0xffF8F2EE),
                              ),
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.black54,
                              size: 24,
                            ),
                            hintStyle: TextStyle(
                                color: Colors.black54,
                                fontFamily: "WorkSansLight"),
                            hintText: 'Search ',
                          ),
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          keyboardType: TextInputType.text,
                          cursorColor: Colors.black,
                          textCapitalization: TextCapitalization.none,
                          onChanged: onSearchTextChanged,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
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

  onSearchTextChanged(String text) async {
    print(text);
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _userDetails.forEach((userDetail) {
      if (userDetail.activity_desc
          .toString()
          .toLowerCase()
          .contains(text.toLowerCase())) _searchResult.add(userDetail);
    });


    setState(() {});
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
          var response = snapshot.data['Response']['complaintList'];
          if (errorCode == 0) {

            if(response.length!=0) {
              return
                _searchResult.length != 0 ||
                    completeController.text.isNotEmpty
                    ?
                Container(
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: _searchResult.length,
                      itemBuilder: (BuildContext context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/complaint-details',
                              arguments: <String, String>{
                                'complaint_id': response[index]['id'].toString(),
                              },
                            );

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
                                        child: Text(
                                            _searchResult[index].activity_desc,
                                            overflow:
                                            TextOverflow.ellipsis,
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
                                          Text(
                                              _searchResult[index].created_at,
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
                                            child: Text(
                                                _searchResult[index].description,
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
                                      ),
                                      Container(
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
                                                "Raised by: " +
                                                    _searchResult[index].member_name,
                                                maxLines: 2,
                                                softWrap: true,
                                                overflow:
                                                TextOverflow.ellipsis,
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
                ):
                Container(
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: response.length,
                    itemBuilder: (BuildContext context, index) {
                      return InkWell(
                        onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/complaint-details',
                          arguments: <String, String>{
                            'complaint_id': response[index]['id'].toString(),
                          },
                        );

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
                                      child: Text(
                                          response[index]['activity_desc'],
                                          overflow:
                                          TextOverflow.ellipsis,
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
                                        Text(
                                            response[index]
                                            ['created_at'],
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
                                          child: Text(
                                              response[index]['description']??'',
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
                                    ),
                                    Container(
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
                                              "Raised by: " +
                                                  response[index]['member_name'],
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
                                    ),
                                    Container(
                                      child: Row(children: <Widget>[
                                        Text(
                                            "Compliant status: ",
                                            maxLines: 2,
                                            softWrap: true,
                                            overflow:
                                            TextOverflow.ellipsis,
                                            style: normalText3),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        Expanded(
                                          child: Text(
                                                  response[index]['complaint_status'],
                                              maxLines: 2,
                                              softWrap: true,
                                              overflow:
                                              TextOverflow.ellipsis,
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
class UserDetails {
  final String id,
      description,
      member_name,
      activity_desc,
      created_at
      ;

  UserDetails(
      {this.id,
        this.description,
        this.member_name,
        this.activity_desc,
        this.created_at
       });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return new UserDetails(
        id: json['id'].toString(),
        description: json['description'],
        member_name: json['member_name'],
        activity_desc: json['activity_desc'],
      created_at: json['created_at'],
    );
  }
}
