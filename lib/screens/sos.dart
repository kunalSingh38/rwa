import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';

class SOS extends StatefulWidget {
  final String modal;

  SOS(this.modal);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<SOS> {
  String user_id = '';
  String member_name = '';
  String member_code = '';
  String mobile = '';
  String member_type = '';
  Future<dynamic> _profiles;
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
      _profiles = _getSosCategories();
    });
  }
  Future _getSosCategories() async {


    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $api_token',
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/sos-list"),
      body: "",
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
  @override
  Widget build(BuildContext context){
    return Scaffold(
        backgroundColor: Color(0xfff5f5f5),
        appBar: widget.modal!= "" ? AppBar(
          elevation: 0.0,
          centerTitle: true,
          title: Container(child: Text("SOS", style: normalText5),
          ),
          leading:widget.modal != ""?  InkWell(
              onTap: (){
                Navigator.of(context).pop(false);
              },
              child: Icon(Icons.arrow_back,color: Colors.black54,)):
          InkWell(
            child: Row(children: <Widget>[
              IconButton(
                icon: Image(
                  image: AssetImage("assets/images/nav_icon.png"),
                  height: 22.0,
                  width: 22.0,
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ]),
          ),
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
        ):null,
        body: Stack(
          children: <Widget>[
            ClipPath(

              child: Container(
                decoration: BoxDecoration(
                    color: Color(0xffcbf3eb)
                ),
                height: 200,
              ),
            ),
            CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: <Widget>[

                SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverToBoxAdapter(
                    child:_buildCategoryItem( context),

                  ),
                ),
              ],
            ),
          ],
        )
    );
  }
  TextStyle normalText6 = GoogleFonts.montserrat(
      fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black);

  Widget _emptyOrders() {
    return Center(
      child: Container(


          child: Text('NO RECORD FOUND!')),
    );
  }
  _launchCaller(String s) async {
    var url = "tel:"+s;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  Widget _buildCategoryItem(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return FutureBuilder(
      future: _profiles,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var errorCode = snapshot.data['ErrorCode'];
          var response = snapshot.data['Response']['sos_list'];

          if (errorCode == 0) {
            final double itemHeight =
                (deviceSize.height - kToolbarHeight - 24) / 3;
            final double itemWidth = deviceSize.width / 2;
            return Column(
                children: <Widget>[
                  Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            child: Container(

                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                      height: 120,
                                      width: 120,
                                      child: Image.asset("assets/images/sos_image.png",)),

                                ],
                              ),
                            ),

                          ),
                        ),

                      ]
                  ),

                  GridView.count(
                  shrinkWrap: true,
                   primary: false,
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: (itemWidth / itemHeight),
                  children: List.generate(response.length, (index) {
                    return InkWell(
                      onTap: (){
                        _launchCaller(response[index]['sos_number']);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color:Color(0xff5dd0bc),width: 2)),
                        child: Container(
                        //  height: 180,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  height: 55,
                                  width: 55,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image:
                                      CachedNetworkImageProvider(
                                        response[index]
                                        ['sosIcon'],
                                      ),
                                    ),
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(top: 8,left: 8,bottom: 5,right: 8),
                                child: Text(
                                 response[index]['sos_name'],
                                  textAlign: TextAlign.center,
                                  maxLines: 3,

                                  style: normalText6,),
                              ),

                            ],
                          ),
                        ),

                      ),
                    );
                  })),
                  SizedBox(height: 50,),
                ]
            );
          } else {
            return _emptyOrders();
          }
        }
        else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Container(child: CircularProgressIndicator()));
        } else {
          return Center(child: Container(child: CircularProgressIndicator()));
        }
      },
    );
  }





}