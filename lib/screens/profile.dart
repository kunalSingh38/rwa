import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

class ProfilePage extends StatefulWidget {
  final String modal;

  ProfilePage(this.modal);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<ProfilePage> {
  String user_id = '';
  String member_name = '';
  String member_code = '';
  String mobile = '';
  String member_type = '';
  String house_number = '';
   Future<dynamic> _profiles;
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final memberIdController = TextEditingController();
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
      house_number = prefs.getString('house_number').toString();
      api_token = prefs.getString('api_token').toString();
      _profiles = _profileData();
    });
  }
  Future _profileData() async {

    final msg = jsonEncode({
      "member_id":user_id.toString()
    });
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $api_token',
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/dashboard"),
      body: {
        "member_id":user_id.toString()
      },
      headers: headers,
    );
     print(msg);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Something went wrong');
    }
  }

  TextStyle normalText5 = GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfff5f5f5),
        appBar:widget.modal != ""?AppBar(
          elevation: 0.0,
          centerTitle: true,
          title: Container(
            child: Text("Profile", style: normalText5),
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
                decoration: BoxDecoration(color: Color(0xffcbf3eb)),
                height: 130,
              ),
            ),
            CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: <Widget>[
                SliverPadding(
                  padding:
                      const EdgeInsets.only(left: 16, bottom: 16, right: 16),
                  sliver: SliverToBoxAdapter(
                    child: _buildCategoryItem(context),
                  ),
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
    return FutureBuilder(
      future: _profiles,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var errorCode = snapshot.data['ErrorCode'];
          var response = snapshot.data['userData'];
          if (errorCode == 0) {

            return  Container(
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
                      enabled: false,
                      initialValue: response['member_name'],
                      keyboardType: TextInputType.text,
                      cursorColor: Color(0xff000000),
                      style: normalText6,
                      textCapitalization: TextCapitalization.sentences,
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
                      enabled: false,
                      initialValue: response['email']??'',
                      keyboardType: TextInputType.text,
                      cursorColor: Color(0xff000000),
                      style: normalText6,
                      textCapitalization: TextCapitalization.sentences,
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
                      enabled: false,
                      initialValue: response['mobile']??'',
                      keyboardType: TextInputType.text,
                      cursorColor: Color(0xff000000),
                      style: normalText6,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                          suffixIcon: InkWell(
                            onTap: () {},
                            child: Icon(Icons.phone_android, color: Colors.black54),
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
          const SizedBox(height: 4.0),

          Text(
            house_number,
            style: TextStyle(
              fontSize: 17.0,
              color: Colors.black87,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 4.0),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: ()  {
                Navigator.pushNamed(
                  context,
                  '/edit-profile',
                );
              },
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: 5, horizontal: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Color(0xff54d3c0)

                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Edit",
                        // snapshot.data['cart_quantity'] > 0 ? 'Go to Basket' : 'Add to Basket',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
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
              width: 80,
              height: 80,
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
      profileList(height)
    ]);
  }
}
