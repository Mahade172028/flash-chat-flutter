import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final firestore = Firestore.instance;
final auth = FirebaseAuth.instance;

FirebaseUser loggedUser;

class ChatScreen extends StatefulWidget {
  static String id = "chat_screen";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final TextEditingController _controller = TextEditingController();
  String messageText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLoggedUser();
  }

  void getLoggedUser() async {
    try {
      final user = await auth.currentUser();
      if (user != null) {
        loggedUser = await auth.currentUser();
        print(loggedUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  //FOR FETCHING DATA WITHOUT STREAM
  /*void getMessages()async{
    final messages=await _firestore.collection('messages').getDocuments();
    for(var message in messages.documents){
      print(message.data);
    }

  }*/

  //FOR MESSAGE STREAMING
  /*void getMessageStream() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.documents) {
        print(message.data);
      }
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //getMessageStream();
                auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MassagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      firestore.collection('messages').add(
                          {'text': messageText, 'sender': loggedUser.email});
                      setState(() {
                        _controller.clear();
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MassagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('messages').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlue,
              ),
            );
          }
          final messages = snapshot.data.documents.reversed;
          List<MessageBubble> messageBubbles = [];
          for (var message in messages) {

            String messageText = message.data["text"];
            String sender = message.data["sender"];
            String currentUser=loggedUser.email;

            var messageBubble = MessageBubble(
              messageText: messageText,
              sender: sender,
              isMe: currentUser==sender,
            );
            messageBubbles.add(messageBubble);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              children: messageBubbles,
            ),
          );
        });
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.messageText, this.sender, this.isMe});

  final String messageText;
  final String sender;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: !isMe?CrossAxisAlignment.start:CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            sender,
            style: TextStyle(fontSize: 10.0, color: Colors.black54),
          ),
          Material(
            borderRadius: BorderRadius.only(
              topRight:!isMe?Radius.circular(30.0):Radius.circular(0.0),
              topLeft: isMe?Radius.circular(30.0):Radius.circular(0.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
            elevation: 5.0,
            color: !isMe?Colors.white30:Colors.lightBlueAccent,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Text(
                '$messageText',
                style: TextStyle(
                  color: !isMe?Colors.black87:Colors.white,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
