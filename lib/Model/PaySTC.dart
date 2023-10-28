class PaySTC
{
  String terminalId;
  String password;
  String action;
  String currency;
  String customerEmail;
  String amount;
  String customerIp;
  String merchantIp;
  //String transid;
  String trackid;
  String udf2;
  String country;
  String udf3;
  String udf1;
  String udf5;
  String udf4;
  String udf7;
  String requestHash;
 String deviceinfo;
 String metaData;

  PaySTC
      ({
    required this.terminalId,
    required this.password,
    required this.action,
    required this.currency,
    required this.customerEmail,
    required this.amount,
    required this.customerIp,
    required this.merchantIp,
    required this.trackid,
    required this.udf2,
    required this.country,
    required this.udf3,
    required this.udf1,
    required this.udf5,
    required this.udf4,
    required this.udf7,
    required this.requestHash,
   required this.deviceinfo,
   required this.metaData

  });


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
    map["requestHash"]=requestHash;
    map["deviceinfo"]=deviceinfo;
    map["metaData"]=metaData;

    return map;
  }


}