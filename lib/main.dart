// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dailycore/components/scheduled_notifs_list/cubit/schedule_notif_cubit.dart';
import 'package:dailycore/hive/hive_registrar.g.dart';
import 'package:dailycore/localization/locales.dart';
import 'package:dailycore/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:toastification/toastification.dart';

import 'components/color_icon_selector/color_icon_selector_cubit.dart';
import 'components/date_picker/pick_date_cubit.dart';
import 'components/image_picker/image_picker_cubit.dart';
import 'components/numpad/numpad_cubit.dart';
import 'features/expense_tracker/data/models/hive_expense.dart';
import 'features/expense_tracker/data/models/hive_expense_category.dart';
import 'features/expense_tracker/data/models/hive_goal.dart';
import 'features/expense_tracker/data/repository/hive_expense_category_repo.dart';
import 'features/expense_tracker/data/repository/hive_expense_repo.dart';
import 'features/expense_tracker/data/repository/hive_goal_repo.dart';
import 'features/expense_tracker/presentation/cubit/expense_category/expense_category_cubit.dart';
import 'features/expense_tracker/presentation/cubit/expense_crud/expense_crud_cubit.dart';
import 'features/expense_tracker/presentation/cubit/goal/goal_cubit.dart';
import 'features/expense_tracker/presentation/cubit/monthly_total_list/monthly_total_list_cubit.dart';
import 'features/expense_tracker/presentation/cubit/pie_chart/pie_chart_cubit.dart';
import 'features/habit_tracker/data/models/hive_habit.dart';
import 'features/habit_tracker/data/models/hive_routine.dart';
import 'features/habit_tracker/data/repository/hive_habit_repo.dart';
import 'features/habit_tracker/presentation/crud_cubit/habit_crud_cubit.dart';
import 'features/home/homepage.dart';
import 'features/todo/data/models/hive_todo.dart';
import 'features/todo/data/models/hive_todo_category.dart';
import 'features/todo/data/repository/hive_todo_category_repo.dart';
import 'features/todo/data/repository/hive_todo_repo.dart';
import 'features/todo/presentation/cubit/category_cubit/category_cubit.dart';
import 'features/todo/presentation/cubit/crud_cubit/todo_crud_cubit.dart';
import 'features/todo/presentation/cubit/dashboard_cubit/todo_dashboard_cubit.dart';
import 'features/todo/presentation/cubit/upcoming_cubit/upcoming_cubit.dart';
import 'hive_boxes/boxes.dart';
import 'theme/theme_cubit.dart';
import 'utils/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize();
  await FlutterLocalization.instance.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();

  Hive
    ..init(dir.path)
    ..registerAdapters();

  // open hive db
  await Hive.openBox<TodoHive>(todoBox);
  await Hive.openBox<TodoCategoryHive>(todoCategoryBox);
  await Hive.openBox<HabitHive>(habitBox);
  await Hive.openBox<RoutineHive>(routineBox);
  await Hive.openBox<ExpenseHive>(expenseBox);
  await Hive.openBox<ExpenseCategoryHive>(expenseCategoryBox);
  await Hive.openBox<GoalHive>(goalBox);

  final hiveTodoRepo = HiveTodoRepo();
  final hiveTodoCategoryRepo = HiveTodoCategoryRepo();
  final hiveHabitRepo = HiveHabitRepo();
  // final hiveRoutineRepo = HiveRoutineRepo();
  final hiveExpenseRepo = HiveExpenseRepo();
  final hiveExpenseCategoryRepo = HiveExpenseCategoryRepo();
  final hiveGoalRepo = HiveGoalRepo();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => DateCubit()),
        BlocProvider(create: (context) => ColorSelectorCubit()),
        BlocProvider(create: (context) => IconSelectorCubit()),
        BlocProvider(create: (context) => ImagePickerCubit()),
        BlocProvider(create: (context) => NumpadCubit()),
        BlocProvider(create: (context) => UpcomingDateCubit()),
        BlocProvider(create: (context) => TodoDashboardCubit()),
        BlocProvider(create: (context) => TodoCrudCubit(hiveTodoRepo)),
        BlocProvider(
          create: (context) => TodoCategoryCubit(hiveTodoCategoryRepo),
        ),
        BlocProvider(create: (context) => HabitCrudCubit(hiveHabitRepo)),
        BlocProvider(create: (context) => ExpenseCrudCubit(hiveExpenseRepo)),
        BlocProvider(
          create: (context) => ExpenseCategoryCubit(hiveExpenseCategoryRepo),
        ),
        BlocProvider(create: (context) => PieChartCubit(hiveExpenseRepo)),
        BlocProvider(
          create: (context) => MonthlyTotalListCubit(hiveExpenseRepo),
        ),
        BlocProvider(create: (context) => GoalCubit(hiveGoalRepo)),
        BlocProvider(create: (context) => ScheduleNotifCubit()),
        BlocProvider(create: (context) => ThemeCubit()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterLocalization localization = FlutterLocalization.instance;
  @override
  void initState() {
    localization.init(
      mapLocales: [
        const MapLocale('en', AppLocale.EN),
        const MapLocale('id', AppLocale.ID),
      ],
      initLanguageCode: 'en',
    );
    localization.onTranslatedLanguage = _onTranslatedLanguage;
    super.initState();
  }

  // the setState function here is a must to add
  void _onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'DailyCore',
            supportedLocales: localization.supportedLocales,
            localizationsDelegates: localization.localizationsDelegates,
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: themeMode,
            home: Homepage(),
          );
        },
      ),
    );
  }
}
