import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:skot_keflavik/constants.dart';
import 'package:skot_keflavik/model/GoogleSheets.dart';
import 'package:skot_keflavik/service/calls_and_messages_service.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config.dart';
import '../../main.dart';

class JudgesScreen extends StatefulWidget {
  @override
  _JudgesScreenState createState() => _JudgesScreenState();
}

class _JudgesScreenState extends State<JudgesScreen> {
  final CallsAndMessagesService _service = locator<CallsAndMessagesService>();
  static const String ScreenTitle = 'Skotprófdómarar';
  int selectedItem;
  String selectedPhoneNumber = '';
  String selectedEmail = '';
  String subject = 'fyrirspurn';

  Future<Categories> kJudges;
  Future<Categories> fetchJudges() async {
    final data = await http.get(kGoogleSheetUrlJudges).then((response) {
      final jsonData = Categories.fromJson(json.decode(response.body));
      return jsonData;
    }).catchError((e) {
      noInternet = true;
      return e;
    });
    //print(data);
    return data;
  }

  @override
  void initState() {
    super.initState();
    kJudges = fetchJudges();
  }

  // Android email launcher, iOS is launched straight from the onPressed event
  void launchEmail() {
    CallsAndMessagesService camService = new CallsAndMessagesService();

    if (selectedEmail != null) {
      camService.sendEmail(selectedEmail, 'Próf fyrirspurn', '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Categories>(
        future: kJudges,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(5.0),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 15.0),
                    child: Text(
                      ScreenTitle,
                      style: Theme.of(context).textTheme.headline,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 15.0),
                      itemCount: snapshot.data.values.length,
                      itemBuilder: (context, i) {
                        return ListTileTheme(
                          contentPadding: EdgeInsets.all(0.0),
                          selectedColor: kAmber,
                          child: ListTile(
                            trailing: selectedItem == i
                                ? Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.29,
                                    child: Row(
                                      children: <Widget>[
                                        IconButton(
                                          icon: Icon(Icons.email),
                                          color: kAmber,
                                          iconSize: 30.0,
                                          onPressed: () async {
                                            // Evaluates if you are using iOS or Android and
                                            // launches the default email app
                                            if (Platform.isIOS) {
                                              print('IOS platform');
                                              if (await canLaunch(
                                                  'mailto:$selectedEmail')) {
                                                await launch(
                                                    "mailto:$selectedEmail?subject=$subject");
                                              } else {
                                                throw 'Could not launch';
                                              }
                                            } else {
                                              print('Android platform');
                                              launchEmail();
                                            }
                                          },
                                          padding: EdgeInsets.all(0.0),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.phone),
                                          color: kAmber,
                                          iconSize: 30.0,
                                          onPressed: () => _service
                                              .call(selectedPhoneNumber),
                                          padding: EdgeInsets.all(0.0),
                                        )
                                      ],
                                    ),
                                  )
                                : null,
                            title: Text(
                              snapshot.data.values[i][0],
                              style: TextStyle(fontSize: 24.0),
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              snapshot.data.values[i][1],
                              style: Theme.of(context).textTheme.subtitle,
                            ),
                            selected: selectedItem == i ? true : false,
                            onTap: () {
                              setState(
                                () {
                                  // Selects or unselects a judge and its
                                  // email and phone info
                                  if (selectedPhoneNumber !=
                                      snapshot.data.values[i][1]) {
                                    selectedPhoneNumber =
                                        snapshot.data.values[i][1];
                                    selectedEmail = snapshot.data.values[i][2];
                                    selectedItem = i;
                                  } else if (selectedPhoneNumber ==
                                      snapshot.data.values[i][1]) {
                                    selectedPhoneNumber = '';
                                    selectedEmail = '';
                                    selectedItem = null;
                                  }
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return NoInternetWarning();
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
