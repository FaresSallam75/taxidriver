class DriverDetailsModel {
  String? driverId;
  String? driverEmail;
  String? time;
  double? driverLat;
  double? driverLong;
  String? fcmToken;

  DriverDetailsModel({
    this.driverId,
    this.driverEmail,
    this.driverLat,
    this.time,
    this.driverLong,
    this.fcmToken,
  });

  DriverDetailsModel.fromJson(Map<String, dynamic> json) {
    driverId = json['driverId'];
    driverEmail = json['driverEmail'];
    time = json['time'];
    driverLat = json['driverLat'];
    driverLong = json['driverLong'];
    fcmToken = json['fcmToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['driverId'] = driverId;
    data['driverEmail'] = driverEmail;
    data['driverLat'] = driverLat;
    data['time'] = time;
    data['driverLong'] = driverLong;
    data['fcmToken'] = fcmToken;
    return data;
  }
}
