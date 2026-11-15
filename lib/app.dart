import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:word_mate/l10n/app_localizations.dart';
import 'package:word_mate/common/index.dart';
import 'package:word_mate/injector.dart';
import 'package:word_mate/presentation/views/settings/bloc/locale_bloc.dart';
import 'package:word_mate/presentation/views/settings/bloc/locale_event.dart';
import 'package:word_mate/presentation/views/settings/bloc/locale_state.dart';
import 'package:word_mate/router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    /// Initialize EasyLoading settings
    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.light
      ..maskType = EasyLoadingMaskType.black
      ..dismissOnTap = false
      ..indicatorColor = Colors.white
      ..backgroundColor = Colors.black54;

    return BlocProvider<LocaleBloc>(
      create: (_) => injector<LocaleBloc>()..add(LoadLocaleEvent()),
      child: BlocBuilder<LocaleBloc, LocaleState>(
        builder: (context, localeState) {
          return ScreenUtilInit(
            designSize: const Size(
              Constants.kDesignWidth,
              Constants.kDesignHeight,
            ),
            child: MaterialApp.router(
              routerConfig: AppRouter.router,
              debugShowCheckedModeBanner: false,
              builder: EasyLoading.init(),
              locale: localeState.locale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
            ),
          );
        },
      ),
    );
  }
}
