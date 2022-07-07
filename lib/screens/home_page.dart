import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String user_id = '';
  String member_name = '';
  String member_code = '';
  String mobile = '';
  String member_type = '';
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

    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
        backgroundColor: Color(0xfff5f5f5),
        body: Stack(
          children: <Widget>[
            ClipPath(

              child: Container(
                decoration: BoxDecoration(
                    color: Color(0xffcbf3eb)
                ),
                height: 100,
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
      fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black);

  Widget _buildCategoryItem(BuildContext context) {

      return Column(
          children: <Widget>[
            Row(
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, '/complaint-dashboard');
                      },
                      child: Container(


                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color:Color(0xff5dd0bc),width: 2)),
                        child: Container(
                          height: 180,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  height: 60,
                                  width: 60,
                                  child: Image.asset("assets/images/complaint.png")),
                              SizedBox(height: 15.0),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Complaint",
                                  textAlign: TextAlign.center,
                                  maxLines: 3,

                                style: normalText6,),
                              ),
                            ],
                          ),
                        ),

                      ),
                    ),
                  ),
                  SizedBox(width: 20,),
                  Expanded(
                    child: InkWell(
                      onTap: (){
                          Navigator.pushNamed(context, '/due');

                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color:Color(0xff5dd0bc),width: 2)),
                        child:  Container(
                          height: 180,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  height: 60,
                                  width: 60,
                                  child: Image.asset("assets/images/dues.png",)),
                              SizedBox(height: 15.0),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Dues",
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  style: normalText6,),
                              ),
                            ],
                          ),
                        ),

                      ),
                    ),
                  ),
                ]
            ),

            SizedBox(height: 20,),
            Row(
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, '/sos');

                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color:Color(0xff5dd0bc),width: 2)),
                        child: Container(
                          height: 180,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  height: 60,
                                  width: 60,
                                  child: Image.asset("assets/images/emergency.png",)),
                              SizedBox(height: 15.0),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Emergency No's",
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  style: normalText6,),
                              ),
                            ],
                          ),
                        ),

                      ),
                    ),
                  ),
                  SizedBox(width: 20,),
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, '/member-search');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color:Color(0xff5dd0bc),width: 2)),
                        child:  Container(
                          height: 180,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  height: 60,
                                  width: 60,
                                  child: Image.asset("assets/images/member_search.png",)),
                              SizedBox(height: 15.0),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Member Search",
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  style: normalText6,),
                              ),
                            ],
                          ),
                        ),

                      ),
                    ),
                  ),
                ]
            ),
            SizedBox(height: 20,),
            Row(
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, '/notice-list');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color:Color(0xff5dd0bc),width: 2)),
                        child: Container(
                          height: 180,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  height: 60,
                                  width: 60,
                                  child: Image.asset("assets/images/notice_board.png",)),
                              SizedBox(height: 15.0),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Notice Board",
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  style: normalText6,),
                              ),
                            ],
                          ),
                        ),

                      ),
                    ),
                  ),
                  SizedBox(width: 20,),
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, '/documents');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color:Color(0xff5dd0bc),width: 2)),
                        child:  Container(
                          height: 180,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  height: 60,
                                  width: 60,
                                  child: Image.asset("assets/images/docs.png",)),
                              SizedBox(height: 15.0),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Documents",
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  style: normalText6,),
                              ),
                            ],
                          ),
                        ),

                      ),
                    ),
                  ),
                ]
            ),

            SizedBox(height: 20,),
            Row(
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, '/subscription-list');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color:Color(0xff5dd0bc),width: 2)),
                        child: Container(
                          height: 180,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  height: 60,
                                  width: 60,
                                  child: Image.asset("assets/images/receipt_list.png",)),
                              SizedBox(height: 15.0),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Payment Receipt",
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  style: normalText6,),
                              ),
                            ],
                          ),
                        ),

                      ),
                    ),
                  ),
                  SizedBox(width: 20,),
                  Expanded(
                    child: Container(),
                  ),
                ]
            ),

            SizedBox(height: 50,),
          ]
      );



  }




}