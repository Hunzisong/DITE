
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:heard/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';




class Questionnaire extends StatefulWidget {
  @override
  _QuestionnaireState createState() => _QuestionnaireState();
}

class _QuestionnaireState extends State<Questionnaire> {

  bool isSLI = false ;

  @override
  void initState() {
    super.initState();
    setSLI();
    print(isSLI);
  }

  void setSLI() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      isSLI = preferences.getBool('isSLI');

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isSLI ? Colours.orange : Colours.blue,

        title: Text('Covid-19'),

      ),
      body: Column(

          children: <Widget>[

            Container(
              height: 100.0,
              child: TextField(
                  decoration: InputDecoration(
                    fillColor: Colours.grey,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                                          Radius.circular(40.0),
                        ),
                    ),
                    labelText: 'Search...',
                    icon: Icon(Icons.search, color: Colours.black,)
                  ),
                ),
              padding: EdgeInsets.all(30),
            ),


            // search bar for the UI

            Container(
              padding: EdgeInsets.all(20.0),
              child: Text('Adakah anda mengalami gejala-gejala ini dalam tempoh 14 hari yang lepas?') ,
            ),




          ],



        ),
    );
  }
}
