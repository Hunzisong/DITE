import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flash_chat/screens/VideoPlayerWidget.dart';


final _firestore = Firestore.instance;
FirebaseUser loggedInUser ;



class ChatScreen extends StatefulWidget {

  static String id = 'chat_screen';


  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  // for text inputting usage
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  // To cater for various format of messages
  var messageText ;
  var fileURL ;
  var file ;   /* This is an attachment file */


  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async{

    try{
        final user = await _auth.currentUser();

        if (user != null){
          loggedInUser = user ;
          print(loggedInUser.email);
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

//  // the asynchronous function for getfile
//  Future getFile() async {
//    file = await FilePicker.;
////
////    if (file != null){
////      setState(() {
////        isLoading = true;
////      });
////
////      uploadingFile() ;
////    }
//  }

  /* Function for uploading file attachments for the chat  */
//  void uploadFile() async {
//
//  }

  // implementing a listener function
  void messageStream() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.documents) {
        print(message.data);
      }
    }
  }

  void sendMessage(String content, var type){
    // clear the message input
    // int type : 0 for text strings, filetype.image for image,
    //            filetype.video for videos, filetype.any for misc files

    if (content != '')
    {
      // clear the text editing controller
      messageTextController.clear();

      // NOTE
      //Implement send functionality.
      _firestore.collection('messages').add({
        'text' : content,
        'sender' : loggedInUser.email,
        'type': type.toString(),
      });
    }
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
                  messageStream();
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Icon(Icons.message),
        backgroundColor: Colors.lightBlueAccent,
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
                        icon : Icon(Icons.attach_file, color: Colors.white,)
                    ),
                  ),

                  FlatButton(
                    onPressed: () {

                      // The code 'filetype.text' means for messageTEXT
                      sendMessage(messageText, 'FileType.text');

                    },
                    child: IconButton(
                      icon : Icon(Icons.send, color: Colors.white,)
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


        final messages = snapshot.data.documents.reversed ;
        List<MessageBubble> messageBubbles = [] ;
        for (var message in messages){
          final messageText   = message.data['text'];
          final messageSender = message.data['sender'];
          final messageType   = message.data['type'];

          final currentUser = loggedInUser.email;

//          if (currentUser == messageSender){
//            isMe = true ;
//
//          }

          final messageBubble = MessageBubble(
              messageSender,
              messageText  ,
              messageType,
              currentUser == messageSender);
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
  MessageBubble(this.sender, this.text , this.type , this.isMe);

  final String sender;
  final String text  ;
  final String type  ;
  final bool isMe    ;

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
                  color: Colors.white70,
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
            color: isMe ? Colors.lightBlueAccent : Colors.lightGreen,
            child:

            type == 'FileType.text' ?

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child:

                    // Modify here.
                    Text(text,style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.white,
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
                                color: Colors.white,
                              ),

                              SizedBox(height: 5,),

                              Text('Video',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white
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
                            color: Colors.white,
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