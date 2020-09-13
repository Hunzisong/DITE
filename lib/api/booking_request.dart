class BookingRequest {
  String bookingId;
  String uid;
  String sliId;
  String datetime;
  String notes;
  String status;
  String createdAt;
  String updatedAt;

  BookingRequest(
      {this.bookingId,
        this.uid,
        this.sliId,
        this.datetime,
        this.notes,
        this.status,
        this.createdAt,
        this.updatedAt});

  BookingRequest.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    uid = json['uid'];
    sliId = json['sli_id'];
    datetime = json['datetime'];
    notes = json['notes'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.bookingId;
    data['uid'] = this.uid;
    data['sli_id'] = this.sliId;
    data['datetime'] = this.datetime;
    data['notes'] = this.notes;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
