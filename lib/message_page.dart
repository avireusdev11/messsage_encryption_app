import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enc/chat_widget.dart';
import 'package:enc/user/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';

class Messages extends StatefulWidget {
  final String? userid;
  Messages({this.userid});

  @override
  _MessagesState createState() => _MessagesState();
}
class chat_pair{
  String id;
  Timestamp timestamp;
  chat_pair({required this.id,required this.timestamp});
}

class _MessagesState extends State<Messages> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<Usersclass> getCurrentUser(String userid) async
  {
    Usersclass currentUser=new Usersclass();
    await _firestore.collection('users').doc(userid).get().then((user) {
      currentUser.name = user['name'];
      currentUser.photo = user['photourl'];
    });
    return currentUser;
  }

  getList() async
  {
    List<chat_pair> chatList = [];
    await _firestore.collection('users')
        .get()
        .then((document) {
      for (var doc in document.docs) {
        print('jjjjj'+doc['timestamp'].toString());
        if (document.docs != null && doc.id!=widget.userid) {
          chat_pair c=chat_pair(id: doc.id,timestamp: doc['timestamp']);
          chatList.add(c);

        }
      }
    });
    print(chatList);
    return chatList;
  }


  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blueAccent,title: const Text('Chats'),actions: [MaterialButton(child: Icon(Icons.admin_panel_settings),onPressed: (){
        screenLock(
          context: context,
          correctString: '1234',
        );

      },)],),
      body:FutureBuilder(future: getList(),builder: (context,snapshot){
        if(snapshot.data!=null)
          {
            List<chat_pair> ch=snapshot.data as List<chat_pair>;
            return ListView.builder(scrollDirection:Axis.vertical,itemCount: ch.length,itemBuilder: (BuildContext context, int index){
              return GestureDetector(
                child: ChatWidget(
                  userId: widget.userid.toString(),
                  selectedUserId: ch[index].id,
                  creationTime: ch[index].timestamp,
                ),
              );
            });
          }
        else{
          return Column(
            children: [
              Container(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.orange,
                  strokeWidth: 10,
                ),
                height: size.height/2,
                width: size.width,
              ),
            ],
          );
        }
      })
    );
  }
}
