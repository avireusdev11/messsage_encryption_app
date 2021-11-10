import 'dart:ui';

import 'package:flutter/material.dart';
class First_page extends StatefulWidget {


  @override
  _First_pageState createState() => _First_pageState();
}

class _First_pageState extends State<First_page> {
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Material(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('images/craig.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 50.0, sigmaY: 50.0),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: size.height*0.4,),
                MaterialButton(
                    child: Text(
                      'New User?SIGNUP',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 13,
                        color: const Color(0xffffffff),
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    color: Color(0xffF24E86),
                    onPressed: () async {
                      Navigator.pushNamed(context, '/reg');
                    }),
                MaterialButton(
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 13,
                        color: const Color(0xffffffff),
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    color: Color(0xff2A4755),
                    onPressed: () async {
                      Navigator.pushNamed(context, '/login');
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}