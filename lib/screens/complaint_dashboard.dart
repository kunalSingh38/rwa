import 'dart:convert';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class ComplaintDashboardPage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<ComplaintDashboardPage> {
  String user_id = '';
  String member_name = '';
  String member_code = '';
  String mobile = '';
  String member_type = '';
  List<SalesData> chartData = [];
  String api_token = "";
  Future _chapterData;
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
      _chapterData = _getPerformanceData();
    });
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

  Future _getPerformanceData() async {

    final msg = jsonEncode({
      "member_id":user_id,

    });
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $api_token',
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/complaint-acitvity-graph"),
      body: {
        "member_id":user_id,
      },
      headers: headers,
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        chartData = [
          SalesData(


                "Electrician",
              double.parse(
                  data['Response']['electrician'].toString()),
            "Electrician"

          ),
          SalesData(


                "Plumber",
              double.parse(
                  data['Response']['plumber'].toString()),
            "Plumber"
          ),
          SalesData(
              "Severman",
              double.parse(
                  data['Response']['severman'].toString()),
            "Severman"
          ),
          SalesData(


                "Mali",
              double.parse(
                  data['Response']['mali'].toString()),
            "Mali"
          ),
          SalesData(


                "Safai Karamchari",
              double.parse(
                  data['Response']['safai karamchari'].toString()),
            "Safai Karamchari"
          ),
          SalesData(


                "Other",
              double.parse(
                  data['Response']['other'].toString()),
            "Other"
          ),
          SalesData(


               "Street Light",
              double.parse(
                  data['Response']['street light'].toString()),
            "Street Light"
          ),
        ];
      });

      return data;
    } else {
      throw Exception('Something went wrong');
    }
  }
  TextStyle normalText5 = GoogleFonts.montserrat(
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
            child: Text("Complaints", style: normalText5),
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
                    child:_buildCategoryItem(context,deviceSize),

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

  Widget _buildCategoryItem(BuildContext context, Size deviceSize) {

    return Column(
        children: <Widget>[
          Row(
              children: <Widget>[
                Expanded(
                  child: InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, '/add-complaint');
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
                                child: Image.asset("assets/images/forums.png")),
                            SizedBox(height: 15.0),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "File Complaint",
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
                      Navigator.pushNamed(context, '/view-complaint');
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
                                child: Image.asset("assets/images/environment.png",)),
                            SizedBox(height: 15.0),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "View Complaint",
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
         /* Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Container(
                     // height: 180,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(

                              child: Image.asset("assets/images/complaints_graph.png",)),

                        ],
                      ),
                    ),

                  ),
                ),

              ]
          ),*/
          Container(
            width: deviceSize.width,
            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(20.0),
                    bottomLeft: const Radius.circular(20.0),
                    bottomRight: const Radius.circular(20.0),
                    topRight: const Radius.circular(20.0))),
            margin: EdgeInsets.symmetric( vertical: 20),
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
            child: Column(children: [
              /*Container(
                child: Text(
                    "Question Type Wise Analysis (${snapshot.data['question_type_wise'][0]['questiontype_name'].toString()})",
                    style: normalText6),
              ),
              SizedBox(
                height: 10,
              ),*/
              Container(
                  child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      series: <ChartSeries>[
                        BarSeries<SalesData, String>(
                            dataSource: chartData,
                            enableTooltip:true,
                          /*  dataLabelSettings: DataLabelSettings(
                                isVisible: true, showCumulativeValues: true),
                            dataLabelMapper: (SalesData sales, _) =>
                           sales.label.toString(),*/

                            pointColorMapper: (SalesData sales, _) =>
                                Color(0xff5dd0bc),
                            xValueMapper: (SalesData sales, _) => sales.right,
                            yValueMapper: (SalesData sales, _) => sales.wrong,
                            borderRadius: BorderRadius.all(Radius.circular(15))
                        )
                      ]
                  )),

              SizedBox(
                height: 10.0,
              ),
            ]),
          ),
          SizedBox(height: 50,),
        ]
    );



  }
}

class SalesData {
  SalesData( this.right, this.wrong,this.label);
  final String right;
  final double wrong;
  final String label;
}