import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rwa/screens/add_complaint.dart';
import 'package:rwa/screens/billing_details.dart';
import 'package:rwa/screens/change_password.dart';
import 'package:rwa/screens/complaint_dashboard.dart';
import 'package:rwa/screens/complaint_details.dart';
import 'package:rwa/screens/dashboard.dart';
import 'package:rwa/screens/documents.dart';
import 'package:rwa/screens/due.dart';
import 'package:rwa/screens/edit_profile.dart';
import 'package:rwa/screens/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rwa/screens/login.dart';
import 'package:rwa/screens/member_search.dart';
import 'package:rwa/screens/new_complaint.dart';
import 'package:rwa/screens/notice_list.dart';
import 'package:rwa/screens/notification_list.dart';
import 'package:rwa/screens/payment_success_page.dart';
import 'package:rwa/screens/profile.dart';
import 'package:rwa/screens/sos.dart';
import 'package:rwa/screens/subscription_list.dart';
import 'package:rwa/screens/view_complaint.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/pdf_view.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _loggedIn = false;
  int id = 0;

  void initState() {
    super.initState();

    _checkLoggedIn();
  }

  Map<int, Color> color =
  {
    50:Color.fromRGBO(136,14,79, .1),
    100:Color.fromRGBO(136,14,79, .2),
    200:Color.fromRGBO(136,14,79, .3),
    300:Color.fromRGBO(136,14,79, .4),
    400:Color.fromRGBO(136,14,79, .5),
    500:Color.fromRGBO(136,14,79, .6),
    600:Color.fromRGBO(136,14,79, .7),
    700:Color.fromRGBO(136,14,79, .8),
    800:Color.fromRGBO(136,14,79, .9),
    900:Color.fromRGBO(136,14,79, 1),
  };

  _checkLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var _isLoggedIn = prefs.getBool('logged_in');
    if (_isLoggedIn == true) {
      setState(() {
        _loggedIn = _isLoggedIn;
      });
    } else {
      setState(() {
        _loggedIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    MaterialColor colorCustom = MaterialColor(0xff54d3c0, color);
    return MaterialApp(
      title: 'AVRWA',
      theme: ThemeData(
        primarySwatch:colorCustom,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return PageTransition(
              child: Login(),
              type: PageTransitionType.fade,
              settings: settings,
            );
            break;
          case '/dashboard':
            return PageTransition(
              child: Dashboard(),
              type: PageTransitionType.fade,
              settings: settings,
            );
            break;

          case '/home_page':
            return PageTransition(
              child: HomePage(),
              type: PageTransitionType.fade,
              settings: settings,
            );
            break;

          case '/change-password':
            return PageTransition(
              child: ChangePassword(),
              type: PageTransitionType.fade,
              settings: settings,
            );
            break;

          case '/profile':
            return PageTransition(
              child: ProfilePage("yes"),
              type: PageTransitionType.fade,
              settings: settings,
            );
            break;

          case '/edit-profile':
            return PageTransition(
              child: EditProfilePage(),
              type: PageTransitionType.fade,
              settings: settings,
            );
            break;

          case '/complaint-dashboard':
            return PageTransition(
              child: ComplaintDashboardPage(),
              type: PageTransitionType.fade,
              settings: settings,
            );
            break;

          case '/add-complaint':
            return PageTransition(
              child: AddComplaint(),
              type: PageTransitionType.fade,
              settings: settings,
            );
            break;

          case '/file-complaint':
            return PageTransition(
              child: FileComplaint(),
              type: PageTransitionType.fade,
              settings: settings,
            );
            break;
          case '/view-complaint':
            return PageTransition(
              child: ViewComplaint(),
              type: PageTransitionType.fade,
              settings: settings,
            );
            break;
          case '/due':
            return PageTransition(
              child: Dues(),
              type: PageTransitionType.fade,
              settings: settings,
            );
            break;
          case '/notice-list':
            return PageTransition(
              child: NoticeList(),
              type: PageTransitionType.fade,
              settings: settings,
            );
            break;

          case '/member-search':
            return PageTransition(
              child: MemberPage(),
              type: PageTransitionType.fade,
              settings: settings,
            );
            break;
          case '/sos':
            return PageTransition(
              child: SOS("yes"),
              type: PageTransitionType.fade,
              settings: settings,
            );
            break;
          case '/documents':
            return PageTransition(
              child: DocumentsList(),
              type: PageTransitionType.fade,
              settings: settings,
            );
            break;
          case '/notification-list':
            return PageTransition(
              child: NotificationsList(),
              type: PageTransitionType.fade,
              settings: settings,
            );
            break;
          case '/billing-details':
            return PageTransition(
              child: BillingDetails(),
              type: PageTransitionType.fade,
              settings: settings,
            );
            break;

          case '/subscription-list':
            return PageTransition(
              child: ViewSubscription(),
              type: PageTransitionType.fade,
              settings: settings,
            );
            break;

          case '/complaint-details':
            var obj = settings.arguments;
            return PageTransition(
              child: ComplaintDetails(argument: obj),
              type: PageTransitionType.fade,
              settings: settings,
            );
            break;
          case '/pdf-view':
            var obj = settings.arguments;
            return PageTransition(
              child: PDFView(argument: obj),
              type: PageTransitionType.fade,
              settings: settings,
            );
            break;
          default:
            return null;
        }
      },
      home: Scaffold(
        body: homeOrLog(),
      ),
    );

  }

  Widget homeOrLog() {
    if (this._loggedIn) {
      return Dashboard();
    }
    else{
      return Login();
    }

  }
}
