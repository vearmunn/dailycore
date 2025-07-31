import 'package:country_flags/country_flags.dart';
import 'package:dailycore/components/pin/cubit/pin_cubit.dart';
import 'package:dailycore/components/pin/pin_enum.dart';
import 'package:dailycore/features/home/pin_page.dart';
import 'package:dailycore/theme/theme_cubit.dart';
import 'package:dailycore/utils/colors_and_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

      // backgroundColor: Colors.white,
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
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              final isDark = themeMode == ThemeMode.dark;
              return ListTile(
                leading: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
                title: Text(
                  isDark
                      ? AppLocale.darkMode.getString(context)
                      : AppLocale.lightMode.getString(context),
                ),
                trailing: CupertinoSwitch(
                  activeTrackColor: dailyCoreBlue,
                  value: isDark,
                  onChanged: (isDarkMode) {
                    if (isDarkMode) {
                      context.read<ThemeCubit>().setDarkMode();
                    } else {
                      context.read<ThemeCubit>().setLightMode();
                    }
                  },
                ),
              );
            },
          ),
          Divider(indent: 16, endIndent: 28),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text(AppLocale.lock.getString(context)),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              final isPinSet = context.read<PinCubit>().isPinSet();
              if (isPinSet) {
                showPinModalBottomSheet(context);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PinPage(pinEnum: PinEnum.isSettingUp),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Future<dynamic> showPinModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder:
          (context) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.lock_open),
                  title: Text(AppLocale.updatePin.getString(context)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => PinPage(pinEnum: PinEnum.isUpdating),
                      ),
                    );
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.lock_reset),
                  title: Text(AppLocale.removePin.getString(context)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => PinPage(pinEnum: PinEnum.isRemoving),
                      ),
                    );
                  },
                ),
              ],
            ),
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
