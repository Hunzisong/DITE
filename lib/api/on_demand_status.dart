class OnDemandStatus {
  String status;
  Details details;

  OnDemandStatus({this.status, this.details});

  OnDemandStatus.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    details =
    json['details'] != null ? new Details.fromJson(json['details']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.details != null) {
      data['details'] = this.details.toJson();
    }
    return data;
  }
}

class Details {
  String uid;
  String userName;
  String userPhone;
  String onDemandId;
  String hospital;
  String hospitalDepartment;
  bool emergency;
  bool onBehalf;
  String patientName;
  String note;
  String requestedAt;

  Details(
      {this.uid,
        this.userName,
        this.userPhone,
        this.onDemandId,
        this.hospital,
        this.hospitalDepartment,
        this.emergency,
        this.onBehalf,
        this.patientName,
        this.note,
        this.requestedAt});

  Details.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    userName = json['user_name'];
    userPhone = json['user_phone'];
    onDemandId = json['on_demand_id'];
    hospital = json['hospital'];
    hospitalDepartment = json['hospital_department'];
    emergency = json['emergency'];
    onBehalf = json['on_behalf'];
    patientName = json['patient_name'];
    note = json['note'];
    requestedAt = json['requested_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['user_name'] = this.userName;
    data['user_phone'] = this.userPhone;
    data['on_demand_id'] = this.onDemandId;
    data['hospital'] = this.hospital;
    data['hospital_department'] = this.hospitalDepartment;
    data['emergency'] = this.emergency;
    data['on_behalf'] = this.onBehalf;
    data['patient_name'] = this.patientName;
    data['note'] = this.note;
    data['requested_at'] = this.requestedAt;
    return data;
  }
}
