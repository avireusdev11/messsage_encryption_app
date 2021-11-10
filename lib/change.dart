import 'package:flutter/material.dart' hide Key;
import 'package:encrypt/encrypt.dart';
class Change extends StatefulWidget {
  final iv = IV.fromLength(16);
  final encrypter = Encrypter(AES(Key.fromLength(32)));
  @override
  _ChangeState createState() => _ChangeState();
}

class _ChangeState extends State<Change> {
  late String text;
  String etext='Encrypted Text is';
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          TextField(
            onChanged: (tex){
              setState(() {
                text=tex;
              });
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black),borderRadius: BorderRadius.all(Radius.circular(4))),
            ),
          ),
          const SizedBox(height: 30,),
          Text(etext,style: const TextStyle(fontSize: 8,fontWeight: FontWeight.bold),),
          const SizedBox(height: 30,),
          MaterialButton(
            onPressed: () {
              setState(() {
                etext= etext+' '+widget.encrypter.encrypt(text, iv: widget.iv).base64;
              });
            },
            child: const Text('Encrypt'),
          ),
        ],
      ),
    );
  }
}

