import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skot_keflavik/models_provider/theme_provider.dart';
import 'package:skot_keflavik/service/calls_and_messages_service.dart';

import 'navigator/NavigationBot.dart';

// Package to make sure our service is singleton
GetIt locator = GetIt.instance;
FirebaseMessaging fbm = new FirebaseMessaging();

//subscribe to cloud messaging topic named test
//to have access to push notifications
void fbSubscribe() {
  fbm.subscribeToTopic('test');
}

void setupLocator() {
  locator.registerSingleton(
    CallsAndMessagesService(),
  );
}

// assigns app theme based on previous selection, light by default
Future<bool> _getTheme() async {
  final prefs = await SharedPreferences.getInstance();

  final theme = prefs.getBool('isLightTheme') ?? true;

  return theme;
}

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool theme = await _getTheme();
  setupLocator();
  fbSubscribe();
  //lock app to vertical mode
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      ChangeNotifierProvider(
        // ignore: deprecated_member_use
        builder: (_) => ThemeProvider(isLightTheme: theme),
        child: KeflavikSkot(),
      ),
    );
  });
}

class KeflavikSkot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
        home: NavigationBot(), theme: themeProvider.getThemeData);
  }
}
