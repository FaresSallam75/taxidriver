class NotificationModel {
  String? docId;
  String? driverId;
  String? time;
  String? title;
  String? body;
  String? userId;

  NotificationModel({
    this.docId,
    this.driverId,
    this.time,
    this.title,
    this.body,
    this.userId,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    docId = json['docId'];
    driverId = json['driverId'];
    time = json['time'];
    title = json['title'];
    body = json['body'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['docId'] = docId;
    data['driverId'] = driverId;
    data['time'] = time;
    data['title'] = title;
    data['body'] = body;
    data['userId'] = userId;
    return data;
  }
}
