class PaymentModel {
  String? userId;
  String? fullname;
  String? driverId;
  String? email;
  String? time;
  String? status;
  String? currency;
  String? amount;
  String? method;
  String? city;

  PaymentModel({
    this.userId,
    this.fullname,
    this.driverId,
    this.email,
    this.time,
    this.status,
    this.currency,
    this.amount,
    this.method,
    this.city,
  });

  PaymentModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    fullname = json['fullname'];
    driverId = json['driverId'];
    email = json['email'];
    time = json['time'];
    status = json['status'];
    currency = json['currency'];
    amount = json['amount'].toString();
    method = json['method'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['fullname'] = fullname;
    data['driverId'] = driverId;
    data['email'] = email;
    data['time'] = time;
    data['status'] = status;
    data['currency'] = currency;
    data['amount'] = amount;
    data['method'] = method;
    data['city'] = city;
    return data;
  }
}
