import 'package:flutter/material.dart';

class TextSection extends StatelessWidget {
  final String _body;
  static const double _hPad = 16.0;

  TextSection(this._body);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.fromLTRB(_hPad, 10.0, _hPad, _hPad),
          child: Text(
            _body,
            style: Theme.of(context).textTheme.body1,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            softWrap: true,
          ),
        ),
      ],
    );
  }
}
