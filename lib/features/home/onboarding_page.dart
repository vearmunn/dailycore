import 'package:dailycore/components/pin/pin_enum.dart';
import 'package:dailycore/features/home/cubit/onboarding.dart';
import 'package:dailycore/features/home/homepage.dart';
import 'package:dailycore/features/home/pin_page.dart';
import 'package:dailycore/theme/theme_helper.dart';
import 'package:dailycore/utils/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../../localization/locales.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IntroductionScreen(
          dotsDecorator: DotsDecorator(
            activeColor:
                ThemeHelper.isDark(context) ? Colors.white : Colors.grey,
          ),
          pages: [
            _buildPage(
              context,
              title: AppLocale.onboardingTitleWelcome.getString(context),
              description: AppLocale.onboardingDescWelcome.getString(context),
              imgPath: 'assets/images/welcome.png',
            ),
            _buildPage(
              context,
              title: AppLocale.onboardingTitleTodo.getString(context),
              description: AppLocale.onboardingDescTodo.getString(context),
              imgPath: 'assets/images/todo.png',
            ),
            _buildPage(
              context,
              title: AppLocale.onboardingTitleHabit.getString(context),
              description: AppLocale.onboardingDescHabit.getString(context),
              imgPath: 'assets/images/habit.png',
            ),
            _buildPage(
              context,
              title: AppLocale.onboardingTitleFinance.getString(context),
              description: AppLocale.onboardingDescFinance.getString(context),
              imgPath: 'assets/images/expense.png',
            ),
            _buildLastPage(
              context,
              title: AppLocale.onboardingTitlePIN.getString(context),
              description: AppLocale.onboardingDescPIN.getString(context),
              imgPath: 'assets/images/pin.png',
            ),
          ],
          showSkipButton: false,
          next: Text(AppLocale.next.getString(context)),
          back: Text(AppLocale.back.getString(context)),
          showBackButton: true,
          showDoneButton: false,
        ),
      ),
    );
  }

  PageViewModel _buildPage(
    BuildContext context, {
    required String title,
    required String description,
    required String imgPath,
  }) {
    return PageViewModel(
      title: '',
      bodyWidget: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(imgPath),
            ),
          ),
          verticalSpace(24),
          Text(
            title,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          verticalSpace(16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  PageViewModel _buildLastPage(
    BuildContext context, {
    required String title,
    required String description,
    required String imgPath,
  }) {
    return PageViewModel(
      title: '',
      bodyWidget: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(imgPath),
            ),
          ),
          verticalSpace(24),
          Text(
            title,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          verticalSpace(16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          verticalSpace(30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  context.read<OnboardingCubit>().completeOnboarding();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Homepage()),
                  );
                },
                child: Text(AppLocale.skipForNow.getString(context)),
              ),
              horizontalSpace(16),
              ElevatedButton(
                onPressed: () {
                  context.read<OnboardingCubit>().completeOnboarding();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => PinPage(pinEnum: PinEnum.isSettingUp),
                    ),
                  );
                },
                child: Text(AppLocale.setUpPin.getString(context)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
