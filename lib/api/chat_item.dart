
class ChatItem {
  String chatroomId;
  String sliName;
  String userName;

  ChatItem({this.chatroomId, this.sliName, this.userName});

  ChatItem.fromJson(Map<String, dynamic> json) {
    chatroomId = json['chatroom_id'];
    sliName = json['sli_name'];
    userName = json['user_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chatroom_id'] = this.chatroomId;
    data['sli_name'] = this.sliName;
    data['user_name'] = this.userName;
    return data;
  }
}