import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WeatherStation extends StatefulWidget {
//  static const String id = 'weather_station';
  @override
  _WeatherStationState createState() => _WeatherStationState();
}

// WebView Package installed to monitor Weather Station

class _WeatherStationState extends State<WeatherStation> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  // WebViewController _controller;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: 'https://holfuy.com/en/weather/965',
      //initialUrl: 'https://www.mbl.is',
      javascriptMode: JavascriptMode.unrestricted,

      onWebViewCreated: (WebViewController webViewController) {
        _controller.complete(webViewController);

        //_controller = webViewController;
        //_controller.loadUrl('https://holfuy.com/en/weather/965');
      },
    );
  }
}
