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



final _firestore = FirebaseFirestore.instance;
auth.User loggedInUser ;


class ChatScreen extends StatefulWidget {

  static const routeName = '/chatPage';
  static String id = 'chat_screen';

  String chatRoomID;
  String counterpartName;
  String counterpartPic;


  ChatScreen({this.chatRoomID, this.counterpartName, this.counterpartPic });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  // for text inputting usage
  final messageTextController = TextEditingController();
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  String authToken ;

  // To cater for various format of messages
  var messageText ;
  var fileURL ;
  var file ;   /* This is an attachment file */
  var isSLI = false;  // assign a default value


  @override
  void initState() {
    super.initState();
    getCurrentUser();
    setSLI();
    getAuthToken();
  }

  void getAuthToken() async {
    String authTokenString = await AuthService.getToken();
    setState(() {
      authToken = authTokenString;
    });
  }

  void setSLI() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      isSLI = preferences.getBool('isSLI');

      print('check if is SLI');
      print(isSLI);


    });
  }

  void getCurrentUser() async{

    try{
      final user = _auth.currentUser;

      if (user != null){
        loggedInUser = user ;
        print('hello');
        print(loggedInUser.phoneNumber);
      }
    }
    catch(e){
      print(e);
    }

  }

  Future<dynamic> uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(file);

    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    var url = storageTaskSnapshot.ref.getDownloadURL();

    return url ;

  }

  /*Follow up method to send attachments*/
  showFilePicker(FileType fileType) async {

    file = await FilePicker.getFile(type: fileType);

    if (file == null) return ;

    // send attachment event function implementation
    String url = await uploadFile();

    messageText = url;
    // then, proceed to send this message
    sendMessage(url, fileType);
    print(fileType);

    Navigator.pop(context);

  }


  // implementing a listener function
  void messageStream() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data);
      }
    }
  }

  void sendMessage(String content, var type) async{
    // clear the message input
    // int type : 0 for text strings, filetype.image for image,
    //            filetype.video for videos, filetype.any for misc files

    if (content != '')
    {
      // clear the text editing controller
      messageTextController.clear();

      // call the chat/send API
      bool messageSent = await ChatServices().sendChatMessage(
          headerToken: authToken,
          isSLI: isSLI,
          roomID: widget.chatRoomID,
          message: content,
      );

      if (messageSent){
        print('Message sent.');


      }

      else {
        print("Message is not sent");
      }



      // NOTE
      //Implement send functionality.
//      _firestore.collection('messages').add({
//        'text' : content,
//        'sender' : loggedInUser.phoneNumber,
//        'type': type.toString(),
//        'isSLI': isSLI,
//      });
    }
  }



  @override
  Widget build(BuildContext context) {

    final ChatHomeScreen args = ModalRoute.of(context).settings.arguments;


    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
//          IconButton(
//              icon: Icon(Icons.close),
//              onPressed: () {
//                //Implement logout functionality
//                messageStream();
//                Navigator.pop(context);
//              }),
        ],
        title: Row(
          children: [
            Text(widget.counterpartName),
          ],
        ),
        backgroundColor: isSLI ? Colours.orange : Colours.blue,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            // Create Message Stream over here
            MessageStream()
            ,
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  // The widget for text input
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value ;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),

                  // The add attachment icon for adding other file
                  FlatButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext bc){
                            return Container(
                              child: Wrap(
                                children: <Widget>[
                                  ListTile(
                                    leading: Icon(Icons.image),
                                    title: Text('Image'),
                                    onTap: () => showFilePicker(FileType.image),
                                  ),

                                  ListTile(
                                    leading: Icon(Icons.videocam),
                                    title: Text('Video'),
                                    onTap: () => showFilePicker(FileType.video),
                                  ),

                                  ListTile(
                                    leading: Icon(Icons.insert_drive_file),
                                    title: Text('Document'),
                                    onTap: () => showFilePicker(FileType.any),
                                  ),
                                ],
                              ),
                            );
                          });

                    },
                    child: IconButton(
                        icon : Icon(Icons.attach_file, color: Colors.black,)
                    ),
                  ),

                  FlatButton(
                    onPressed: () {

                      // The code 'filetype.text' means for messageTEXT
                      sendMessage(messageText, 'FileType.text');

                    },
                    child: IconButton(
                        icon : Icon(Icons.send, color: Colors.black45,)
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
          final isSLI= message.data()['isSLI'];

//          if (currentUser == messageSender){
//            isMe = true ;
//
//          }

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

// Modify the message bubble to encapsulate different media
// e.g text, image, video, documents
class MessageBubble extends StatelessWidget {
  MessageBubble(this.sender, this.text , this.type , this.isMe, this.isSLI);

  final String sender;
  final String text  ;
  final String type  ;
  final bool isMe    ;
  final bool isSLI   ;

  /* Method to activate video player */
  void showVideoPlayer(parentContext,String videoUrl) async {
    await showModalBottomSheet(
        context: parentContext,
        builder: (BuildContext bc) {
          return VideoPlayerWidget(videoUrl);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[

            // this part of the widget is the sender's name/email
            Text(sender,style: TextStyle(
              fontSize: 12.0,
              color: Colors.black,
            ),

            )

            ,
            Material(
                borderRadius: isMe ?  BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0) ,
                )

                    :

                BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                  topRight: Radius.circular(30.0) ,
                )
                ,
                color: isSLI ? Colours.orange : Colours.blue,
                child:

                type == 'FileType.text' ?

                Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    child:

                    // Modify here.
                    Text(text,style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.black,
                    ),
                    )
                )


                    : type == 'FileType.image' ?
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
                    child:

                    Container(
                      child: FlatButton(
                        child: Material(
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
                              ),
                              width: 100.0,
                              height: 100.0,
                              padding: EdgeInsets.all(70.0),
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                              ),
                            ),

                            /*TODO*/
                            errorWidget: (context, url, error) => Material(
                              child: Image.asset(
                                'images/logo.png',
                                width: 100.0,
                                height: 100.0,
                                fit: BoxFit.cover,
                              ),

                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),

                              clipBehavior: Clip.hardEdge,

                            ),

                            imageUrl: text,
                            width: 150.0,
                            height: 150.0,
                            fit: BoxFit.cover,
                          ),

                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          clipBehavior: Clip.hardEdge,
                        ),

                        onPressed: (){
                          // enlarge the photo to full screen
                        },

                      ),
                    )


                )

                    : type == 'FileType.video' ?


                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Stack(
                        alignment: AlignmentDirectional.center,
                        children: <Widget>[
                          Container(
                            width: 130,
                            color: Colors.black45,
                            height: 80,
                          ),

                          Column(
                            children: <Widget>[
                              Icon(
                                Icons.videocam,
                                color: Colors.black,
                              ),

                              SizedBox(height: 5,),

                              Text('Video',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                ) ,
                              )

                            ],
                          ),
                        ],
                      ),

                      Container(
                        height: 40,
                        child: IconButton(
                          icon: Icon(
                            Icons.play_arrow,
                            color: Colors.black,
                          ),

                          // implement onPressed here
                          // the text here is the video url
                          onPressed: () => showVideoPlayer(context, text),

                        ),
                      ),


                    ],
                  ),
                )

                // if not, it must be a document
                // requires file downloader API
                // requires changing android permissions
                // TODO - Do later! After integrating with the main application
                    :
                Container()

            ),
          ]
      ),
    );
  }
}