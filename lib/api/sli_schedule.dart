class SLISchedule {
  List<Duration> monday;
  List<Duration> tuesday;
  List<Duration> wednesday;
  List<Duration> thursday;
  List<Duration> friday;
  List<Duration> saturday;
  List<Duration> sunday;

  SLISchedule(
      {this.monday,
        this.tuesday,
        this.wednesday,
        this.thursday,
        this.friday,
        this.saturday,
        this.sunday});

  SLISchedule.fromJson(Map<String, dynamic> json) {
    if (json['monday'] != null) {
      monday = new List<Duration>();
      json['monday'].forEach((v) {
        monday.add(new Duration.fromJson(v));
      });
    }
    if (json['tuesday'] != null) {
      tuesday = new List<Duration>();
      json['tuesday'].forEach((v) {
        tuesday.add(new Duration.fromJson(v));
      });
    }
    if (json['wednesday'] != null) {
      wednesday = new List<Duration>();
      json['wednesday'].forEach((v) {
        wednesday.add(new Duration.fromJson(v));
      });
    }
    if (json['thursday'] != null) {
      thursday = new List<Duration>();
      json['thursday'].forEach((v) {
        thursday.add(new Duration.fromJson(v));
      });
    }
    if (json['friday'] != null) {
      friday = new List<Duration>();
      json['friday'].forEach((v) {
        friday.add(new Duration.fromJson(v));
      });
    }
    if (json['saturday'] != null) {
      saturday = new List<Duration>();
      json['saturday'].forEach((v) {
        saturday.add(new Duration.fromJson(v));
      });
    }
    if (json['sunday'] != null) {
      sunday = new List<Duration>();
      json['sunday'].forEach((v) {
        sunday.add(new Duration.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.monday != null) {
      data['monday'] = this.monday.map((v) => v.toJson()).toList();
    }
    if (this.tuesday != null) {
      data['tuesday'] = this.tuesday.map((v) => v.toJson()).toList();
    }
    if (this.wednesday != null) {
      data['wednesday'] = this.wednesday.map((v) => v.toJson()).toList();
    }
    if (this.thursday != null) {
      data['thursday'] = this.thursday.map((v) => v.toJson()).toList();
    }
    if (this.friday != null) {
      data['friday'] = this.friday.map((v) => v.toJson()).toList();
    }
    if (this.saturday != null) {
      data['saturday'] = this.saturday.map((v) => v.toJson()).toList();
    }
    if (this.sunday != null) {
      data['sunday'] = this.sunday.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Duration {
  String start;
  String end;

  Duration({this.start, this.end});

  Duration.fromJson(Map<String, dynamic> json) {
    start = json['start'];
    end = json['end'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start'] = this.start;
    data['end'] = this.end;
    return data;
  }
}
