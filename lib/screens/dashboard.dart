import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:async';
import 'dart:io' as Io;
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_version/new_version.dart';
import 'package:rwa/components/tab_item.dart';
import 'package:rwa/screens/profile.dart';
import 'package:rwa/screens/sos.dart';
import 'package:rwa/services/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import 'home_page.dart';


class Dashboard extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}



class _MainScreenState extends State<Dashboard> {
  int selectedPosition = 0;
  String user_id = '';
  String member_name = '';
  String member_code = '';
  String mobile = '';
  String member_type = '';
  String house_number = '';
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  AndroidNotificationChannel channel;
  void initState() {
    super.initState();
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.high,
    );
    _requestPermissions();
    _getUser();

    final newVersion = NewVersion(
      //iOSId: 'com.google.Vespa',
      androidId: 'com.avrwa.rwa',
    );

    const simpleBehavior = false;

    if (simpleBehavior) {
      basicStatusCheck(newVersion);
    } else {
      advancedStatusCheck(newVersion);
    }
  }

  basicStatusCheck(NewVersion newVersion) {
    newVersion.showAlertIfNecessary(context: context);
  }

  advancedStatusCheck(NewVersion newVersion) async {
    final status = await newVersion.getVersionStatus();
    if (status != null) {
      print(status.releaseNotes);
      print(status.appStoreLink);
      print(status.localVersion);
      print(status.storeVersion);
      debugPrint(status.canUpdate.toString());
      if(status.localVersion != status.storeVersion){
        newVersion.showUpdateDialog(
          context: context,
          versionStatus: status,
          allowDismissal: false,
          dialogTitle: 'Update Available',
          dialogText: 'You can now update this app from ${status.localVersion.toString()} to ${status.storeVersion.toString()}',
        );
      }
      else{}

    }
  }

  void _requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  Future<Uint8List> _getByteArrayFromUrl(String url) async {
    final http.Response response = await http.get(Uri.parse(url));
    return response.bodyBytes;
  }
  showNotification() async {

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        print('hhhhhhhhhhhh');

        /*Navigator.pushNamed(context, '/message',
            arguments: MessageArguments(message, true));*/
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async{
      RemoteNotification notification = message.notification;
      var data = message.data;

      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {


        final ByteArrayAndroidBitmap bigPicture = ByteArrayAndroidBitmap(
            await _getByteArrayFromUrl(data['bigPicture']));

        final BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(
            bigPicture,
            largeIcon: DrawableResourceAndroidBitmap("ic_launcher"),
            contentTitle: notification.title,
            htmlFormatContentTitle: true,
            summaryText: notification.body,
            htmlFormatSummaryText: true);
        final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails( channel.id,
            channel.name,
            channel.description,
            icon: '@mipmap/ic_launcher',

            fullScreenIntent: true,
            /* importance: Importance.max,
      priority: Priority.high,*/
            ongoing: false,
            styleInformation: bigPictureStyleInformation);
        final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            platformChannelSpecifics,

            payload:""

        );
       /* if(data['moredata']=="payment") {
          Navigator.pushNamed(
            context,
            '/plan',
            arguments: <String, String>{
              'order_id': order_id.toString(),
              'signupid': user_id.toString(),
              'mobile': mobile_no,
              'email': email_id,
              'out': 'in'
            },
          );
        }
        else if(data['moredata']=="model test paper"){
          Navigator.pushNamed(
            context,
            '/mts',
          );
        }
        else if(data['moredata']=="test"){
          Navigator.pushNamed(
            context,
            '/test-list',
            arguments: <String, String>{
              'chapter_id': "",
              'chapter_name': "",
              'type': "outside"
            },
          );
        }
        else if(data['moredata']=="institute"){
          Navigator.pushNamed(
            context,
            '/institute-test-list',

          );
        }
        else{
          Navigator.pushNamed(context, '/dashboard');
        }*/
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      RemoteNotification notification = message.notification;
      var data = message.data;
     /* print(data);
      print("wffewf");
      print(notification.body);

      print(data['moredata']);
      print(data['bigPicture']);*/

      final ByteArrayAndroidBitmap bigPicture = ByteArrayAndroidBitmap(
          await _getByteArrayFromUrl(data['bigPicture']));
      final BigPictureStyleInformation bigPictureStyleInformation =
      BigPictureStyleInformation(
          bigPicture,
          largeIcon: DrawableResourceAndroidBitmap("ic_launcher"),
          contentTitle: notification.title,
          htmlFormatContentTitle: true,
          summaryText: notification.body,
          htmlFormatSummaryText: true);
      final AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails( channel.id,
          channel.name,
          channel.description,
          icon: '@mipmap/ic_launcher',

          fullScreenIntent: true,
          // importance: Importance.max,
          // priority: Priority.high,
          ongoing: false,
          styleInformation: bigPictureStyleInformation);
      final NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          platformChannelSpecifics
          ,

          payload:""

      );
     /* if(data['moredata']=="payment") {
        Navigator.pushNamed(
          context,
          '/plan',
          arguments: <String, String>{
            'order_id': order_id.toString(),
            'signupid': user_id.toString(),
            'mobile': mobile_no,
            'email': email_id,
            'out': 'in'
          },
        );
      }
      else if(data['moredata']=="model test paper"){
        Navigator.pushNamed(
          context,
          '/mts',
        );
      }
      else if(data['moredata']=="test"){
        Navigator.pushNamed(
          context,
          '/test-list',
          arguments: <String, String>{
            'chapter_id': "",
            'chapter_name': "",
            'type': "outside"
          },
        );
      }
      else{
        Navigator.pushNamed(context, '/dashboard');
      }
*/
    });
  }
  _getUser() async {
    Preference().getPreferences().then((prefs) {
      setState(() {
        user_id = prefs.getString('user_id').toString();
        member_name = prefs.getString('member_name').toString();
        member_code = prefs.getString('member_code').toString();
        mobile = prefs.getString('mobile').toString();
        member_type = prefs.getString('member_type').toString();
        house_number = prefs.getString('house_number').toString();

      });
    });
  }



  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text(
          "Are you sure",
        ),
        content: new Text("Do you want to exit the App"),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text(
              "No",
              style: TextStyle(
                color: Color(0xff54d3c0),
              ),
            ),
          ),
          new FlatButton(
            onPressed: () {
              exit(0);
            },
            child:
            new Text("Yes", style: TextStyle(color: Color(0xff54d3c0))),
          ),
        ],
      ),
    )) ??
        false;
  }

  TextStyle normalText5 = GoogleFonts.montserrat(
      fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<bool> _logoutPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text(
          "Are you sure",
        ),
        content: new Text("Do you want to Log Out?"),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text(
              "No",
              style: TextStyle(
                color: Color(0xff223834),
              ),
            ),
          ),
          new FlatButton(
            onPressed: () async {
              SharedPreferences prefs =
              await SharedPreferences.getInstance();
              //prefs.remove('logged_in');
              setState(() {
                prefs.clear();
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/login');
              });
            },
            child:
            new Text("Yes", style: TextStyle(color: Color(0xff223834))),
          ),
        ],
      ),
    )) ??
        false;
  }




  buildUserInfo(context) => Container(
    color:  Color(0xfff5f5f5),
    padding: EdgeInsets.only(bottom: 25.0, left: 30, top: 50),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: Icon(
                Icons.clear,
                size: 20.0,
                color: Colors.black,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xffffffff),
              image: DecorationImage(
                image: AssetImage("assets/images/rwa_logo.png"),
                fit: BoxFit.cover,
              ),

            ),
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        Row(
            mainAxisSize: MainAxisSize.max,

            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Hello, " ,
                  maxLines: 2,
                  softWrap: true,
                  overflow:
                  TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),

              ),



            ]),
        SizedBox(
          height: 5.0,
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            member_name,
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w300,
              color: Colors.black,
            ),
          ),
        ),
      ],
    ),
  );
  TextStyle normalText6 = GoogleFonts.montserrat(
      fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black);




  Widget buildDrawerItem() {
    return Flexible(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10),
        child:

        SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              for (Draw item in drawerItems)
                InkWell(
                  onTap: () {
                    if (item.title == "Change password") {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/change-password');
                    }
                   else if (item.title == "Home") {
                      Navigator.pop(context);
                    }
                    else if (item.title == "Profile") {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/profile');
                    }
                    else if (item.title == "Complaints") {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/complaint-dashboard');
                    }
                    else if (item.title == "Dues") {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/due');
                    }
                    else if (item.title == "Notice board") {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/notice-list');
                    }
                    else if (item.title == "Member search") {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/member-search');
                    }
                    else if (item.title == "Emergency no.") {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/sos');
                    }
                  },
                  child: ListTile(
                    leading: Text(
                      item.title,
                      style: normalText6,
                    ),
                  ),
                ),



              Container(
                margin: EdgeInsets.only(bottom: 60),
                child: InkWell(
                  onTap: () async {
                    _logoutPop();
                  },
                  child: ListTile(
                    leading: Image.asset(
                      "assets/images/log_out.png",
                      color: Colors.black,
                      height: 20,
                    ),
                    title: Text(
                      'LogOut',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),



      ),
    );
  }

   _name() {
    if (selectedPosition == 0) {
      return Container(
        child: Text(member_name+"("+house_number+")", style: normalText5),
      );
    } else if (selectedPosition == 1) {
      return Container(
        child: Text("My Profile", style: normalText5),
      );
    } else if (selectedPosition == 2) {
      return Container(
        child: Text("SOS", style: normalText5),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        extendBody: true,
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              buildUserInfo(context),
              buildDrawerItem(),
            ],
          ),
        ),
        appBar:AppBar(
          elevation: 0.0,

          leading: InkWell(
            child: Row(children: <Widget>[
              IconButton(
                icon: Image(
                  image: AssetImage("assets/images/nav_icon.png"),
                  height: 22.0,
                  width: 22.0,
                ),
                onPressed: () {
                  _scaffoldKey.currentState.openDrawer();
                },
              ),
            ]),
          ),
          centerTitle: true,
          title: _name(),
          flexibleSpace: Container(
            height: 100,
            color: Color(0xffcbf3eb),
          ),
          actions: <Widget>[
            SizedBox(
              width: 26,
              height: 26,
              child: Image.asset("assets/images/rwa_logo.png"),
            ),
            IconButton(
              icon: const Icon(
                Icons.notifications_none,
                color: Colors.black,
                size: 24,
              ),
              onPressed: () {
                Navigator.pushNamed(
                    context,
                    '/notification-list');
              },
            )
          ],
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          backgroundColor: Colors.transparent,
        ),

        bottomNavigationBar: _buildBottomTab(),
        body: _children[selectedPosition],
      ),
    );
  }

  final List<Widget> _children = [
    HomePage(),
    ProfilePage(""),
    SOS(""),
  ];

  _buildBottomTab() {
    return Container(
      height: kBottomNavigationBarHeight,
      width: MediaQuery.of(context).size.width,
      child: BottomAppBar(
        color: Colors.white,
        notchMargin: 6,
        elevation: 0.0,
        shape: CircularNotchedRectangle(),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[

              TabItem(
                icon: "assets/images/home.png",
                dot: "Home",
                isSelected: selectedPosition == 0,
                onTap: () {
                  setState(() {
                    selectedPosition = 0;
                  });
                },
                key:UniqueKey(),
              ),
              TabItem(
                icon: "assets/images/profile.png",
                dot: "Profile",
                isSelected: selectedPosition == 1,
                onTap: () {
                  setState(() {
                    selectedPosition = 1;
                  });
                },
                key:UniqueKey(),
              ),
              TabItem(
                icon: "assets/images/phone.png",
                dot: "SOS",
                isSelected: selectedPosition == 2,
                onTap: () {
                  setState(() {
                    selectedPosition = 2;
                  });
                },
                key:UniqueKey(),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
