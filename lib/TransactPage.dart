//
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:urwaypayment/Model/RespDataModel.dart';
// import 'package:urwaypayment/Model/TrxnRespModel.dart';
// import 'package:urwaypayment/ResponseConfig.dart';
// import 'package:flutter/services.dart';
//
//
// class TransactPage extends StatefulWidget {
//
//   final String inURL;
//   TransactPage({Key? key,required this.inURL}):super(key:key);
//
//   @override
//   _TransactPageState createState() => _TransactPageState();
// }
//
//
// /**
//  *
//  * This Class is  used to handle the response  from UrwayPayments*/
// class _TransactPageState extends State<TransactPage> {
//   InAppWebViewController? webViewController;
//   String url = "";
//   double progress = 0;
//   late String payId;
//   late String responseHash;
//   late String ResponseCode;
//   late String transId;
//   late String amount;
//   late String cardToken;
//   late String cardBrand;
//   late String maskedCardNo;
//   late String result;
//
//   late Map<String, dynamic> map;
//
//   List<RespDataModel> resSplitData = [];
//
//
//
//   Future<bool> _onBackPressed() async {
//     // Your back press code here...
//     ResponseConfig.startTrxn = false;
//     Navigator.pop(context, true);
//     return Future.value(false);
//   }
// //  @override
// //  void initState() {
// //    // TODO: implement initState
// //    super.initState();
// //    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
// //  }
//   @override
//   Widget build(BuildContext context) {
//     // pr = new ProgressDialog(context,);
//     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//       statusBarColor: Colors.blueGrey, //or set color with: Color(0xFF0000FF)
//     ));
//     // pr.style(
//     //     message: 'Please wait...',
//     //     borderRadius: 10.0,
//     //     backgroundColor: Colors.white,
//     //     progressWidget: CircularProgressIndicator(),
//     //
//     //     elevation: 10.0,
//     //     insetAnimCurve: Curves.easeInOut,
//     //     progress: 0.0,
//     //     maxProgress: 100.0,
//     //     progressTextStyle: TextStyle(
//     //         color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
//     //     messageTextStyle: TextStyle(
//     //         color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
//     // );
//     return new WillPopScope(
//       onWillPop: _onBackPressed,
//       child:
//       SafeArea(
//         child:Container(
//           margin: const EdgeInsets.all(1.0),
//           child: InAppWebView(
//             initialUrlRequest:
//             URLRequest(url: Uri.parse(widget.inURL)),
//
//
// //                    initialOptions: InAppWebViewWidgetOptions(
// //                        inAppWebViewOptions: InAppWebViewOptions(
//                          debuggingEnabled: true,
//                        )
// //                    ),
//             onWebViewCreated: (InAppWebViewController controller) {
//               webViewController = controller;
//               //  pr.show();
//
//             },
//
//             onLoadStart: (InAppWebViewController controller, Uri? url) {
//               setState(()
//               {
// //            pr.show();
//                 this.url = url.toString();
//               });
//             },
//
//             onLoadStop: (InAppWebViewController controller, Uri? url) async {
//               print(this.url);
//               // int result1 = await controller.evaluateJavascript(source: "10 + 20;");
//               // print(result1);
//               var disurl=url.toString();
//               print('Transact URl  $disurl');
//               //pr.hide();
//               if (disurl.contains("&Result")) {
//
// //            RegExp regExp = new RegExp("Result=(.*)&Track");
// //            token = regExp.firstMatch(url).group(1);
//                 List<String> arr = url.toString().split('?');
//                 var resData=arr[1];
//                 print('RES DATA $resData');
//                 //String lastData=splitResponse(arr[1]);
//
//                 List<RespDataModel> mapData = tomyJson(arr[1]);
//                 print('Transact List $mapData');
//
//
//                 var map1 = Map.fromIterable(mapData, key: (e) => e.resKey, value: (e) => e.resValue);
//                 print(map1);
//
//                 //    Map<String, dynamic> map = mapData.asMap();
//
//                 //  print('Transact mapData $map');--------------------
//
//
//
//                 Navigator.pop(context, '$map1');
//
// //
// //            showResDialog( context);
// //                            Navigator.of(context, rootNavigator: true)
// //                                .push(MaterialPageRoute(
// //                                builder: (context) => new HomePage()));
//
//               }
//             },
//             onProgressChanged: (InAppWebViewController controller, int progress) {
//               setState(() {
//                 this.progress = progress / 100;
//               });
//             },
//           ),
//         ),
//       ),
//
//     );
//   }
//
//   String splitResponse(String resultData)
//   {
//
//
//     print('splitResponse $resultData');
//     List<String> resultParameters=resultData.split("&");
//     for (String parameter in resultParameters) {
//       List parts = parameter.split("=");
//       String name = parts[0];
//       print("parameters[] name=" + name);
//       if (name=="PaymentId") {
//         print("name pay id " + name);
//         payId = parts[1].toString();
//         print("name pay id " + parts[1]);
//       }
//       if (name=="responseHash") {
//         print("name response hash " + name);
//         responseHash = parts[1].toString();
//         print('name response hash $parts[1]');
//       }
//       if (name=="ResponseCode") {
//         print("name pay id " + name);
//         ResponseCode = parts[1].toString();
//         print("name pay id " + parts[1]);
//       }
//       if (name == "TranId") {
//         print("name pay id " + name);
//         transId = parts[1].toString();
//         print("name pay id " + parts[1]);
//       }
//       if (name=="amount") {
//         print("name pay id " + name);
//         amount = parts[1].toString();
//         print("name pay id " + parts[1]);
//       }
//
//       if (name=="cardToken") {
//         print("name pay id " + name);
//         cardToken = parts[1].toString();
//         print("name pay id " + parts[1]);
//       }
//       if (name=="cardBrand") {
//         print("name pay id " + name);
//         cardBrand = parts[1].toString();
//         print("name pay id " + parts[1]);
//       }
//       if (name=="Result") {
//         print("Result " + name);
//         result = parts[1].toString();
//         print("name pay id " + parts[1]);
//       }
//
//       if (name=="maskedPAN")
//       {
//         print("name pay id " + name);
//         maskedCardNo = parts[1].toString();
//         print("name pay id " + parts[1]);
//       }
//     }
//     TrxnRespModel trxnRespModel=new TrxnRespModel(tranId: payId,responseCode: ResponseCode,amount: amount,result:result ,cardToken: cardToken,cardBrand: cardBrand,maskedPanNo: maskedCardNo,ResponseMsg: "");
//     var resp= json.encode(trxnRespModel.toMap());
//     print("TRANSACT RESP $resp");
//     ResponseConfig.startTrxn = false;
//     return resp;
//
//   }
//
//   List<RespDataModel> tomyJson(String resultData) {
//     List<String> resultParameters = resultData.split("&");
//     //
//     // for (String parameter in resultParameters) {
//     //   List parts = parameter.split("=");
//     //   String key = parts[0];
//     //   String value = parts[1];
//     //   map = {
//     //     key: value,
//     //
//     //   };
//
//     for(final params in resultParameters){
//
//       List parts = params.split("=");
//       String key = parts[0];
//       String value = parts[1];
//
//       if([null,"null"].contains(parts[1]))
//       {
//         value= "";
//       }
//
//       var productMap = {
//
//         key: value,
//
//       };
//
//       resSplitData.add(RespDataModel(resKey: key, resValue: value));
//     }
//
//     print('final list of resSplitData');
//     print(resSplitData);
//
//     return resSplitData;
//
//
//   }
//
// }
