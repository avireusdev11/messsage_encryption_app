import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enc/message_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late String name;
  late String phoneNumber;
  File? photo;
  Image img = Image(image: AssetImage('images/craig.png'));
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage reference=FirebaseStorage.instance;

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');
    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }

  Future<void> profileSetup(
      File photo,
      String userId,
      String name,
      String phoneNumber
      )async {
    //FirebaseStorage storageUploadTask;

    TaskSnapshot snapshot = await reference
        .ref()
        .child('userPhotos')
        .child(userId)
        .child(userId)
        .putFile(photo)
        .whenComplete(() => null);
    String url = await snapshot.ref.getDownloadURL();
    await firestore.collection('users').doc(userId).set({
      'uid':userId,
      'photourl':url,
      'name':name,
      'phoneNumber':phoneNumber,
      'timestamp':Timestamp.now(),
    });
  }
  Future<void> dialog(var a) async{
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(a),
            elevation: 24.0,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Material(
      child:ListView(
        padding: EdgeInsets.all(40),
        children: [
          Center(
            child: GestureDetector(
              onTap: () async{
                FilePickerResult? result =
                await FilePicker.platform.pickFiles(
                  type: FileType.image,
                );
                if (result != null) {
                  photo = File(result.files.single.path.toString());
                } else {
// User canceled the picker
                }
                setState(() {

                });
              },
              child: ClipOval(
                child: Container(
                  height: size.height*0.25,
                  width: size.height*0.25,
                  child: photo==null? Image(image: AssetImage('images/craig.png'),):Image(image: FileImage(photo!.absolute))

                ),
              ),
            ),
          ),
          SizedBox(height: size.height*0.07,),
          const Text(
            'Name',
            style: TextStyle(
              fontFamily: 'Lato',
              fontSize: 24,
              color: Colors.black,
            ),
            textAlign: TextAlign.left,
          ),
          Container(
            child: TextField(
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
              style: const TextStyle(
                fontFamily: 'Lato',
                fontSize: 17,
                color: Colors.black,
              ),
              decoration: const InputDecoration(
                hintText: 'Enter your Name',
                hintStyle: TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 17,
                  color: Color(0xa6ffffff),
                ),
              ),
            ),
          ),
          SizedBox(height: size.height*0.07,),
          const Text(
            'Number',
            style: TextStyle(
              fontFamily: 'Lato',
              fontSize: 24,
              color: Colors.black,
            ),
            textAlign: TextAlign.left,
          ),
          Container(
            child: TextField(
              onChanged: (value) {
                setState(() {
                  phoneNumber = value;
                });
              },
              style: const TextStyle(
                fontFamily: 'Lato',
                fontSize: 17,
                color: Colors.black,
              ),
              decoration: const InputDecoration(
                hintText: 'Enter your Number',
                hintStyle: TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 17,
                  color: Color(0xa6ffffff),
                ),
              ),
            ),
          ),
          SizedBox(height: size.height*0.04,),
          Center(
            child: MaterialButton(
              color: Color(0xffF24E86),
              onPressed: () async{
                if (photo == null)
                {
                  dialog('please choose a profile picture');
                }
                String uid = _firebaseAuth.currentUser!.uid;
                await profileSetup(photo!.absolute, uid, name, phoneNumber);
                print('donnnnnnneeeeee');
                Navigator.push(context,MaterialPageRoute(builder: (context) => Messages(userid: uid,),),);

              },
              child: const Center(child: Text(
                'Submit',
                style: TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 24,
                  color: Color(0xffffffff),
                ),
                textAlign: TextAlign.left,
              ),),
            ),
          ),
        ],
      )
    );
  }
}
