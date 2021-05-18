import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skot_keflavik/constants.dart';
import 'package:skot_keflavik/models_provider/theme_provider.dart';
import 'package:skot_keflavik/screens/judges/judges_screen.dart';
import 'package:skot_keflavik/screens/news_feed/news_feed_screen.dart';
import 'package:skot_keflavik/screens/tournament_registration/tournament_registration_screen.dart';
import 'package:skot_keflavik/screens/weather_station/weather_station.dart';

class NavigationBot extends StatefulWidget {
  @override
  _NavigationBotState createState() => _NavigationBotState();
}

class _NavigationBotState extends State<NavigationBot> {
  int _selectedIndex = 0;

  // List of screens that are instantiated as they are
  // selected on the navigation bar
  final List<Widget> _pageOptions = [
    NewsFeedScreen(),
    JudgesScreen(),
    TournamentRegistrationScreen(),
    WeatherStation(),
  ];

  bool isDarkMode = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Skotdeild Keflavíkur'),
        leading: Image.asset(
          'assets/images/372_kefl_rgb.gif',
          scale: 20,
        ),
        actions: <Widget>[
          Visibility(
            visible: _selectedIndex != 2 ? true : false,
            child: Switch(
              value: themeProvider.isLightTheme,
              onChanged: (val) {
                isDarkMode = !isDarkMode;
                themeProvider.setThemeData = val;
              },
            ),
          ),
        ],
      ),
      body: _pageOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).backgroundColor,
            icon: Icon(Icons.chat),
            title: Text('Fréttir'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).backgroundColor,
            icon: Icon(Icons.gavel),
            title: Text('Skotpróf'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).backgroundColor,
            icon: Icon(Icons.gps_fixed),
            title: Text('Mótaskráning'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).backgroundColor,
            icon: Icon(Icons.cloud_circle),
            title: Text('Veðurstöð'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: kAmber,
        onTap: _onItemTapped,
        unselectedItemColor:
            !themeProvider.isLightTheme ? kWhite : kPrimaryColor,
        showUnselectedLabels: true,
      ),
    );
  }
}
