import 'package:country_flags/country_flags.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../../localization/locales.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late FlutterLocalization _flutterLocalization;

  @override
  void initState() {
    _flutterLocalization = FlutterLocalization.instance;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocale.settings.getString(context))),
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.only(left: 4, top: 16),
        children: [
          ListTile(
            leading: Icon(Icons.translate),
            title: Text(AppLocale.language.getString(context)),
            subtitle: Text(AppLocale.whatLanguage.getString(context)),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              showLanguageOptions(context);
            },
          ),
          Divider(indent: 16, endIndent: 28),
          ListTile(
            leading: Icon(Icons.light_mode),
            title: Text(AppLocale.lightMode.getString(context)),
            trailing: CupertinoSwitch(value: false, onChanged: (v) {}),
          ),
          Divider(indent: 16, endIndent: 28),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text(AppLocale.lock.getString(context)),
            trailing: Icon(Icons.keyboard_arrow_right),
          ),
        ],
      ),
    );
  }

  Future<dynamic> showLanguageOptions(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder:
          (context) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: CountryFlag.fromLanguageCode(
                    'en',
                    shape: Circle(),
                    height: 30,
                    width: 30,
                  ),
                  title: Text('English'),
                  onTap: () {
                    _flutterLocalization.translate('en');
                    Navigator.pop(context);
                  },
                ),
                Divider(),
                ListTile(
                  leading: CountryFlag.fromLanguageCode(
                    'id',
                    shape: Circle(),
                    height: 30,
                    width: 30,
                  ),
                  title: Text('Bahasa Indonesia'),
                  onTap: () {
                    _flutterLocalization.translate('id');
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
    );
  }
}
