class OrdersModel {
  String? docId;
  String? carDocId;
  double? distance;
  String? carName;
  String? price;
  String? fromLocation;
  String? userId;
  String? toLocation;
  String? status;
  String? timestamp;
  String? driverId;

  OrdersModel({
    this.docId,
    this.carDocId,
    this.distance,
    this.carName,
    this.price,
    this.fromLocation,
    this.userId,
    this.toLocation,
    this.status,
    this.timestamp,
    this.driverId,
  });

  OrdersModel.fromJson(Map<String, dynamic> json) {
    docId = json['docId'];
    carDocId = json['carDocId'];
    distance = json['distance'];
    carName = json['carName'];
    price = json['price'].toString();
    fromLocation = json['fromLocation'];
    userId = json['userId'];
    toLocation = json['toLocation'];
    status = json['status'].toString();
    timestamp = json['timestamp'];
    driverId = json['driverId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['docId'] = docId;
    data['carDocId'] = carDocId;
    data['distance'] = distance;
    data['carName'] = carName;
    data['price'] = price;
    data['fromLocation'] = fromLocation;
    data['userId'] = userId;
    data['toLocation'] = toLocation;
    data['status'] = status;
    data['timestamp'] = timestamp;
    data['driverId'] = driverId;
    return data;
  }
}
