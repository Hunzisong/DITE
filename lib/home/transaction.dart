import 'package:flutter/material.dart';
import 'package:heard/constants.dart';
import 'package:heard/video_chat_components/index.dart';

class Transaction extends StatefulWidget {
  @override
  _TransactionState createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconButton(
        icon: Icon(Icons.video_call),
        color: Colours.blue,
        iconSize: Dimensions.d_65,
        onPressed: () {
          Navigator.push(
              context,
              // move to the video call page
              MaterialPageRoute(builder: (context) => IndexPage()));
        },
      ),
    );
  }
}
