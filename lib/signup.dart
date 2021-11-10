import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  late String password, email;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<void> signUpWithEmail(String email, String password) async {
    print(_firebaseAuth);
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    print("user added");
  }
  bool show_spinner=false;
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Material(
      child: ModalProgressHUD(
        inAsyncCall: show_spinner,
        child: Container(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 50.0, sigmaY: 50.0),
            child: Container(
              child: Center(
                  child: ListView(
                    padding: EdgeInsets.all(40),
                    children: [
                      SizedBox(
                        height: 100,
                      ),
                      Text(
                        'Signup',
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 50,
                          color: const Color(0xffffffff),
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: size.height*0.07,),
                      Text(
                        'EMAIL ADDRESS',
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 22,
                          color: const Color(0xffffffff),
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: size.height*0.03,),
                      Container(
                        height: 20,
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              email = value;
                            });
                          },
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 17,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter your Email',
                            hintStyle: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 17,
                              color: const Color(0xa6ffffff),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height*0.07,),
                      Text(
                        'PASSWORD',
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 22,
                          color: const Color(0xffffffff),
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: size.height*0.03,),
                      Container(
                        height: 20,
                        width: 250,
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              password = value;
                            });
                          },
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 17,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Set your Password',
                            hintStyle: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 17,
                              color: const Color(0xa6ffffff),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height*0.07,),
                      Center(
                        child: MaterialButton(
                            child: Text(
                              'SIGNUP',
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
                              setState(() {
                                show_spinner=true;
                              });
                              await signUpWithEmail(email, password);
                              Navigator.pushNamed(context, '/profile');
                            }),
                      ),

                    ],
                  )),
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
            ),
          ),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('images/craig.png'),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
