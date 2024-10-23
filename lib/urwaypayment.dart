library urwaypayment;

import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:core';
import 'package:apple_pay_flutter/apple_pay_flutter.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:convert/convert.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
//import 'package:path_provider/path_provider.dart';

import 'package:package_info_plus/package_info_plus.dart';

import 'package:urwaypayment/Constantvals.dart';
import 'package:urwaypayment/Model/DeviceDetailsModel.dart';
import 'package:urwaypayment/Model/PayRefundReq.dart';
import 'package:urwaypayment/Model/PaySTC.dart';
import 'package:urwaypayment/Model/PayTokenizeReq.dart';
import 'package:urwaypayment/Model/PaymentReq.dart';

import 'package:urwaypayment/ResponseConfig.dart';
import 'package:urwaypayment/TransactWebpage.dart';





import 'Model/Post.dart';
import 'Model/TrxnRespModel.dart';
import 'TransactPage.dart';
import 'package:crypto/crypto.dart';


class Payment {

  // static Future get _localPath async {
  //   String? dirPath;
  //
  //   /**
  //    * Based on Platform Direct is created
  //    * */
  //   if (Platform.isIOS) {
  //     final appDirectory = await getDownloadsDirectory();
  //     dirPath = appDirectory!.path;
  //
  //   }
  //
  //   else if (Platform.isAndroid) {
  //     // External storage directory: /storage/emulated/0
  //     final externalDirectory = await getDownloadsDirectory();
  //     dirPath = externalDirectory!.path;
  //
  //   }
  //
  //   return dirPath;
  // }

  // static Future get _localFile async {
  //   final path = await _localPath;
  //   final folderName = "urway";
  //
  //
  //   return File('$path/RespReqLog.txt');
  // }


  /**
   * This method is used to write Response and Request to File
   * */
  // static Future _writetoFile(String text) async {
  //
  //
  //   final file = await _localFile;
  //
  //
  //   var now1 = new DateTime.now();
  //   String datetime = now1.toString();
  //   var header = datetime + ": " + text;
  //   File result = await file.writeAsString(header, mode: FileMode.append);
  //
  //   if (result == null)
  //   {
  //     print("Writing to file failed");
  //   }
  //   else
  //   {
  //
  //   }
  // }

  /**
   * This method is used to perform Transactions
   * This method takes Transaction Details as @params*****/

  static Future<String> makepaymentService({
    required BuildContext context, required String country, required String action, required String currency,
    required String amt, required String customerEmail, required String trackid, required String udf1, required String udf2,
    required String udf3, required String udf4, required String udf5, required String address, required String city,
    required String zipCode, required String state, required String cardToken, required String tokenizationType,
    required String tokenOperation,required metadata
  }) async {
    assert(context != null, "context is null!!");

    String payRespData="";

    /**
     *  Initial Check for Transaction Processing  *****/
    if (ResponseConfig.startTrxn != Constantvals.appinitiateTrxn) {
      ResponseConfig.startTrxn = true;

      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          var order = await _read(
              context,
              country,
              action,
              currency,
              amt,
              customerEmail,
              trackid,
              udf1,
              udf2,
              udf3,
              udf4,
              udf5,
              address,
              city,
              zipCode,
              state,
              cardToken,
              tokenizationType,
              tokenOperation,
              metadata
          );
          payRespData = order;
        }
      }
      on SocketException catch (e)
      {

        print(e);
        ResponseConfig.startTrxn = false;
        showalertDailog(context, 'Alert', "Please check Internet Connection");
        //payRespData="Please check internet connection";
      }
    }
    else
    {
      payRespData= "Transaction already initiated";
    }

    return payRespData;
  }


  /**
   *
   *  Api calling for First leg
   * */

  static Future<String> _read(BuildContext context, String country,
      String action, String currency, String amt, String customerEmail,
      String trackid, String udf1, String udf2, String udf3, String udf4,
      String udf5, String address, String city, String zipCode, String state,
      String cardToken, String tokenizationType, String tokenOperation,String metadata) async {
    String text;
    String url = "";
    String readRespData= "";
    String? result;
    double progress = 0;
    String pipeSeperatedString;
    var body;
    var wifiIp;
    ResponseConfig resp = ResponseConfig();
    var ipAdd = "";
    PaymentReq payment;

    String compURL;
    String? devicemodel ;
    String? deviceVersion ;
    var devicePlatform ="";
    var pluginName="";
    var pluginVersion="";
    String? pluginPlatform;

    text =
    await DefaultAssetBundle.of(context).loadString('assets/appconfig.json');
    final jsonResponse = json.decode(text);
    var t_id = jsonResponse["terminalId"] as String;
    var t_pass = jsonResponse["terminalPass"] as String;
    var merc = jsonResponse["merchantKey"] as String;
    var req_url = jsonResponse["requestUrl"] as String;
    Constantvals.termId = t_id;
    Constantvals.termpass = t_pass;
    Constantvals.merchantkey = merc;
    Constantvals.requrl = req_url;


    /**
     * Connectivity is checked as there is server call*/
    var connectivityResult = await (Connectivity().checkConnectivity());
    //print(connectivityResult);
    if (connectivityResult == ConnectivityResult.mobile) {

      final ipv4 = await Ipify.ipv4();
      ipAdd = ipv4;

    } else if (connectivityResult == ConnectivityResult.wifi) {

      final ipv4 = await Ipify.ipv4();
      ipAdd = ipv4;

    }
    else {
      print("Unable to connect. Please Check Internet Connection");
    }

    String ipAdd1;

    if (isValidationSucess(
        context,
        amt,
        customerEmail,
        action,
        country,
        currency,
        trackid,
        tokenOperation,
        cardToken)) {

      pipeSeperatedString =
          trackid + "|" + Constantvals.termId + "|" + Constantvals.termpass +
              "|" +
              Constantvals.merchantkey + "|" + amt + "|" + currency;

      var bytes = utf8.encode(pipeSeperatedString);
      Digest sha256Result = sha256.convert(bytes);
      final digestHex = hex.encode(sha256Result.bytes);

      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      String appName = packageInfo.appName;
      // String apppackageName = packageInfo.packageName;
      String appversion = packageInfo.version;
      // String buildNumber = packageInfo.buildNumber;

      try {
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

        if (Platform.isAndroid) {
          AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

          devicemodel=androidInfo.model;
          deviceVersion= androidInfo.version.sdkInt.toString();
          devicePlatform="android";
          pluginName="FlutterAndroid";
          pluginVersion = appversion;
          pluginPlatform = "Mobile";
        }
        else if (Platform.isIOS) {
          IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
          devicemodel=iosInfo.model;
          deviceVersion=iosInfo.systemVersion;
          devicePlatform="ios";
          pluginName="Flutterios";
          pluginVersion = appversion;
          pluginPlatform = iosInfo.systemVersion;

        }
      } on PlatformException catch (e){
        print('error caught: $e');

      }
      DeviceDetailsModel detailsModel =new DeviceDetailsModel(devicemodel: devicemodel, deviceVersion: deviceVersion, devicePlatform: devicePlatform, pluginName: pluginName, pluginVersion: pluginVersion, pluginPlatform: pluginPlatform);
      var devicebody = json.encode(detailsModel.toMap());

      if (action == '1' || action == '4') { //Purchase and Pre Auth
        payment = new PaymentReq(terminalId: t_id,
            password: t_pass,
            action: action,
            currency: currency,
            customerEmail: customerEmail,
            country: country,
            amount: amt,
            customerIp: ipAdd,
            merchantIp: ipAdd,

            trackid: trackid,
            udf1: udf1,
            udf2: udf2,
            udf3: udf3,
            udf4: udf4,
            udf5: udf5,
            instrumentType: "DEFAULT",

            address: address,
            city: city,
            zipCode: zipCode,
            state: state,
            cardToken: cardToken,
            tokenizationType: tokenizationType,
            requestHash: digestHex, tokenOperation: '',
            udf7: '',
            deviceinfo: devicebody,
            metaData:metadata
        );
        body = json.encode(payment.toMap());

      }
      else if (action == '12') //tokenization
          {
        PayTokenizeReq payTokenize = new PayTokenizeReq(terminalId: t_id,
            password: t_pass,
            action: action,
            currency: currency,
            customerEmail: customerEmail,
            country: country,
            amount: amt,
            customerIp: ipAdd,
            merchantIp: ipAdd,

            trackid: trackid,
            udf1: udf1,
            udf2: udf2,
            udf3: udf3,
            udf4: udf4,
            udf5: udf5,

            cardToken: cardToken,
            requestHash: digestHex,
            tokenOperation: tokenOperation,
            udf7: '',
            deviceinfo: devicebody,
            metaData: metadata
        );
        body = json.encode(payTokenize.toMap());
      }
      else if (action == '14') { //Standalone Refund
        PayRefundReq payRefundReq = new PayRefundReq(
            terminalId: t_id,
            password: t_pass,
            action: action,
            currency: currency,
            customerEmail: customerEmail,
            country: country,
            amount: amt,
            customerIp: ipAdd,
            merchantIp: ipAdd,

            trackid: trackid,
            udf1: udf1,
            udf2: udf2,
            udf3: udf3,
            udf4: udf4,
            udf5: udf5,
            cardToken: cardToken,
            requestHash: digestHex, udf7: '',
            deviceinfo: devicebody,
            metaData: metadata);
        body = json.encode(payRefundReq.toMap());
      }
      else if (action == "13") {
        PaySTC paySTC = new PaySTC(
            terminalId: t_id,
            password: t_pass,
            action: action,
            currency: currency,
            customerEmail: customerEmail,
            amount: amt,
            customerIp: ipAdd,
            merchantIp: ipAdd,
            trackid: trackid,
            udf2: udf2,
            country: country,
            udf3: udf3,
            udf1: udf1,
            udf5: udf5,
            udf4: udf4,
            requestHash: digestHex, udf7: '',
            deviceinfo: devicebody,
            metaData: metadata);

        body = json.encode(paySTC.toMap());
      }

      try {
        //  _writetoFile("Request " + body + "\n");
        Map<String, String> headers = {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        };
        print(Constantvals.requrl);
        print(body);
        var requrl = Uri.parse(Constantvals.requrl);
        var response = await http.post(
            requrl, headers: headers, body: body);
        print(requrl);
        print(response);
        /**
         * Response is checked */
        if (response.statusCode == 200) {

          var data = json.decode(response.body);
          var payId = data["payid"] ?? "";
          var tar_url = data["targetUrl"] ?? "";
          var resp_code = data["responseCode"] ?? "";

          if (tar_url != null && !tar_url.isEmpty) {


            //Todo check for ? if already there then don put
            if (tar_url.endsWith('?')) {
              compURL = tar_url + "paymentid=" + payId;
            }

            else {
              compURL = tar_url + "?paymentid=" + payId;
            }


            result = (await Navigator.of(context).push(
                MaterialPageRoute<String>(builder: (BuildContext context) {
                  return new TransactWebpage(inURL: compURL);
                }))) ?? ''  ;
            // _writetoFile(" Response from Hosted Page :  " + result + "\n");
            print(result);
            if(result == null  )
            {
              Navigator.of(context)
                  .pop();
              ResponseConfig.startTrxn = false;
            }
            else
            {
              ResponseConfig.startTrxn = false;
              readRespData = result;
            }


          }
          else if (tar_url == null && resp_code == '000') {
            var pay=null;

            ResponseConfig.startTrxn = false;

            var data = json.decode(response.body);
            Map<String, dynamic> mapdata = data;

            mapdata.forEach((key, value) {

              String strvalue = value.toString();

              if(strvalue == null || strvalue == "null")
              {
                value='';
                mapdata.update(key, (value) => value);
              }



            });

            String data1 = mapdata.toString();

            readRespData = data;
          }
          else {

            ResponseConfig.startTrxn = false;

            var responseData = response.body;
            var data = json.decode(response.body);
            Map<String, dynamic> mapdata = data;

            mapdata.forEach((key, value) {

              String strvalue = value.toString();

              if(strvalue == null || strvalue == "null") {
                value = '';


                mapdata.update(key, (value) => '');
              }



            });

            String data1 = mapdata.toString();

            readRespData = responseData;
          }
        }
        else {

          String respCode = response.statusCode.toString();
          //_writetoFile("Response :" + body + "\n");
          showalertDailog(context, 'Error', 'Invalid Request with $respCode');
        }
      }
      on Exception catch(e) {

        print('error caught: $e');

        ResponseConfig.startTrxn = false;
        showalertDailog(context, 'Internet Connection',
            'Please check your Internet Connection $e ');

      }
    }
    else {

      ResponseConfig.startTrxn = false;
    }

    return readRespData;
  }


  /***
   * This method is used to validate Data passes to perform Transaction Details
   * */
  static bool isValidationSucess(BuildContext context, String amount,
      String email, String Action, String CountryCode, String Currency,
      String track, String cardOperation, String cardToken)
  {
    bool d = false;

    final bool isValidEmail = EmailValidator.validate(email);
    bool isValidE = isValidEmailchk(email);

    if (amount.isEmpty) {
      showalertDailog(context, 'Error', 'Amount should not be empty');
      ResponseConfig.startTrxn = false;
    }
    else if (email.isEmpty) {
      showalertDailog(context, 'Error', 'Email should not be empty');
      ResponseConfig.startTrxn = false;
    }
    else if (Action.isEmpty || Action.length == 0) {
      showalertDailog(context, 'Error', 'Action Code should not be empty');
      ResponseConfig.startTrxn = false;
    }

    else if (Currency.isEmpty || Currency.length == 0) {
      showalertDailog(context, 'Error', 'Currency should not be empty');
      ResponseConfig.startTrxn = false;
    }
    else if (CountryCode.isEmpty || CountryCode.length == 0) {
      showalertDailog(context, 'Error', 'Country Code should not be empty');
      ResponseConfig.startTrxn = false;
    }
    else if (track.isEmpty || track.length == 0) {
      showalertDailog(context, 'Error', 'Track ID should not be empty');
      ResponseConfig.startTrxn = false;
    }
    else if (Currency.length > 3) {
      showalertDailog(context, 'Error', 'Currency should be proper');
      ResponseConfig.startTrxn = false;
    }

    else if (Action.length > 3) {
      showalertDailog(context, 'Error', 'Action Code should be proper ');
      ResponseConfig.startTrxn = false;
    }
    else if (CountryCode.length > 2) {
      showalertDailog(context, 'Error', 'CountryCode should be proper');
      ResponseConfig.startTrxn = false;
    }
    else if (email.isEmpty) {
      showalertDailog(context, 'Error', 'Email should not be empt');
      ResponseConfig.startTrxn = false;
    }
    else if (!email.isEmpty && (isValidEmail == false)) {
      showalertDailog(context, 'Error', 'Email should be proper');
      ResponseConfig.startTrxn = false;
    }
    else
    if (((Action == '12') && (cardOperation == 'U')) && (cardToken.isEmpty)) {
      showalertDailog(context, 'Error', 'Card Token should not be empty');
      ResponseConfig.startTrxn = false;
    }
    else if ((Action == '12') && (cardOperation == 'D') && cardToken.isEmpty) {
      showalertDailog(context, 'Error', 'Card Token should not be empty');
      ResponseConfig.startTrxn = false;
    }

    else if ((Action == "14") && (cardToken.isEmpty)) {
//      alert.showAlertDialog(context, "Invalid Refund", "Card Token Should not be empty ", false);
      showalertDailog(
          context, 'Invalid Refund', 'Card Token should not be empty ');
      ResponseConfig.startTrxn = false;
    }
    else {
      d = true;
    }
    return d;
  }


  /**
   * This method is used to display Alert for invalid or error response*/
  static void showalertDailog(BuildContext context, String title,
      String description) {
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[

          Container(

            margin: EdgeInsets.only(top: Constantvals.marginTop),

            child: Column(
              mainAxisSize: MainAxisSize.min, // To make the card compact
              children: <Widget>[

                Text(
                  title,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 24.0),
                Align(
                  alignment: Alignment.center,

                  child: ElevatedButton(



                    onPressed: () {
                      Navigator.of(context)
                          .pop(); // To close the dialTraog//todo close plugin
                      ResponseConfig.startTrxn = false;
                    },
                    child: Text('OK'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      elevation: 10,
    );
    showDialog(
      context: context,

      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static bool isValidEmailchk(String emailCheck) {

    Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@[a-z]+\.+[a-z]$';
    RegExp regExp = new RegExp(pattern.toString());
    bool chk = regExp.hasMatch(emailCheck);
    return chk;
  }


  /**
   *  This method is use to perform Apple Pay transaction From Customer UserInterface
   */
  static Future<String> makeapplepaypaymentService({
    required BuildContext context, required String country, required String action, required String currency, required String amt, required String customerEmail, required String trackid, required String udf1, required  String udf2, required String udf3, required String udf4, required String udf5, required String tokenizationType, required String merchantIdentifier, required String shippingCharge, required String companyName,required String metadata
  }) async {
    assert(context != null, "context is null!!");
    dynamic applePaymentData;
    String appleRespdata="";


    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {


        try {

          if (companyName.isEmpty) {
            showalertDailog(context, 'Error','Company Name should not be empty');
            ResponseConfig.startTrxn = false;
          }
          else if (shippingCharge.isEmpty) {
            showalertDailog(context, 'Error','Shipping Charges should not be empty');
            ResponseConfig.startTrxn = false;
          }
          else {

            var dblamt = double.parse(amt);
            var dblshippingcharge = double.parse(shippingCharge);

            List<PaymentItem> paymentItems1 = [
              PaymentItem(label: 'Label', amount: dblamt,shippingcharge: dblshippingcharge)
            ];

            // initiate payment
            applePaymentData = await ApplePayFlutter.makePayment(
              countryCode: country,
              currencyCode: currency,
              paymentNetworks: [
                PaymentNetwork.visa,
                PaymentNetwork.mastercard,
                PaymentNetwork.amex,
                PaymentNetwork.mada
              ],
              merchantIdentifier: merchantIdentifier,
              paymentItems: paymentItems1,
              customerEmail: customerEmail,
              customerName: "Demo User",
              companyName: companyName,

            );
            // _writetoFile(" Apple token Data :" + applePaymentData.toString());
          }
        }
        on PlatformException  catch(e){
          print('error caught: $e');
          print('Failed payment');
        }
        var totalcharge= double.parse(amt)+double.parse(shippingCharge);
        String strtlchr=totalcharge.toString();


        if(applePaymentData.toString().contains("code"))
        {
          return "";
        }
        else {
          var order = await applepayapi(
              context,
              country,
              action,
              currency,
              strtlchr,
              customerEmail,
              trackid,
              udf1,
              udf2,
              udf3,
              udf4,
              udf5,
              tokenizationType,
              applePaymentData,metadata);

          appleRespdata = order;
        }
      }
    }
    on SocketException catch (e) {
      print('error caught: $e');

      ResponseConfig.startTrxn = false;
      //appleRespdata = "Please check internet connection";

      showalertDailog(context, 'Alert', "Please check Internet Connection");
    }

    return appleRespdata;
  }

  /**
   *  This method is use to perform Apple Pay transaction in merchant PG
   */
  static Future<String> applepayapi(BuildContext context, String country,
      String action, String currency, String amt, String customerEmail,
      String trackid, String udf1, String udf2, String udf3, String udf4,
      String udf5, String tokenizationType, dynamic appleToken , String metadata) async {
    String text;
    String RespData ="";


    String pipeSeperatedString;

    ResponseConfig resp = ResponseConfig();
    var ipAdd;

    dynamic paymentTokk;
    text =
    await DefaultAssetBundle.of(context).loadString('assets/appconfig.json');
    final jsonResponse = json.decode(text);

    var t_id = jsonResponse["terminalId"] as String;
    var t_pass = jsonResponse["terminalPass"] as String;
    var merc = jsonResponse["merchantKey"] as String;
    var req_url = jsonResponse["requestUrl"] as String;
    Constantvals.termId = t_id;
    Constantvals.termpass = t_pass;
    Constantvals.merchantkey = merc;
    Constantvals.requrl = req_url;

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {

      final ipv4 = await Ipify.ipv4();


      ipAdd = ipv4;


    } else if (connectivityResult == ConnectivityResult.wifi) {

      try {

        final ipv4 = await Ipify.ipv4();

        ipAdd = ipv4;

      } on PlatformException  catch (e){
        print('error caught: $e');
        print('Failed to get broadcast IP.');
      }

    }
    else {
      print("Unable to connect. Please Check Internet Connection");
    }


    if (isValidationSucess(
        context,
        amt,
        customerEmail,
        action,
        country,
        currency,
        trackid,
        "",
        ""))
    {
      if(["", null].contains(appleToken['paymentData']) )
      {

      }
      else
      {
        paymentTokk = jsonDecode(appleToken['paymentData']) ?? "empty" ;
      }

      pipeSeperatedString =
          trackid + "|" + Constantvals.termId + "|" + Constantvals.termpass +
              "|" +
              Constantvals.merchantkey + "|" + amt + "|" + currency;

      var bytes = utf8.encode(pipeSeperatedString);
      Digest sha256Result = sha256.convert(bytes);
      final digestHex = hex.encode(sha256Result.bytes);

      try {
        var jsonBody = jsonEncode({

          'instrumentType': 'DEFAULT',
          'customerEmail': customerEmail,
          'customerName': "",
          'trackid': trackid,
          'action': 1,
          'merchantIp': ipAdd,
          'terminalId': Constantvals.termId,
          'password': Constantvals.termpass,
          'amount': amt,
          'country': country,
          'currency': currency,
          'customerIp': ipAdd,
          "udf4": "ApplePay",
          "udf5": jsonEncode({
            "paymentData": paymentTokk,
            "transactionIdentifier": appleToken['transactionIdentifier'],
            "paymentMethod": appleToken['paymentMethod']
          }).replaceAll('\\', ''),
          'applePayId': 'applepay',
          'metaData' : metadata,

          'requestHash': sha256.convert(utf8.encode(pipeSeperatedString))
              .toString()
        });
        var requrl = Uri.parse(Constantvals.requrl);
        final response = await http.post(
          requrl,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonBody,
        );

        //  _writetoFile("Request apple pay :" + jsonBody + "\n");

        if (response.statusCode == 200) {
          //  _writetoFile("Response apple pay  1:" + response.body.toString() + "\n");
          var data = json.decode(response.body);
          var payId = data["tranid"] as String;

          var resp_code = data["responseCode"] as String;

          if (resp_code == '000') {
            var jsonBody = jsonEncode({
              'transid': payId,
              'trackid': trackid,
              'instrumentType': 'DEFAULT',
              'customerEmail': customerEmail,
              'customerName': "",
              'action': 10,
              'merchantIp': ipAdd,
              'terminalId': Constantvals.termId,
              'password': Constantvals.termpass,
              'amount': amt,
              'country': country,
              'currency': currency,
              'customerIp': ipAdd,
              "udf1": "",
              "udf3": "",
              "udf4": "",
              "udf5": "",
              "udf2": "",
              'metaData' : metadata,
              'requestHash': sha256.convert(utf8.encode(pipeSeperatedString)).toString()
            });
            var requrl = Uri.parse(Constantvals.requrl);
            final response = await http.post(
              requrl,
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonBody,
            );

            if (response.statusCode == 200) {

              //    _writetoFile("Response apple pay Enquiry :" + response.body.toString() + "\n");
              var data = json.decode(response.body);
              var resp1 = json.encode(data);
              ResponseConfig.startTrxn = false;
              //  _writetoFile(" Response from Hosted Page :  " + resp1 + "\n");
              return resp1;
            }
            else {

              var ErrorMsg;
              var apirespCode = data["responseCode"] as String;
              if (apirespCode == null) {
                apirespCode = data["responsecode"] as String;
                ErrorMsg = resp.respCode['$apirespCode'];
              }
              else {
                ErrorMsg = resp.respCode['$apirespCode'];
              }
              var apiresult = data["result"] as String;
              // _writetoFile(
              //     " Response from Hosted Page :  " + apirespCode + " : " +
              //         ErrorMsg + "\n");

              showalertDailog(context, '$apiresult', '$ErrorMsg');
            }
          }
          else {
            // var data = json.decode(response.body);
            var data = json.decode(response.body);
            var resp1 = json.encode(data);
            ResponseConfig.startTrxn = false;
            //  _writetoFile(" Response from Hosted Page :  " + resp1 + "\n");
            return resp1;

            // var resp_code = data["responseCode"] as String;
            //
            // _writetoFile("Response :" + resp_code + "\n");
            // showalertDailog(context, 'Error', 'Invalid Request with $resp_code');
          }
        }
      }
      on Exception catch (e)
      {
        print('error caught: $e');
        ResponseConfig.startTrxn = false;
        showalertDailog(context, 'Internet Connection',
            'Please check   $e');
      }
    }
    else
    {
      ResponseConfig.startTrxn = false;
    }

    return RespData;
  }
}

