import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaymentSuccessPage extends StatefulWidget {

  String paymentid;

  PaymentSuccessPage({this.paymentid});

  @override
  _PaymentSuccessPageState createState() => _PaymentSuccessPageState(paymentid);
}

class _PaymentSuccessPageState extends State<PaymentSuccessPage> {

  String paymentid;

  _PaymentSuccessPageState(this.paymentid);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        return Navigator.pushReplacementNamed(context, '/dashboard');
      },
      child: Scaffold(
        body: Center(
           child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Container(
                    height: 120,
                    width: 120,
                    child: Image.asset('assets/images/rwa_logo.png'),
                 ),
                 Text("Your payment successfully completed", style: TextStyle(fontSize: 18.0)),
                 SizedBox(height: 10.0),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                      Text("Payment ID:", style: TextStyle(color: Colors.black,fontSize: 18.0)),
                      SizedBox(width: 4.0),
                      Text(paymentid, style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w500))
                   ],
                 ),
                 SizedBox(height: 10.0),
                 Text("Thank you!",style: TextStyle(fontSize: 24.0, letterSpacing: 2.0, fontWeight: FontWeight.bold)),
                SizedBox(height: 10.0),
                GestureDetector(
                  onTap: (){
                     Navigator.pushReplacementNamed(context, '/dashboard');
                  },
                  child: Container(
                     height: MediaQuery.of(context).size.height * 0.07,
                     width: MediaQuery.of(context).size.width * 0.50,
                     alignment: Alignment.center,
                     decoration: BoxDecoration(
                       color: Colors.red,
                       borderRadius: BorderRadius.all(Radius.circular(8.0))
                     ),
                     child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                           SizedBox(width: 5.0),
                           Icon(Icons.arrow_back_sharp, size: 24.0, color: Colors.white),
                           SizedBox(width: MediaQuery.of(context).size.width * 0.12),
                           Text("Back", style: TextStyle(color: Colors.white, fontSize: 20.0))
                        ],
                     ),
                  ),
                )
              ],
           ),
        ),
      ),
    );
  }
}
