import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../constants.dart';

class PDFView extends StatefulWidget {
  final Object argument;

  const PDFView({Key key, this.argument}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<PDFView> {
  bool _value = false;
  String url = "";
  String name = "";
  bool _loading = false;
  String profile_image = '';
  Future _chapterData;


  @override
  void initState() {
    super.initState();
    var encodedJson = json.encode(widget.argument);
    var data = json.decode(encodedJson);
    url = data['url'];
    name = data['name'];
    //  _getUser();
  }


  Widget htmlList(Size deviceSize) {
    return Container(
      child: SfPdfViewer.network(
        url,
      ),
    );
  }
  TextStyle normalText2 = GoogleFonts.montserrat(
      fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black);
  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Color(0xfff5f5f5),
        appBar:AppBar(
          elevation: 0.0,
          centerTitle: true,
          title: Container(
            child: Text(name, style: normalText2),
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

        body: htmlList( deviceSize)
    );
  }
}
