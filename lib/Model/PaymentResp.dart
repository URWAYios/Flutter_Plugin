class PaymentResp
{
  String result;
  String responseCode;
  String authcode;
  String tranid;
  String trackid;
  String terminalid;
  String udf1;
  String udf2;
  String udf3;
  String udf4;
  String udf5;
  String rrn;
  String eci;
  String subscriptionId;
  String trandate;
  String tranType;
  String integrationModule;

  String integrationData;
  String payid;
  String targetUrl;

  String postData;
  String intUrl;
  String responseHash;
  String amount;
  String cardBrand;

  PaymentResp({required this.result, required this.responseCode, required this.authcode, required this.tranid,
    required this.trackid,required  this.terminalid, required this.udf1, required this.udf2, required this.udf3, required this.udf4,
    required this.udf5, required this.rrn, required this.eci, required this.subscriptionId, required this.trandate,
    required this.tranType, required this.integrationModule, required this.integrationData, required this.payid,
    required this.targetUrl, required this.postData, required this.intUrl, required this.responseHash,
    required this.amount, required this.cardBrand, required this.cc, required this.cardToken});

  String cc;
  String cardToken;

  factory PaymentResp.fromJson(Map<String, dynamic> json) {
    return PaymentResp (
        result:json['result'],
        responseCode:json['responseCode'] as String,
        authcode:json['authcode'] as String,
        tranid:json['tranid'] as String,
        trackid:json['trackid'] as String,
        terminalid:json['terminalid'] as String,
        udf1:json['udf1'] as String,
        udf2:json['udf2'] as String,
udf3:json['udf3'] as String,
udf4:json['udf4'] as String,
udf5:json['udf5'] as String,
rrn:json['rrn'] as String,
eci:json['eci'] as String,
subscriptionId:json['subscriptionId'] as String,
trandate:json['trandate'] as String,
tranType:json['tranType'] as String,
integrationModule:json['integrationModule'] as String,
integrationData:json['integrationData'] as String,
payid:json['payid'] as String,
targetUrl:json['targetUrl'] as String,
        postData:json['postData'] as String,
        intUrl:json['intUrl'] as String,
        responseHash:json['responseHash'] as String,
        amount:json['amount'] as String,
        cardBrand:json['cardBrand'] as String,
        cc:json['cc'] as String,
        cardToken:json['cardToken'] as String);

  }

}