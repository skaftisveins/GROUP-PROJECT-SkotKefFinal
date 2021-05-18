import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:skot_keflavik/constants.dart';
import 'package:skot_keflavik/model/GoogleSheets.dart';
import 'package:skot_keflavik/model/NewRegistration.dart';
import 'package:skot_keflavik/model/Tournament.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config.dart';

class RegForm extends StatefulWidget {
  @override
  _RegFormState createState() => _RegFormState();
}

class _RegFormState extends State<RegForm> {
  final _formKey = GlobalKey<FormState>();
  final Registration newRegistration = new Registration();
  bool _autoValidate = false;
  String selectedEvent = '';
  String selectedCategory = '';
  String subjectText = Uri.encodeComponent('Skráning á mót');
  String bodyText = '';
  bool _didValidate = true;
  List<String> _gunList = new List<String>();
  List<List<String>> _eventList = new List<List<String>>();
  final tournament = new Tournament();
  String tournamentName = '';
  String tournamentDate = '';
  String tournamentDeadline = '';

  //Data from GoogleSheets fetched categories and events and lists populated
  Future<Categories> categories;
  Future<Categories> fetchCategories() async {
    final data = await http.get(kGoogleSheetUrlCategories).then((response) {
      final jsonData = Categories.fromJson(json.decode(response.body));
      return jsonData;
    }).catchError((e) {
      return e;
    });

    //Dropdown button gets it's initial values
    _gunList.add('Veldu flokk');

    data.values.forEach((i) {
      _gunList.add(i[0]);
    });

    popList(data.values);
    return data;
  }

  //Data from GoogleSheets fetched for tournament info
  Future<Categories> tournaments;
  Future<Categories> fetchTournaments() async {
    final data = await http.get(kGoogleSheetUrlTournaments).then((response) {
      final jsonData = Categories.fromJson(json.decode(response.body));
      return jsonData;
    }).catchError((e) {
      return e;
    });

    try {
      print(data.values);

//      tournamentName = data.values[0][0];
//      tournamentDate = data.values[0][1];
//      tournamentDeadline = data.values[0][2];

      tournament.tName = data.values[0][0];
      tournament.tDate = data.values[0][1];
      tournament.tDeadline = data.values[0][2];

      noTournament = false;
    } catch (e) {
      tournament.tName = 'Ekkert mót á dagskrá';
      tournament.tDate = '';
      tournament.tDeadline = '';

      print('error in tournement fetch');
      //noTournament = true;
    }

    return data;
  }

  //Population of events that are connected to
  //what is selected in the _gunList dropdown
  popList(categories) {
    int counter = 0;

    categories.forEach((i) {
      List<String> lvlOne = new List<String>();
      int listElement = 0;

      for (var ii in categories[counter]) {
        //First element skipped as it is the same as
        //the selected _gunList element
        if (listElement > 0) {
          lvlOne.add(ii);
        }
        listElement++;
      }
      _eventList.add(lvlOne);
      counter++;
    });
  }

  final List<String> _event = [
    'Veldu grein',
  ];

  // Screen to generate tournament signup email
  // Validates each field and then sends the
  // data into the default email client
  @override
  void initState() {
    tournaments = fetchTournaments();
    categories = fetchCategories();

    super.initState();
    print('Super Init State rennur');

    selectedCategory = 'Veldu flokk'; //_gunList[0];
    selectedEvent = _event[0];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          // Builder for tournament info if any
          FutureBuilder<Categories>(
              future: tournaments,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: <Widget>[
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 20),
                                child: Text(
                                  tournament.tName,
                                  style: Theme.of(context).textTheme.headline,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('Mótsdagur'),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('Skráningarlok'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(tournament.tDate),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(tournament.tDeadline),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 30, 10, 30),
                      child: Text(
                        'Ekkert mót á dagskrá í augnablikinu',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                return Text('');
              }),
          // Builder for categories and events
          FutureBuilder<Categories>(
              future: categories,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    child: Column(
                      children: <Widget>[
                        Form(
                          key: _formKey,
                          autovalidate: _autoValidate,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                //Name field
                                TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: 'Fullt nafn'),
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value.isEmpty || value.length < 3) {
                                      return 'Vinsamlegast skráðu fullt nafn';
                                    }
                                    return null;
                                  },
                                  onSaved: (val) =>
                                      newRegistration.fullName = val,
                                ),
                                //Age field
                                TextFormField(
                                  maxLength: 4,
                                  maxLengthEnforced: true,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    WhitelistingTextInputFormatter.digitsOnly
                                  ],
                                  decoration: const InputDecoration(
                                      labelText: 'Fæðingarár'),
                                  validator: (value) {
                                    if (value.isEmpty || value.length < 4) {
                                      return 'Skráið fæðingarár á forminu YYYY';
                                    } else if (int.tryParse(value, radix: 10) >
                                        DateTime.now().year) {
                                      return 'Óleyfilegt ártal';
                                    }
                                    return null;
                                  },
                                  onSaved: (val) =>
                                      newRegistration.birthYear = val,
                                ),
                                // Category list
                                DropdownButton(
                                  value: selectedCategory,
                                  items: _gunList.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      selectedCategory = newValue;
                                      newRegistration.category = newValue;
                                      selectedEvent = 'Veldu grein';
                                    });
                                    int i = _gunList.indexOf(newValue, 0);
                                    print('Selected index of category: $i');
                                    _populateEvents(i);
                                  },
                                ),
                                //Event list
                                DropdownButton(
                                  value: selectedEvent,
                                  items: _event.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      selectedEvent = newValue;
                                    });
                                    newRegistration.event = newValue;
                                  },
                                ),
                                //E-mail with regex pattern validation
                                TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                      labelText: 'Netfang'),
                                  validator: (value) {
                                    Pattern pattern =
                                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                    RegExp regex = new RegExp(pattern);
                                    if (!regex.hasMatch(value))
                                      return 'Þetta virðist ekki vera gilt netfang!';
                                    else
                                      return null;
                                  },
                                  onSaved: (val) => newRegistration.email = val,
                                ),
                                //Confirm Button
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: Center(
                                    child: RaisedButton(
                                      color: Theme.of(context).buttonColor,
                                      textColor: Colors.white,
                                      onPressed: () async {
                                        bool isValid =
                                            await startValidateInputs();
                                        String urlString =
                                            "mailto:$kRegistrationEmail?subject=$subjectText&body=$bodyText";
                                        if (isValid &&
                                            await canLaunch(urlString)) {
                                          try {
                                            await launch(urlString);
                                          } catch (e) {
                                            throw 'There was an error using an email client';
                                          }
                                        } else {
                                          throw 'Form not valid';
                                        }
                                      },
                                      child: Text('Staðfesta'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return NoInternetWarning();
                }
                return Column(
                  children: <Widget>[
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                );
              }),
        ],
      ),
    );
  }

  //Validation needs to be done async for data to be ready
  //for the following fuctions of the validation
  Future<bool> startValidateInputs() async {
    _didValidate = _validateInputs();
    return _didValidate;
  }

  // Run population on events based on selected value in category
  void _populateEvents(int i) {
    _event.clear();
    _event.add('Veldu grein');

    //Will not populate if no category is selected
    if (selectedCategory != 'Veldu flokk') {
      print(true);
      //Index lowered by one to match that of eventList
      --i;

      _eventList[i].forEach((ii) {
        _event.add(ii);
      });
    }
  }

  bool _validateInputs() {
    // Validate will return true if the form is valid, or false if
    // the form is invalid.
    if (_formKey.currentState.validate()) {
      // If dropdown buttons have not been activated a default value is supplied
      if (newRegistration.category == null ||
          newRegistration.category.isEmpty) {
        newRegistration.category = "Ekkert valið";
      }
      if (newRegistration.event == null || newRegistration.event.isEmpty) {
        newRegistration.event = "Ekkert valið";
      }
      _formKey.currentState.save();
      bodyText = Uri.encodeComponent("Nafn: ${newRegistration.fullName}<br/>"
          "Fæðingarár: ${newRegistration.birthYear}<br/>"
          "Grein: ${newRegistration.category}<br/>"
          "Flokkur: ${newRegistration.event}<br/>"
          "E-mail: ${newRegistration.email}"); // is this really needed ?
      resetForm();
      return true;
//
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
      return false;
    }
  }

  // Form reset and dropdown set to initial values
  // form auto validate set to false.
  void resetForm() {
    setState(() {
      selectedCategory = _gunList[0];
      selectedEvent = _event[0];
    });
    _formKey.currentState.reset();
    _autoValidate = false;
  }
}
