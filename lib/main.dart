import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter WebView',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter WebView'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;
  final String htmlContent = '''
    <!DOCTYPE html>
    <html>
    <head>
      <title>VLibras</title>
    </head>
    <body>
      <div vw class="enabled">
        <div vw-access-button class="active"></div>
        <div vw-plugin-wrapper>
          <div class="vw-plugin-top-wrapper"></div>
        </div>
      </div>
      <script src="https://vlibras.gov.br/app/vlibras-plugin.js"></script>
      <script>
        new window.VLibras.Widget('https://vlibras.gov.br/app');
      </script>
    </body>
    </html>
  ''';

  @override
  Widget build(BuildContext context) {
    WebViewController? controller;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: WebView(
        initialUrl: Uri.dataFromString(
          htmlContent,
          mimeType: 'text/html',
          encoding: Encoding.getByName('utf-8'),
        ).toString(),
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController controller) {
          controller.clearCache();
          controller = controller;
        },
        onPageFinished: (String _) async {
          controller!.evaluateJavascript('''
      window.addEventListener('scroll', function(e) {
        if ((Math.ceil(window.innerHeight + window.pageYOffset)) >= document.body.offsetHeight) {
          ScrollCallback.postMessage('END OF PAGE!!!');
        }
      });
    ''');
        },
        javascriptChannels: <JavascriptChannel>{
          JavascriptChannel(
              name: 'ScrollCallback',
              onMessageReceived: (JavascriptMessage message) {
                print(message.message);
              }),
        },
      ),
    );
  }
}
