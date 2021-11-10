import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enc/messaging_page.dart';
import 'package:enc/photo_widget.dart';
import 'package:enc/user/chat.dart';
import 'package:enc/user/message.dart';
import 'package:enc/user/user.dart';
import 'package:flutter/material.dart';
class ChatWidget extends StatefulWidget {
  final String userId,selectedUserId;
  final Timestamp creationTime;
  ChatWidget({required this.userId,required this.selectedUserId,required this.creationTime});
  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Usersclass user;
  late Chat chat;

  Future<Message> getLastMessage({currentUserId,selectedUserId}) async{
    Message _message=new Message(timestamp: Timestamp.now());
    print('heelooo '+currentUserId+" "+selectedUserId);
    await _firestore.collection('users').doc(currentUserId).collection('chats').doc(selectedUserId).collection('messages').orderBy('timestamp',descending: true).get().then((document)async{
      print('hoo'+document.size.toString()+document.docs.first.id);
      await _firestore.collection('messages').doc(document.docs.first.id).get().then((message){
        print('kk'+message['text']);
        _message.text=message['text'];
        //_message.photourl=message['photourl']!=null?message['photourl']:null;
        _message.timestamp=message['timestamp'];
      });
    }).onError((error, stackTrace) {
      print(error.toString());
    }
    );
    /*await _firestore.collection('users').doc(currentUserId).collection('chats').doc(selectedUserId).collection('messages').orderBy('timestamp',descending: true).snapshots().first.then((document) async{
      print('mmmmmmm');
      print('heel '+document.docs.toString());
      await _firestore.collection('messages').doc(document.docs.first.id).get().then((message){
        _message.text=message['text'];
        _message.photourl=message['photourl'];
        _message.timestamp=message['timestamp'];
      });
    });*/
    print('i am spidy');
    return _message;
  }

  Future<Usersclass> getCurrentUser(String userid) async
  {
    Usersclass currentUser=new Usersclass();
    await _firestore.collection('users').doc(userid).get().then((user) {
      currentUser.name = user['name'];
      currentUser.uid=user['uid'];
      currentUser.photo = user['photourl'];
    });
    return currentUser;
  }

  getCUser() async
  {
    print('drdrdrd');
    print('i am here' + widget.creationTime.toString());
    user = await getCurrentUser(widget.selectedUserId);
    /*return Chat(
      name: user.name,
      photoUrl: user.photo,
      lastMessage: null,
      lastMessagePhoto: null,
      timestamp: null,
    );*/
    Message message = await getLastMessage(
        currentUserId: widget.userId, selectedUserId: widget.selectedUserId);

    if (message != null) {
      return Chat(
        name: user.name,
        photoUrl: user.photo,
        lastMessage: message.text.toString(),
        lastMessagePhoto: message.photourl.toString(),
        timestamp: message.timestamp,
      );
    }
    return Chat(
      name: user.name,
      photoUrl: user.photo,
      lastMessage: null,
      lastMessagePhoto: null,
      timestamp: null,
    );
  }

  getChat() async{
    print('i am here');
    user= await getCurrentUser(widget.userId);
    Message message=await getLastMessage();
    Chat chat=new Chat();
    if(message==null){
      chat.name=user.name;
      chat.photoUrl= user.photo;
      chat.lastMessage= null;
      chat.lastMessagePhoto= null;
      chat.timestamp= null;

    }
    else{
      chat.name=user.name;
      chat.photoUrl= user.photo;
      chat.lastMessage= message.text;
      chat.lastMessagePhoto= message.photourl;
      chat.timestamp= message.timestamp;

    }
    return chat;
  }
  Future deleteChat({currentUserId,selectedUserId}) async{
    return await _firestore.collection('users').doc(currentUserId).collection('chats').doc(selectedUserId).delete();
  }

  openChat() async{


    try{
      Usersclass current=new Usersclass();
      Usersclass sending=new Usersclass();
      current=await getCurrentUser(widget.userId);
      sending=await getCurrentUser(widget.selectedUserId);
      print(' i am venom '+sending.uid);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Messaging_page(currentuser: current,selectedUser: sending),
        ),
      );
    }
    catch(e){
      print(e.toString());
    }
  }

  delete() async{
    await deleteChat(currentUserId: widget.userId,selectedUserId: widget.selectedUserId);
  }
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return FutureBuilder(future: getCUser(),
      builder: (context,snapshot){
        if(snapshot.data==null)
        {
          return Container(
              child:LinearProgressIndicator(
                backgroundColor: Colors.blueAccent,
              )
            /*child: CircularProgressIndicator(
              backgroundColor: Colors.orange,
              strokeWidth: 10,
            ),*/

          );
        }
        else{

          Chat chat=snapshot.data as Chat;
          return GestureDetector(
            onTap: ()async{await openChat();},
            onLongPress: () async{
              showDialog(context: context, builder: (BuildContext context)=>AlertDialog(
                content: Wrap(
                  children: [
                    Text("Do you want to delete chat",style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("Do you want to delete chat",style: TextStyle(fontWeight: FontWeight.w600)),


                  ],
                ),
                actions: [
                  FlatButton(onPressed: (){Navigator.of(context).pop();}, child: Text("No",style: TextStyle(color: Colors.blue),)),
                  FlatButton(onPressed: ()async{await delete(); Navigator.of(context).pop();}, child: Text("yes",style: TextStyle(color: Colors.red),))
                ],
              ));
            },
            child: Padding(
              padding: EdgeInsets.all(size.height*0.02),
              child: Container(
                width: size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(size.height*0.02),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      ClipOval(child: Container(height: size.height*0.06,width: size.height*0.06,
                        child: Photo_widget(
                          photolink: user.photo,

                        ),),),
                      SizedBox(width: size.width*0.02,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: TextStyle(
                              fontSize: size.height*0.03,
                            ),
                          ),
                          chat.lastMessage!=null?Text(chat.lastMessage.toString(),
                            overflow: TextOverflow.fade,
                            style: TextStyle(color: Colors.grey),):chat.lastMessagePhoto==null?Text("chat room available"):Row(
                            children: [
                              Icon(Icons.photo,color: Colors.grey,size: size.height*0.02,),
                              Text("Photo",style: TextStyle(fontSize: size.height*0.015,color: Colors.grey,),),

                            ],
                          )
                        ],
                      ),
                    ],),
                    chat.timestamp!=null?Text(chat.timestamp!.toDate().hour.toString()+":"+chat.timestamp!.toDate().minute.toString()):Text(widget.creationTime.toDate().hour.toString()+":"+widget.creationTime.toDate().minute.toString()),
                  ],
                ),
              ),

            ),
          );
        }
      },);
  }
}
