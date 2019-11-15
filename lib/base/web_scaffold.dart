import 'package:flutter/material.dart';
import 'package:flutter_base/widgets/status_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

//打开webView
class WebScaffold extends StatefulWidget {
  const WebScaffold({
    Key key,
    this.title,
    this.url,
  }) : super(key: key);

  final String title;
  final String url;

  @override
  State<StatefulWidget> createState() {
    return new WebScaffoldState();
  }
}

class WebScaffoldState extends State<WebScaffold> {
  WebViewController _webViewController;
  int loadStatus = Status.loading;


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          widget.title ?? "",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          new WebView(
            onWebViewCreated: (WebViewController webViewController) {
              _webViewController = webViewController;
            },
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (String e) {
              print("webview：${widget.url} 数据：$e");
              setState(() {
                loadStatus = (e == "about:blank" ? Status.fail : Status.success);
              });
            },
          ),
          Offstage(
            offstage: loadStatus == Status.success,
            child: StatusView(
              status: loadStatus,
              onTap: () {
                setState(() {
                  _webViewController.loadUrl(widget.url);
                  loadStatus = Status.loading;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
