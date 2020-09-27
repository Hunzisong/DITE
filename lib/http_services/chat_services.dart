import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:heard/api/chat_item.dart';


class ChatServices {


  /* First method is to retrieve the chat room list
     for each authenticated users.
     This API is used to populate chat history

     * tested, 2nd and 3rd method not tested.
   */

  Future<List<ChatItem>> getChatRoomList(
      {String headerToken, bool isSLI}) async {
    var response = await http.get(
        'https://heard-project.herokuapp.com/chat/all?type=${isSLI ? 'sli' : 'user'}',
        headers: {
          'Authorization': headerToken,
        });

    print('Get all chat list: ${response.statusCode}, body: ${response.body}');

    /**
     * Create an empty list to retrieve the data obtained from API
     */
    List<ChatItem> allChatRooms = [];

    if (response.statusCode == 200) {
      List<dynamic> requestsBody = jsonDecode(response.body);
      for (int i = 0; i < requestsBody.length; i++) {
        ChatItem request = ChatItem.fromJson(requestsBody[i]);
        allChatRooms.add(request);
      }
    }


    return allChatRooms;
  }



  /* Second method for each authenticated users.

     This API should be called when user/SLI enter chat room in an ongoing session
     (because front-end won't know if they have chat history or not),
     it will return necessary data for front-end to populate and listen to fire store.

   */
  Future<bool> enterChatRoom(
      {String headerToken, bool isSLI, String counterpartID}) async {
    var response = await http.post(
        'https://heard-project.herokuapp.com/chat/enter?type=${isSLI ? 'sli' : 'user'}',
        headers: {
          'Authorization': headerToken,
        },
        body: {
          'counterpart_id': counterpartID,
        });

    print(
        'Attempt to enter chat room....: ${response.statusCode}, body: ${response.body}');

    if (response.statusCode == 200) {
      print('Success');
      return true;
    } else {
      return false;
    }
  }


  /* Third method for each authenticated users.

     This API is used to send chat message to counterpart,
     it will store the message in fire store and trigger notification
     on counterpart's device.

   */
  Future<bool> sendChatMessage(
      {String headerToken, bool isSLI, String roomID, String message }) async {
    var response = await http.post(
        'https://heard-project.herokuapp.com/chat/send?type=${isSLI ? 'sli' : 'user'}',
        headers: {
          'Authorization': headerToken,
        },
        body: {
          'room_id': roomID,
          'message': message
        });

    print(
        'Message successfully sent: ${response.statusCode}, body: ${response.body}');

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

}