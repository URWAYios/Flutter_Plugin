class PayTokenizeReq
{
  String terminalId;
  String password;
  String action;
  String currency;
  String customerEmail;
  String country;
  String amount;
  String customerIp;

  String merchantIp;
  String trackid;
  String udf1;
  String udf2;
  String udf3;
  String udf4;
  String udf5;
  String udf7;
  String tokenOperation;
  String cardToken;
  String requestHash;
 String deviceinfo;





  //action12
  PayTokenizeReq({required this.terminalId, required this.password, required this.action, required this.currency,
    required this.customerEmail, required this.country, required this.amount, required this.customerIp,
    required this.merchantIp, required this.trackid, required this.udf1, required this.udf2, required this.udf3, required this.udf4,
    required this.udf5, required this.udf7,required this.tokenOperation,
    required this.cardToken, required this.requestHash,required this.deviceinfo});

  factory PayTokenizeReq.fromJson(Map<String, dynamic> json)
  {
    PayTokenizeReq pay;
    pay=PayTokenizeReq(
        terminalId:json['terminalId'] as String,
        password:json['password'] as String,
        action:json['action'] as String,
        currency:json['currency'] as String,
        customerEmail:json['customerEmail'] as String,
        country:json['country'] as String,
        amount:json['amount'] as String,
        customerIp:json['customerIp'] as String,
        merchantIp:json['merchantIp'] as String,
        trackid:json['trackid'] as String,
        udf1:json['udf1'] as String,
        udf2:json['udf2'] as String,
        udf3:json['udf3'] as String,
        udf4:json['udf4'] as String,
        udf5:json['udf5'] as String,
        udf7:json['udf7'] as String,
        cardToken:json['cardToken'] as String,
        tokenOperation:json['tokenOperation'] as String,
        requestHash: json['requestHash'] as String,
        deviceinfo: json['deviceinfo'] as String
    );
    return pay;
  }


  Map toMap() {
    var map = new Map<String, dynamic>();
    map["terminalId"] = terminalId;
    map["password"] = password;
    map["action"]= action;
    map["currency"]=currency;
    map["customerEmail"]=customerEmail;
    map["country"] =country;
    map["amount"] =amount;
    map["customerIp"]=customerIp ;
    map["merchantIp"] =merchantIp;
    map["trackid"] =trackid;
    map["udf1"] =udf1;
    map["udf2"]=udf2;
    map["udf3"]=udf3;
    map["udf4"] =udf4;
    map["udf5"]=udf5;
    map["udf7"]=udf7;
    map["cardToken"]=cardToken;
    map["tokenOperation"]=tokenOperation;
    map["requestHash"]=requestHash;
   map["deviceinfo"] = deviceinfo;

    return map;
  }


}
