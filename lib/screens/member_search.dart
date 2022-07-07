import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../constants.dart';

class MemberPage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<MemberPage> {
  String user_id = '';
  String member_name = '';
  String member_code = '';
  String mobile = '';
  String member_type = '';
  Future _sector;
  Future _member;
  List<Region> _region = [];
  String selectedRegion;
  bool _loading = false;
  bool show = false;
  bool enter_one = false;
  var _type="";
  String catData = "";
  final houseNoController = TextEditingController();
  final memberNameController = TextEditingController();
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
     _getActivityCategories();
    });
  }
  Future _getActivityCategories() async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $api_token',
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/sector-list"),
      body: {
        "member_id":user_id
      },
      headers: headers,
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var result = data['Response'];
      if (mounted) {
        setState(() {
          catData = jsonEncode(result);

          final json = JsonDecoder().convert(catData);
          _region =
              (json).map<Region>((item) => Region.fromJson(item)).toList();
          List<String> item = _region.map((Region map) {
            for (int i = 0; i < _region.length; i++) {
              if (selectedRegion == map.THIRD_LEVEL_NAME) {
                _type = map.THIRD_LEVEL_ID;


                return map.THIRD_LEVEL_ID;
              }
            }
          }).toList();
          if (selectedRegion == "") {
            selectedRegion = _region[0].THIRD_LEVEL_NAME;
            _type = _region[0].THIRD_LEVEL_ID;
          }
        });
      }

      return data;
    } else {
      throw Exception('Something went wrong');
    }
  }
  TextStyle normalText5 = GoogleFonts.montserrat(
      fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black);

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Color(0xfff5f5f5),
        appBar:AppBar(
          elevation: 0.0,
          centerTitle: true,
          title: Container(
            child: Text("Member Search", style: normalText5),
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
        body:ModalProgressHUD(
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
                      height: 5.0,
                    ),
                    Column(children: <Widget>[

                      Container(


                        padding: EdgeInsets.all(10),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1.0,
                              color: Color(0xffDFDFDF),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: Padding(
                            padding: EdgeInsets.only(right: 0, left: 3),
                            child: new DropdownButton<String>(
                              isExpanded: true,
                              hint: new Text(
                                "Select Sector",
                                style: TextStyle(color: Color(0xffBBBFC3)),
                              ),
                              icon: Padding(
                                padding: const EdgeInsets.only(left: 0),
                                child: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black,
                                ),
                              ),
                              value: selectedRegion,
                              isDense: true,
                              onChanged: (newValue) {
                                setState(() {
                                  selectedRegion = newValue;
                                  List<String> item = _region.map((Region map) {
                                    for (int i = 0; i < _region.length; i++) {
                                      if (selectedRegion == map.THIRD_LEVEL_NAME) {
                                        _type = map.THIRD_LEVEL_ID;
                                        return map.THIRD_LEVEL_ID;
                                      }
                                    }
                                  }).toList();
                                });
                              },
                              items: _region.map((Region map) {
                                return new DropdownMenuItem<String>(
                                  value: map.THIRD_LEVEL_NAME,
                                  child: new Text(map.THIRD_LEVEL_NAME,
                                      style: normalText6),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),

                      Container(
                        child: TextFormField(

                            controller:houseNoController ,
                            keyboardType: TextInputType.text,
                            cursorColor: Color(0xff000000),
                            style: normalText6,
                            textCapitalization: TextCapitalization.sentences,
                            onChanged: (String newValue) async {

                              if(newValue!="") {
                                setState(() {
                                  enter_one = true;
                                });
                              }
                              else{
                                setState(() {
                                  enter_one = false;
                                });
                              }

                            },
                            decoration: InputDecoration(
                                suffixIcon: InkWell(
                                  onTap: () {},
                                  child: Icon(Icons.house, color: Colors.black54),
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
                                TextStyle(color: Color(0xffBBBFC3)),
                                hintText: "House No.",
                                fillColor: Color(0xffffffff),
                                filled: true)),
                      ),
                      const SizedBox(height: 10.0),

                      Container(
                        child: TextFormField(

                            controller: memberNameController,
                            keyboardType: TextInputType.text,
                            cursorColor: Color(0xff000000),
                            style: normalText6,
                            textCapitalization: TextCapitalization.sentences,
                            onChanged: (String newValue) async {

                              if(newValue!="") {
                                setState(() {
                                  enter_one = true;
                                });
                              }
                              else{
                                setState(() {
                                  enter_one = false;
                                });
                              }
                            },
                            decoration: InputDecoration(
                                suffixIcon: InkWell(
                                  onTap: () {},
                                  child: Icon(Icons.perm_identity, color: Colors.black54),
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
                                TextStyle(color: Color(0xffBBBFC3)),
                                hintText: "Member Name",
                                fillColor: Color(0xffffffff),
                                filled: true)),
                      ),
                      const SizedBox(height: 10.0),
                      Container(
                        child: ButtonTheme(
                          height: 28.0,
                          child: RaisedButton(
                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            textColor: Colors.white,
                            color: Color(0xff54d3c0),
                            onPressed: () async {
                              if(_type!=""){
                                if(enter_one){
                                  setState(() {
                                    show=true;
                                    _member= _getMemberCategories(_type,houseNoController.text,memberNameController.text);
                                  });

                                }

                                else{
                                  Fluttertoast.showToast(
                                      msg: "Please enter either house no. or member name.");
                                }

                              }
                              else if(houseNoController.text!=""){
                                  setState(() {
                                    show=true;
                                    _member= _getMemberCategories("",houseNoController.text,"");
                                  });




                              }
                              else if(memberNameController.text!=""){
                                setState(() {
                                  show=true;
                                  _member= _getMemberCategories("","",memberNameController.text);
                                });

                              }
                            },
                            child: Text(
                              "Search",
                              style: TextStyle(fontSize: 16, letterSpacing: 1,fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),

                    ]),
                    SizedBox(
                      height: 5.0,
                    ),
                  show?  Expanded(child:
                    Container(
                      padding: EdgeInsets.only(bottom: 5),
                      child: profileList( deviceSize),
                    ),

                    ):Container(),
                    SizedBox(
                      height: 5.0,
                    ),
                  ],
                )),
          ),
        ));
  }

  TextStyle normalText6 = GoogleFonts.montserrat(
      fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black);
  TextStyle normalText4 = GoogleFonts.montserrat(
      fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black);
  TextStyle normalText1 = GoogleFonts.montserrat(
      fontSize: 15, fontWeight: FontWeight.w300, color: Colors.black54);
  TextStyle normalText3 = GoogleFonts.montserrat(
      fontSize: 14, fontWeight: FontWeight.w400, color: Colors.blue);

  _launchCaller(String s) async {
    var url = "tel:"+s;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  Widget profileList(Size deviceSize) {
    return FutureBuilder(
      future: _member,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var errorCode = snapshot.data['ErrorCode'];
          var response = snapshot.data['Response']['member_list'];
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
                                      Row(
                                  children: <Widget>[
                                    Container(
                                          child: Text(
                                              response[index]['rank']??'',
                                              overflow:
                                              TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: normalText4),
                                        ),
                                    SizedBox(
                                      width: 4.0,
                                    ),
                                    Container(
                                      child: Text(
                                          response[index]['member_name']??'',
                                          overflow:
                                          TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: normalText4),
                                    ),
                                  ]
                                      ),
                                      SizedBox(
                                        height: 4.0,
                                      ),
                                      Container(
                                        child: Row(children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 15),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: response[index]
                                                ['enabled']==1?Color(0xff5ab1e9):
                                                Color(0xfff9533d)

                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  response[index]
                                                  ['enabled']==1?"Active":"Inactive",
                                                  // snapshot.data['cart_quantity'] > 0 ? 'Go to Basket' : 'Add to Basket',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),

                                        ]),
                                      ),
                                      SizedBox(
                                        height: 4.0,
                                      ),
                                      Container(
                                        child: Row(children: <Widget>[
                                          Image.asset(
                                            "assets/images/phone.png",
                                            height: 11,
                                          ),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                          RichText(
                                              text: TextSpan(
                                                  children: [

                                                    TextSpan(
                                                        style: normalText3,
                                                        text:  response[index]
                                                        ['mobile']??'',
                                                        recognizer: TapGestureRecognizer()..onTap =  () async{
                                                          var url =  response[index]['mobile']??'';
                                                          _launchCaller(url);
                                                        }
                                                    ),
                                                  ]
                                              ))
                                        ]),
                                      ),
                                      SizedBox(
                                        height: 4.0,
                                      ),
                                      Container(
                                        child: Row(children: <Widget>[
                                          Image.asset(
                                            "assets/images/email.png",
                                            height: 11,
                                          ),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                          Expanded(
                                            child: Text(
                                                response[index]['email']??'',
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
                                            "assets/images/house_no.png",
                                            height: 11,
                                          ),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                          Text(
                                              response[index]
                                              ['house_number']??'',
                                              style: normalText1),
                                        ]),
                                      ),

                                      SizedBox(
                                        height: 4.0,
                                      ),
                                      Container(
                                        child: Row(children: <Widget>[
                                          Image.asset(
                                            "assets/images/address.png",
                                            height: 11,
                                          ),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                          Expanded(
                                            child: Text(
                                                "Sector: " +
                                                    response[index]['sector_name']??'',
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
  Widget _emptyOrders() {
    return Center(
      child: Container(


          child: Text('NO RECORD FOUND!')),
    );
  }
  Future _getMemberCategories(String type,String house,String member) async {

    final msg = jsonEncode({
      "search":"search",
      "member_id":user_id,
      "member_name":member,
      "sector":type,
      "house_no":house
    });
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $api_token',
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/member-list"),
      body: {
        "search":"search",
        "member_id":user_id,
        "member_name":member,
        "sector":type,
        "house_no":house
      },
      headers: headers,
    );
    print(msg);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data);
      var result = data['Response']['member_list'];


      return data;
    } else {
      throw Exception('Something went wrong');
    }
  }

}
class Region {
  final String THIRD_LEVEL_ID;
  final String THIRD_LEVEL_NAME;

  Region({ this.THIRD_LEVEL_ID,  this.THIRD_LEVEL_NAME});

  factory Region.fromJson(Map<String, dynamic> json) {
    return new Region(
        THIRD_LEVEL_ID: json['id'].toString(),
        THIRD_LEVEL_NAME: json['name']);
  }
}