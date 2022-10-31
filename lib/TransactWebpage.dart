import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import 'Model/RespDataModel.dart';
import 'ResponseConfig.dart';

class TransactWebpage extends StatefulWidget {

  final String inURL;

  const TransactWebpage({Key? key,required this.inURL}) : super(key: key);

  @override
  _TransactWebpageState createState() => _TransactWebpageState();
}

class _TransactWebpageState extends State<TransactWebpage> {
  WebViewPlusController? _controller;
  double _progress = 0.0;
  String url = "";
  List<RespDataModel> resSplitData = [];

  Future<bool> _onBackPressed() async {

    ResponseConfig.startTrxn = false;
    Navigator.of(context).pop(true);
    return Future.value(false);
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.blueGrey, //or set color with: Color(0xFF0000FF)
    ));
    return new WillPopScope(
      onWillPop: _onBackPressed,
      child:
      SafeArea(
          child: Container(
            margin: const EdgeInsets.all(1.0),
            child: WebViewPlus(
              initialUrl: widget.inURL,
              debuggingEnabled: true,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (controller) {
                _controller = controller;
              },
              onPageStarted: (url) {
                setState(() {
                  this.url = url.toString();
                  // print(this.url);
                });
              },

              onPageFinished: (url) {
                // print(this.url)
                var disurl = url.toString();
                if (disurl.contains("&Result")) {
                  List<String> arr = url.toString().split('?');
                  var resData = arr[1];
                  // print('RES DATA $resData');
                  //String lastData=splitResponse(arr[1]);

                  List<RespDataModel> mapData = RespJson(arr[1]);
                  // print('Transact List $mapData');


                  var map1 = Map.fromIterable(
                      mapData, key: (e) => e.resKey, value: (e) => e.resValue);
                  // print(map1);
                  Navigator.pop(context, '$map1');
                }

              },
              onProgress: (progress) {
                setState(() {
                  _progress = (progress / 100) as double;
                });
              },


            ),
          )
      ),
    );
  }
    List<RespDataModel> RespJson(String resultData) {
      List<String> resultParameters = resultData.split("&");


      for(final params in resultParameters){

        List parts = params.split("=");
        String key = parts[0];
        String value = parts[1];

        if([null,"null"].contains(parts[1]))
        {
          value= "";
        }

        var productMap = {

          key: value,

        };

        resSplitData.add(RespDataModel(resKey: key, resValue: value));
      }
      ResponseConfig.startTrxn = false;
      return resSplitData;


    }

  }
