import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/routes/home/home.dart';
import 'package:flutter_base/routes/login_route.dart';
import 'package:flutter_base/routes/start_route.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'blocs/MainBloc.dart';
import 'blocs/bloc_provider.dart';
import 'config/app_config.dart';
import 'config/application.dart';
import 'config/profilechangenotifier.dart';

void main() => Application.init().then((e) => runApp(BlocProvider(child: MyApp(), bloc: MainBloc(),)));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildCloneableWidget>[
        ChangeNotifierProvider.value(value: UserModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: AppConfig.IS_DEBUG,
        theme: ThemeData(
          primaryColor: MyColors.main_color,
        ),
        home: StartRoute(), //启动页
        locale: Locale('zh'),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('zh', 'CH'),
          const Locale('en', 'US'),
        ],
        // 注册命名路由表
        routes: <String, WidgetBuilder>{
          Ids.login: (context) => LoginRoute(),
          Ids.home: (context) => HomeRoute(),
        },
      ),
    );
  }
}



