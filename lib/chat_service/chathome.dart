import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heard/constants.dart';
import 'package:heard/chat_service/chatPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

auth.User loggedInUser ;

class ChatHomeScreen extends StatefulWidget {
  @override
  _ChatHomeScreenState createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {

  final List<String> entries = <String>['Bryan Yong', 'James Chadwick', 'Ariana Grande', 'Taylor Swift', 'Bruno Mars', 'Shawn Mendes', 'Emma Watson', 'James Bond'];
  bool isSLI = false ;

  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;


  @override
  void initState() {
    super.initState();
    setSLI();
    getCurrentUser();
    print(isSLI);
  }

  void setSLI() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      isSLI = preferences.getBool('isSLI');

    });
  }

  void getCurrentUser() async{

    try{
      final user = _auth.currentUser;

      if (user != null){
        loggedInUser = user ;
        print('hello');
        print(loggedInUser.displayName);
      }
    }
    catch(e){
      print(e);
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: IconButton(
            icon: Icon(Icons.question_answer,
                       color: Colours.white,
                      ),
          ),

          backgroundColor: isSLI ? Colours.orange : Colours.blue,
        ),

        body: Container(
          child: Column(

                children: <Widget>[

                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(8),
                      itemCount: entries.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                                onTap: (){

                                  // direct the user to the designated chat page
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ChatScreen(
                                                userID: loggedInUser.displayName,
                                                sliID:  entries[index],
                                        ),
                                      )
                                    );
                                },
                                leading: Icon(
                                  Icons.account_circle,
                                  size: Dimensions.d_55,
                                ),



                                title: Text(
                                  '${entries[index]}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),

                                subtitle: Text('Available'),

                              );
                      },
                      separatorBuilder: (BuildContext context, int index) => const Divider(),
                    ),
                  ),

                ],

          ),
        ),

    );

  }
}
