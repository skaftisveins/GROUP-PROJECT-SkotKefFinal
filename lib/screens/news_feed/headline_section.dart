import 'package:flutter/material.dart';

class HeadlineSection extends StatelessWidget {
  final String _title;
  static const double _hPad = 16.0;

  HeadlineSection(this._title);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.fromLTRB(_hPad, 32.0, _hPad, 4.0),
          child: Text(
            _title,
            style: Theme.of(context).textTheme.title,
            softWrap: true,
            maxLines: 3,
            overflow: TextOverflow.clip,
          ),
        ),
      ],
    );
  }
}
