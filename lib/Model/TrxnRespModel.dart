

class TrxnRespModel
{  final String tranId;
  final String responseCode;
  final String amount;
  final String result;
  final String cardToken;
  final String cardBrand;
  final String maskedPanNo;
  final String responseMsg;


TrxnRespModel({required this.tranId, required this.responseCode, required this.amount, required this.result,
     required this.cardToken,required this.cardBrand,required this.maskedPanNo,required this.responseMsg});

  factory TrxnRespModel.fromJson(Map<String, dynamic> json) {
  return TrxnRespModel(
    tranId: json['tranId'],
    responseCode: json['ResponseCode'],
    amount: json['amount'],
    result: json['result'],

    cardToken: json['cardToken'],
    cardBrand: json['cardBrand'],
    maskedPanNo: json['maskedPanNo'],
    responseMsg: json['responseMsg'],

  );
  }

  Map toMap() {
  var map = new Map<String, dynamic>();
  map["tranId"] = tranId;
  map["responseCode"] =responseCode;
  map["amount"] =amount;
  map["result"] =result;

  map["cardToken"] =cardToken;
  map["cardBrand"] =cardBrand;
  map["maskedPanNo"] =maskedPanNo;
  map["ResponseMsg"] =responseMsg;
  return map;
  }
}
