import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:webview_flutter/webview_flutter.dart';

import 'Model/RespDataModel.dart';
import 'ResponseConfig.dart';

class TransactWebpage extends StatefulWidget {

  final String inURL;

  const TransactWebpage({Key? key,required this.inURL}) : super(key: key);

  @override
  _TransactWebpageState createState() => _TransactWebpageState();
}

class _TransactWebpageState extends State<TransactWebpage> {
  late WebViewController _controller;

  double _progress = 0.0;
  String url = "";
  List<RespDataModel> resSplitData = [];

  Future<bool> _onBackPressed() async {
  //   print("In TRANSACT WEB ");
  //   ResponseConfig.startTrxn = false;
  //   Navigator.pop(context, null);
  // //  Navigator.of(context).pop(true);
  //   return Future.value(false);

    bool willLeave = false;
    // show the confirm dialog
    await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text("Do you want to go back"),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, null),
                child: const Text('No')),
            TextButton(
                onPressed: () {
                  willLeave = true;
                  Navigator.pop(context, null);
                  ResponseConfig.startTrxn = false;

                },
                child: const Text('Yes')),

          ],
        ));
    return willLeave;
  }

  @override
  void initState() {
    super.initState();
    // Initialize WebViewController
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (String url) {
          setState(() {
            this.url = url;
          });
        },
        onPageFinished: (String url) {
          var disurl = url.toString();
          if (disurl.contains("&Result")) {
            List<String> arr = url.split('?');
            var resData = arr[1];
            print('RES DATA $resData');
            String mapData = RespJson(arr[1]);
            print(mapData);
            Navigator.pop(context, '$mapData');
          }
        },
      ))
      ..loadRequest(Uri.parse(widget.inURL));
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.blueGrey, //or set color with: Color(0xFF0000FF)
    ));
    return PopScope(
      onPopInvoked: (shouldLeave) async {
        bool willLeave = await _onBackPressed();
        if (willLeave) {
          shouldLeave = true; // Pass the decision to the callback
        }
      },
      child:
      Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(
              color: Colors.black, // <-- SEE HERE
            ),
            title: const Text('Payment', style: TextStyle(color: Colors.black)),
          ),
          body:  Stack(
            children: [
              WebViewWidget(controller: _controller),
              if (_progress < 1) LinearProgressIndicator(value: _progress),

            //   WebView(
            // initialUrl: widget.inURL,
            // onWebViewCreated: (WebViewController webViewController) {
            //   _controller = webViewController;
            // },
            //   onPageStarted: (String url) {
            //     setState(() {
            //       this.url = url.toString();
            //       // print(this.url);
            //     });
            //   },
            //
            //   onPageFinished: (String url) {
            //    // print(this.url);
            //     var disurl = url.toString();
            //     if (disurl.contains("&Result")) {
            //       List<String> arr = url.toString().split('?');
            //       var resData = arr[1];
            //       print('RES DATA $resData');
            //       //String lastData=splitResponse(arr[1]);
            //
            //      String mapData = RespJson(arr[1]);
            //     print(mapData);
            //       // // print('Transact List $mapData');
            //       //
            //       //
            //       // var map1 = Map.fromIterable(
            //       //     mapData, key: (e) => e.resKey, value: (e) => e.resValue);
            //       // print(map1);
            //       Navigator.pop(context, '$mapData');
            //     }
            //
            //   },
            //   onProgress: (progress) {
            //     setState(() {
            //       _progress = (progress / 100) as double;
            //     });
            //   }, controller: null,
            //
            // ),
],
          ),
      ),
    );
  }
   String RespJson(String resultData) {
      List<String> resultParameters = resultData.split("&");
      var responseData = {};
      //Map<String, String> map = {};

      for(final params in resultParameters){

        //
        // List<String> keyValue = params.split('=');
        // if (keyValue.length == 2) {
        //   map[keyValue[0]] = Uri.decodeComponent(keyValue[1]);
        // } else if (keyValue.length == 1) {
        //   map[keyValue[0]] = "";
        // }

        List parts = params.split("=");
        String key = parts[0];
        String value = parts[1];

        if([null,"null"].contains(parts[1]))
        {
          value= "";
        }

      //   metadata["entryone"] = metadata1;

        if("metaData".contains(key))
          {
            String strdecoded=value;
           //print(strdecoded);
          //   String decoded = utf8.decode(base64.decode(strdecoded));
          //  print(decoded);

            String strMetadata = strdecoded.split('.')[0];
            List<int> res = base64.decode(base64.normalize(strMetadata));

           String metadata = utf8.decode(res);

            resSplitData.add(RespDataModel(resKey: "metaData", resValue: metadata));
            responseData["metaData"] = metadata;
          }
        else{
        //  print(value);
          resSplitData.add(RespDataModel(resKey: key, resValue: value));
          responseData[key] = value;
        }

        // var productMap = {
        //
        //   key: value,
        //
        // };

      // resSplitData.add(RespDataModel(resKey: key, resValue: value));
      }

      String metaJson = json.encode(responseData);
      // String metaJson = encoder.convert(metadata);
     // print('Json REsponse Data $metaJson');
      ResponseConfig.startTrxn = false;
    //  print('REsponse  $resSplitData ');
      return metaJson;


    }

  }

