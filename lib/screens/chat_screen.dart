import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = Firestore.instance;
FirebaseUser loggedInUser; //gives the current logged in user

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat-screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
 

  String messageText;

  //method to get current user /email
  void getCurrentUser() async {
    try {
      final user = await _auth
          .currentUser(); //Returns the currently signed-in [FirebaseUser] or [null] if there is none.
      if (user != null) {
        loggedInUser = user;
        // await loggedInUser.sendEmailVerification();
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  // void getMessages() async {  //pulling data from databse =>but we need to trigger this everytime
  //   final messages = await _firestore.collection('messages').getDocuments();
  //   // print(messages); //prints ->Instance of 'QuerySnapshot'
  //   print(messages.documents); //list of all the messages

  //Fetch the documents for this query
  // for (var message in messages.documents) {
  //messages.documents is a list
  //message is a type of that list
  //   print(message.data); //gives us the key value pair
  //    I/flutter (22262): {sender: test123@gmail.com, text: Hey there }
  // I/flutter (22262): {sender: test123@gmail.com, text: hello}

  //   // }
  //   for (int i = 0; i < messages.documents.length; i++) {
  //     print(messages.documents[i].data); //eg {sender: test123@gmail.com, text: hello}
  //   }
  // }

  //future returns stuff as soon as its over ,but the streams returns things as one by one as
  //they are finished
  void messagesStream() async {
    //listen to the stream of the messages pushed from the firebase
    //like a list of futures
    //snapshots ->Notifies of query results at this location }
    //returns Stream<QuerySnapshot>
    final snapshotvar = _firestore.collection('messages').snapshots();
    print(snapshotvar); //Instance of '_BroadcastStream<QuerySnapshot>'

    await //we have subscribed to the changes in collection of messages and it triggers a
        // re run of the below code whenever a new messgage is added
        for (var snapshot in _firestore.collection('messages').snapshots()) {
      print(snapshot.toString()); //Instance of 'QuerySnapshot'

      for (var message in snapshot.documents) {
        print(message.data);
      }
    }
  } //update this to the ui using StreamBuilder

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                _auth.signOut();
                Navigator.pop(context);
                // messagesStream();
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
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      //Implement send functionality and store the data in firebase store
                      //send messageText+loggedInuser.email

                      _firestore.collection('messages').add({
                        //add(Map<String, dynamic> data)
                        'text': messageText, //in cloud firestore
                        'sender': loggedInUser.email,
                      });

                      messageTextController
                          .clear(); //to clear previously added text
                      //string is the key and the value dynamic
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

class MessagesStream extends StatelessWidget {
  // const MessagesStream({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      //rebuilds whenever new data comes to the stream
      stream: _firestore
          .collection('messages')
          .snapshots(), //stream of query snapshots
      //{Widget Function(BuildContext, AsyncSnapshot<QuerySnapshot>) builder}
      builder: (context, snapshot) {
        //snapshot is the most recent interaction with the stream

        if (!snapshot.hasData) {
          //when snapshot has no data ->when the first time we are loading the chat screen
          return Center(
            child: CircularProgressIndicator(
              color: Colors.lightBlueAccent,
            ),
          );
        }
        print(snapshot.data); //type of QuerySnapshot
        final messages =
            snapshot.data.documents.reversed; //List<DocumentSnapshot> list of maps
        print(messages);
        List<MessageBubble> listMessageBubble = [];
        for (var message in messages) {
          final messageText = message.data['text'];
          final messageSender = message.data['sender']; 

          final currentUser =loggedInUser.email;

          if(currentUser==messageSender) {
            //the message is from the logged in user 
          }

          final messageBubble =MessageBubble(
            message: messageText,
            sender: messageSender,
            isMe: currentUser==messageSender 
             );
          listMessageBubble.add(messageBubble);
        }
        return Expanded(
          //takes up as much space as it is available
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: ListView(
              children: listMessageBubble,
              reverse: true, //always shows the bottom of the list view 
            ),
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  // const MessageBubble({ Key? key }) : super(key: key);
  final String message;
  final String sender;
  final bool isMe ;

  MessageBubble({this.isMe,this.sender, this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: isMe?CrossAxisAlignment.end :CrossAxisAlignment.start,
        children: [
          Text(sender, style: TextStyle(fontSize: 12, color: Colors.black54)),
          Material(
              color: isMe?Colors.lightBlueAccent:Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: isMe?Radius.circular(30): Radius.circular(0),
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                  topRight: isMe? Radius.circular(0):Radius.circular(30)),
              elevation: 5,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  '$message',
                  style: TextStyle(fontSize: 15, color: isMe?Colors.white :Colors.black54),
                ),
              )),
        ],
      ),
    );
  }
}
