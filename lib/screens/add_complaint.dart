import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
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

class AddComplaint extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<AddComplaint> {
  String user_id = '';
  String member_name = '';
  String member_code = '';
  String mobile = '';
  String member_type = '';
  Future<dynamic> _profiles;
  List<Region> _region = [];
  List<Region2> _region2 = [];
  var _type="";
  var _type2="";
  String selectedRegion;
  String selectedRegion2;
  String catData = "";
  String catData2 = "";
  Future _activityData;
  Future _categoryData;
  bool _loading = false;
  String urgent="on";
  final DateController = TextEditingController();
  bool isSwitched = false;
  String api_token = "";

  String instruction = "";

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
      var formatter = new DateFormat('dd-MMM-yyyy');
      var now = new DateTime.now();
      String formatted = formatter.format(now);
      print(formatted);
      DateController.text = formatted.toString();
      _profiles = _getActivityCategories();
    });
  }

  Future _getActivityCategories() async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $api_token',
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/complaint-list"),
      body: {
        "member_id":user_id,
        "from_date":"",
        "to_date":"",
        "search":""
      },
      headers: headers,
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var result = data['Response']['activityList'];
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

                print(selectedRegion);
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

  void dispose() {
    DateController.dispose();


    super.dispose();
  }
  Future _getCategories(String type) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $api_token',
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/activity-category"),
      body: {
        "activity_id":_type
      },
      headers: headers,
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var result = data['Response']['category'];
      if (mounted) {
        setState(() {
          catData2 = jsonEncode(result);

          final json = JsonDecoder().convert(catData2);
          _region2 =
              (json).map<Region2>((item) => Region2.fromJson(item)).toList();
          List<String> item = _region2.map((Region2 map) {
            for (int i = 0; i < _region2.length; i++) {
              if (selectedRegion2 == map.THIRD_LEVEL_NAME) {
                _type2 = map.THIRD_LEVEL_ID;
                if (selectedRegion2 == "" || selectedRegion2 == null) {
                  selectedRegion2 = _region2[0].THIRD_LEVEL_ID;
                }
              }
            }
          }).toList();
         /* selectedRegion2 = _region2[0].THIRD_LEVEL_NAME;
          _type2 = _region2[0].THIRD_LEVEL_ID;*/
        });
      }

      return result;
    } else {
      throw Exception('Something went wrong');
    }
  }

  TextStyle normalText5 = GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black);

  @override
  Widget build(BuildContext context){
    return Scaffold(
        extendBody: true,
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xfff5f5f5),
        appBar:AppBar(
          elevation: 0.0,
          centerTitle: true,
          title: Container(
            child: Text("File Complaint", style: normalText5),
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
        body: SingleChildScrollView(
          child: Container(
              decoration: BoxDecoration(
                  color: Color(0xfff5f5f5)
              ),
              child: _buildCategoryItem(),
          ),
        ),

    );
  }
  TextStyle normalText6 = GoogleFonts.montserrat(
      fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black);
  TextStyle normalText1 = GoogleFonts.montserrat(
      fontSize: 15, fontWeight: FontWeight.w300, color: Colors.black54);
  File _image;

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _image = image;
    });
  }
  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              color: Color(0xff54d3c0),
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(
                        Icons.photo_library,
                        color: Colors.white,
                      ),
                      title: new Text(
                        'Photo Library',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(
                      Icons.photo_camera,
                      color: Colors.white,
                    ),
                    title: new Text(
                      'Camera',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
  Widget _buildCategoryItem() {

    return FutureBuilder(
      future: _profiles,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var errorCode = snapshot.data['ErrorCode'];
          var response = snapshot.data;
          if (errorCode == 0) {

            return  ModalProgressHUD(
              inAsyncCall: _loading,
              child: Container(
                margin: EdgeInsets.only(right: 15.0, left: 15, top: 20),
                child: Column(children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      child: Text(
                        "Complaint No.",
                        textAlign: TextAlign.left,
                        style: normalText1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5.0),

                  Container(
                    child: TextFormField(
                        enabled: false,
                        initialValue: response['receipt_no'].toString(),
                        keyboardType: TextInputType.text,
                        cursorColor: Color(0xff000000),
                        style: normalText6,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                            suffixIcon: InkWell(
                              onTap: () {},
                              child: Icon(Icons.format_list_numbered, color: Colors.black54),
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
                        "Date",
                        textAlign: TextAlign.left,
                        style: normalText1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5.0),

                  Container(
                    child: TextFormField(
                        enabled: false,
                        controller: DateController,
                        keyboardType: TextInputType.text,
                        cursorColor: Color(0xff000000),
                        style: normalText6,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                            suffixIcon: InkWell(
                              onTap: () {},
                              child: Icon(Icons.date_range, color: Colors.black54),
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
                        "Activity",
                        textAlign: TextAlign.left,
                        style: normalText1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5.0),
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
                            "Select Activity",
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


                                _categoryData=_getCategories(_type);
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


                  const SizedBox(height: 15.0),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(

                      child: Text(
                        "Activity Category",
                        textAlign: TextAlign.left,
                        style: normalText1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5.0),
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
                            "Select Activity Category",
                            style: TextStyle(color: Color(0xffBBBFC3)),
                          ),
                          icon: Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                            ),
                          ),
                          value: selectedRegion2,
                          isDense: true,
                          onChanged: (newValue) {
                            setState(() {
                              selectedRegion2 = newValue;
                                List<String> item = _region2.map((Region2 map) {
                          for (int i = 0; i < _region2.length; i++) {
                            if (selectedRegion2 == map.THIRD_LEVEL_NAME) {
                              _type2 = map.THIRD_LEVEL_ID;
                              return map.THIRD_LEVEL_ID;
                            }
                          }
                        }).toList();
                            });
                          },
                          items: _region2.map((Region2 map) {
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
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      child: Text(
                        "Instruction",
                        textAlign: TextAlign.left,
                          style: normalText1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Container(
                    height: 45.0,
                    padding: EdgeInsets.only(left: 10.0, bottom: 3.0),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1.0,
                          color: Color(0xffDFDFDF),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                    ),
                    child: TextField(
                       decoration: InputDecoration(
                         border: InputBorder.none,
                         hintText: 'Instruction',
                       ),
                      onChanged: (value){
                          setState(() {
                            instruction = value;
                          });
                      },
                    )
                  ),

                  const SizedBox(height: 15.0),
                  Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text("Add Attachment", style: normalText6)),
                  const SizedBox(height: 5.0),
                  InkWell(
                      onTap: () {
                        _showPicker(context);
                      },
                      child: _image == null
                          ? Align(
                        alignment: Alignment.topRight,
                            child: Container(
                            width: 30,
                            height: 30,
                            child: Image.asset("assets/images/attached.png",)),
                          )
                          : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          _image,
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        ),
                      )),

                  const SizedBox(height: 15.0),
                  Container(
                        margin: EdgeInsets.only(left: 15,right: 15),
                        padding: EdgeInsets.symmetric(vertical: 5),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Container(

                                  child: Text(
                                    "Is it Urgent?",
                                    textAlign: TextAlign.left,
                                    style: normalText1,
                                  ),
                                ),
                              ),
                            ),

                             Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Switch(
                                  value: isSwitched,
                                  onChanged: (value){
                                    setState(() {
                                      isSwitched=value;
                                      print(isSwitched);
                                      if(isSwitched==true){
                                        setState(() {
                                          urgent="on";
                                        });
                                      }
                                      else{
                                        setState(() {
                                          urgent="";
                                        });
                                      }
                                    });
                                  },
                                  activeTrackColor: Color(0xfff9533d),
                                  activeColor: Color(0xff5ab1e9),
                                ),
                              ),

                          ],
                        ),
                      ),
                  const SizedBox(height: 30.0),
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

                          if (_image != null) {
                            setState(() {
                              _loading = true;
                            });

                            var uri = Uri.parse(
                                URL + 'complaint-create');
                            final uploadRequest = http.MultipartRequest(
                                'POST', uri);
                            final mimeTypeData =
                            lookupMimeType(_image.path, headerBytes: [0xFF, 0xD8])
                                .split('/');

                            final file = await http.MultipartFile.fromPath('complaint_image', _image.path,
                                contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
                            uploadRequest.files.add(file);
                            uploadRequest.fields['member_id'] = user_id;
                            uploadRequest.fields['complaint_no'] = response['receipt_no'].toString();
                            uploadRequest.fields['activity'] = _type;
                            uploadRequest.fields['description'] = selectedRegion2;
                            uploadRequest.fields['special_care'] = urgent;
                            uploadRequest.fields['instruction'] = instruction;

                            print(uploadRequest.fields);
                            try {
                              final streamedResponse = await uploadRequest.send();
                              final response =
                              await http.Response.fromStream(streamedResponse);
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
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, '/view-complaint');
                                  Fluttertoast.showToast(msg: errorMessage);


                                } else {
                                  setState(() {
                                    _loading = false;
                                  });
                                  showAlertDialog(
                                      context, ALERT_DIALOG_TITLE, errorMessage);
                                }
                              }
                            } catch (e) {
                              print(e);
                            }
                          }
                          else {
                            setState(() {
                              _loading = true;
                            });

                            var uri = Uri.parse(
                                URL + 'complaint-create');
                            final uploadRequest = http.MultipartRequest(
                                'POST', uri);


                            uploadRequest.fields['member_id'] = user_id;
                            uploadRequest.fields['complaint_no'] = response['receipt_no'].toString();
                            uploadRequest.fields['activity'] =
                                _type;
                            uploadRequest.fields['description'] = selectedRegion2;
                            uploadRequest.fields['special_care'] = urgent;

                            print(uploadRequest.fields);
                            try {
                              final streamedResponse = await uploadRequest.send();
                              final response =
                              await http.Response.fromStream(streamedResponse);
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
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, '/view-complaint');
                                  Fluttertoast.showToast(msg: errorMessage);
                                } else {
                                  setState(() {
                                    _loading = false;
                                  });
                                  showAlertDialog(
                                      context, ALERT_DIALOG_TITLE, errorMessage);
                                }
                              }
                            } catch (e) {
                              print(e);
                            }
                          }

                        },
                        child: Text(
                          "Save Complaint",
                          style: TextStyle(fontSize: 16, letterSpacing: 1,fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20.0),
                ]),
              ),
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




}
class Region {
  final String THIRD_LEVEL_ID;
  final String THIRD_LEVEL_NAME;

  Region({ this.THIRD_LEVEL_ID,  this.THIRD_LEVEL_NAME});

  factory Region.fromJson(Map<String, dynamic> json) {
    return new Region(
        THIRD_LEVEL_ID: json['id'].toString(),
        THIRD_LEVEL_NAME: json['activity_desc']);
  }
}
class Region2 {
  final String THIRD_LEVEL_ID;
  final String THIRD_LEVEL_NAME;

  Region2({ this.THIRD_LEVEL_ID,  this.THIRD_LEVEL_NAME});


  factory Region2.fromJson(Map<String, dynamic> json) {
    return new Region2(
      THIRD_LEVEL_ID: json['id'].toString(),
      THIRD_LEVEL_NAME: json['name'],
    );
  }
}