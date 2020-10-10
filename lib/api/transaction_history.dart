class TransactionHistory {
  String id;
  String type;
  String counterpartName;
  String date;
  String time;
  String status;

  TransactionHistory(
      {this.id,
        this.type,
        this.counterpartName,
        this.date,
        this.time,
        this.status});

  TransactionHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    counterpartName = json['counterpart_name'];
    date = json['date'];
    time = json['time'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['counterpart_name'] = this.counterpartName;
    data['date'] = this.date;
    data['time'] = this.time;
    data['status'] = this.status;
    return data;
  }
}
