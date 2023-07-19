import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

// import 'package:webview_flutter_plus/webview_flutter_plus.dart';
// #docregion platform_imports
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';

// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
// #enddocregion platform_imports

import 'Model/RespDataModel.dart';
import 'ResponseConfig.dart';

class TransactWebpage extends StatefulWidget {

  final String inURL;

  const TransactWebpage({Key? key, required this.inURL}) : super(key: key);

  @override
  _TransactWebpageState createState() => _TransactWebpageState();
}

class _TransactWebpageState extends State<TransactWebpage> {
  // WebViewPlusController? _controller;
  double _progress = 0.0;
  String url = "";
  List<RespDataModel> resSplitData = [];
  late final WebViewController _controller;

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
        builder: (_) =>
            AlertDialog(
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
    // TODO: implement initState
    super.initState();
    // #docregion platform_features
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _handleWebViewConfig();
    });
  }

  void _handleWebViewConfig() {
    // #docregion platform_features
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
    WebViewController.fromPlatformCreationParams(params);
    // #enddocregion platform_features

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
    // ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
            setState(() {
              _progress = (progress / 100) as double;
            });
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
            setState(() {
              this.url = url.toString();
              // print(this.url);
            });
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
            // print(this.url);
            var disurl = url.toString();
            if (disurl.contains("&Result")) {
              List<String> arr = url.toString().split('?');
              var resData = arr[1];
              // print('RES DATA $resData');
              //String lastData=splitResponse(arr[1]);

              String mapData = RespJson(arr[1]);
              // print(mapData);
              // // print('Transact List $mapData');
              //
              //
              // var map1 = Map.fromIterable(
              //     mapData, key: (e) => e.resKey, value: (e) => e.resValue);
              // print(map1);
              Navigator.pop(context, '$mapData');
            }
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
                      Page resource error:
                        code: ${error.errorCode}
                        description: ${error.description}
                        errorType: ${error.errorType}
                        isForMainFrame: ${error.isForMainFrame}
                                ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            // if (request.url.startsWith('https://www.youtube.com/')) {
            //   debugPrint('blocking navigation to ${request.url}');
            //   return NavigationDecision.prevent;
            // }
            debugPrint('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) {
            debugPrint('url change to ${change.url}');
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text(message.message)),
          // );
        },
      )
      ..loadRequest(Uri.parse(widget.inURL));

    // #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    // #enddocregion platform_features

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.blueGrey, //or set color with: Color(0xFF0000FF)
    ));
    return new WillPopScope(
      onWillPop: _onBackPressed,
      child:
      Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(
              color: Colors.black, // <-- SEE HERE
            ),
            title: const Text('Payment', style: TextStyle(color: Colors.black)),
          ),
          body: Container(
            margin: const EdgeInsets.all(1.0),
            child: WebViewWidget(controller: _controller)/*WebViewPlus(
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
               // print(this.url);
                var disurl = url.toString();
                if (disurl.contains("&Result")) {
                  List<String> arr = url.toString().split('?');
                  var resData = arr[1];
                  // print('RES DATA $resData');
                  //String lastData=splitResponse(arr[1]);

                 String mapData = RespJson(arr[1]);
                // print(mapData);
                  // // print('Transact List $mapData');
                  //
                  //
                  // var map1 = Map.fromIterable(
                  //     mapData, key: (e) => e.resKey, value: (e) => e.resValue);
                  // print(map1);
                  Navigator.pop(context, '$mapData');
                }

              },
              onProgress: (progress) {
                setState(() {
                  _progress = (progress / 100) as double;
                });
              },
            )*/,
          )
      ),
    );
  }

  String RespJson(String resultData) {
    List<String> resultParameters = resultData.split("&");
    var responseData = {};

    for (final params in resultParameters) {
      List parts = params.split("=");
      String key = parts[0];
      String value = parts[1];

      if ([null, "null"].contains(parts[1])) {
        value = "";
      }

      // metadata["entryone"] = metadata1;

      if ("metaData".contains(parts[0])) {
        String strdecoded = parts[1];
        //   print(strdecoded);
        // String decoded = utf8.decode(base64.decode(strdecoded));
        // print(decoded);

        String strMetadata = strdecoded.split('.')[0];
        List<int> res = base64.decode(base64.normalize(strMetadata));

        String metadata = utf8.decode(res);

        resSplitData.add(RespDataModel(resKey: "metaData", resValue: metadata));
        responseData["metaData"] = metadata;
      }
      else {
        //  print(value);
        resSplitData.add(RespDataModel(resKey: key, resValue: value));
        responseData[key] = value;
      }

      var productMap = {

        key: value,

      };

      //  resSplitData.add(RespDataModel(resKey: key, resValue: value));
    }

    String metaJson = json.encode(responseData);
    // String metaJson = encoder.convert(metadata);
    // print('Json REsponse Data $metaJson');
    ResponseConfig.startTrxn = false;
    //  print('REsponse  $resSplitData ');
    return metaJson;
  }

}
