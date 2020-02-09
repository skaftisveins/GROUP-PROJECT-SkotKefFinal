import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsSection extends StatelessWidget {
  final String _body;
  static const double _hPad = 16.0;
  DetailsSection(this._body);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.fromLTRB(_hPad, 10.0, _hPad, _hPad),
          child: Html(
            data: _body,
            defaultTextStyle: Theme.of(context).textTheme.body1,
            linkStyle: Theme.of(context).textTheme.display2,
            onLinkTap: (url) async => await launch(url),
            onImageTap: (imgUrl) => showDialog(
              context: context,
              builder: (_) => GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: PhotoView(
                  imageProvider: NetworkImage(imgUrl),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
