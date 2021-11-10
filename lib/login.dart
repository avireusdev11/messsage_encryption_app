import 'dart:ui';
import 'package:enc/message_page.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enc/user/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late String email,password;
  FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool show_spinner=false;
  Future<void> signIn(String email,String password) async
  {
    print(email+"  "+password);
    try{
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e){
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email);
    prefs.setString('password', password);
    String uid=_firebaseAuth.currentUser!.uid;
    print("uid isn "+uid);
    if(uid!=null)
    {
      Usersclass currentUser=new Usersclass();
      /*await _firestore.collection('users').doc(uid).get().then((user) {
        currentUser.name = user['name'];
        currentUser.photo = user['photourl'];
        currentUser.uid=uid;
        currentUser.phoneNumber=user['phoneNumber'];
      });*/
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Messages(userid: uid,),
          //builder: (context) => messages(userid: uid),
        ),
      );
      //Navigator.pushNamed(context, '/match');
    }
    //Position position=await _determinePosition();
    //print(position.latitude);
  }
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Material(
      child: ModalProgressHUD(
        inAsyncCall: show_spinner,
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
              child: ListView(
                padding: EdgeInsets.all(40),
                children: [
                  SizedBox(height: size.height*0.07,),
                  Text(
                    'Login',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 40,
                      color: Colors.black,
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
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: size.height*0.03,),
                  Container(
                    height: 20,

                    child: TextField(
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
                          color: Colors.black,
                        ),
                      ),
                      onChanged: (value)
                      {
                        setState(() {
                          email=value;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: size.height*0.07,),
                  Text(
                    'PASSWORD',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 22,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: size.height*0.03,),
                  Container(
                    height: 20,
                    child: TextField(
                      onChanged: (value){
                        setState(() {
                          password=value;
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
                  Center(
                    child: MaterialButton(
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
                        color: Color(0xffF24E86),
                        onPressed: () async {
                          setState(() {
                            show_spinner=true;
                          });
                          signIn(email, password);
                        }),),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    Material(
      color: Colors.orange,
      child: Column(
        children: [
          SizedBox(height: 100,),
          Row(children: [
            Text("Email"),
            Container(
              height: 20,
              width: 250,
              child: TextField(
                onChanged: (value)
                {
                  setState(() {
                    email=value;
                  });
                },
                cursorWidth: 20,
                decoration: InputDecoration(
                  hintText: 'Enter your Email',
                ),
              ),
            ),
          ],),
          SizedBox(height: 30,),
          Row(children: [
            Text("Password"),
            Container(
              height: 20,
              width: 250,
              child: TextField(
                onChanged: (value){
                  setState(() {
                    password=value;
                  });
                },
                cursorWidth: 20,
                decoration: InputDecoration(
                  hintText: 'Enter your Password',
                ),
              ),
            ),
          ],),
          SizedBox(height: 30,),
          Row(children: [
            SizedBox(width: 100,),
            MaterialButton(child:Text('Submit'),color: Colors.white,onPressed: (){signIn(email, password);})
          ],)
        ],
      ),
    );
  }
}
