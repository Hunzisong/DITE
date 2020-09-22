
import 'package:flutter/material.dart';
import 'package:heard/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';



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
      body: SafeArea(
        child: Column(

        ),
      ),
    );
  }
}
