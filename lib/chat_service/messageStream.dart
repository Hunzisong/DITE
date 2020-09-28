import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:heard/chat_service/chatConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:heard/chat_service/VideoPlayerWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:heard/constants.dart';
import 'package:heard/chat_service/chathome.dart';
import 'package:heard/http_services/chat_services.dart';
import 'package:heard/firebase_services/auth_service.dart';
import 'package:heard/chat_service/messageBubble.dart';

final _firestore = FirebaseFirestore.instance;


// need to modify from here ----
class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    // errors are caused here.
    return StreamBuilder<QuerySnapshot>(
      stream  : _firestore.collection('messages').snapshots(),
      builder : (context, snapshot){

        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }

        final messages = snapshot.data.docs.reversed ;
        List<MessageBubble> messageBubbles = [] ;
        for (var message in messages){
          final messageText   = message.data()['text'];
          /*TODO */
          final messageSender = message.data()['sender'];
          final messageType   = message.data()['type'];

          final currentUser = loggedInUser.phoneNumber;
          final isSLI= false ;  // TODO FAKE DATA


          final messageBubble = MessageBubble(
            messageSender,
            messageText  ,
            messageType,
            currentUser == messageSender,
            isSLI,
          );
          Text('$messageText from $messageSender',
            style: TextStyle(
              fontSize: 50.0,
            ),
          );
          messageBubbles.add(messageBubble);
        }




        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 20.0
            ),
            children: messageBubbles,
          ),
        );

      },
    );
  }
}