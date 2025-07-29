class CarModel {
  String? driverId;
  String? counts;
  String? carname;
  String? carDocId;

  CarModel({this.driverId, this.counts, this.carname, this.carDocId});

  CarModel.fromJson(Map<String, dynamic> json) {
    driverId = json['driverId'].toString();
    counts = json['counts'].toString();
    carname = json['carname'].toString();
    carDocId = json['carDocId'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['driverId'] = driverId;
    data['counts'] = counts;
    data['carname'] = carname;
    data['carDocId'] = carDocId;
    return data;
  }
}
