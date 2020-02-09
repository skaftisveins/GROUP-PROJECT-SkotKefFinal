import 'package:flutter/material.dart';
import 'package:skot_keflavik/constants.dart';
import 'package:skot_keflavik/screens/tournament_registration/registrationForm.dart';

class TournamentRegistrationScreen extends StatefulWidget {
//  static const String id = 'tournament_registration_screen';

  @override
  _TournamentRegistrationScreenState createState() =>
      _TournamentRegistrationScreenState();
}

// Metur hvort á að sýna formið eða ekki, breytan er í constant.dart
// og heitir NoTournament.
isTournament(BuildContext context) {
  if (!noTournament) {
    return RegForm();
  } else {
    return Column(
      children: <Widget>[
        Text('Ekkert mót á dagskrá í augnablikinu',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline),
      ],
    );
  }
}

class _TournamentRegistrationScreenState
    extends State<TournamentRegistrationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: kBackgroundColor,
      body: Center(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                isTournament(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
