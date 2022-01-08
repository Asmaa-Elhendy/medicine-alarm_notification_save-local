import 'package:flutter/material.dart';
import 'package:medicine_alarm/controller/dateprovider.dart';
import 'package:medicine_alarm/controller/getdatabaseprovider.dart';
import 'package:medicine_alarm/controller/timer_provider.dart';
import 'package:medicine_alarm/view/home.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
        create: (_)=> DateProvider(),),
    ChangeNotifierProvider(
    create: (_)=> GetDataBaseProvider(),),
        ChangeNotifierProvider(
          create: (_)=> Timerprovider(),)
      ],
      child:  MaterialApp(
        debugShowCheckedModeBanner: false,
          title: 'medicine alarm',
          theme: ThemeData(

            primarySwatch: Colors.blue,
          ),
          home: SplashScreenView(
            navigateRoute: Home(),
            duration: 5000,
            imageSize: 130,
            imageSrc: "assets/images/capsule.png",
            text: "Medicine Notifying",
            textType: TextType.TyperAnimatedText,
            textStyle: TextStyle(
              fontSize: 30.0,
            ),
            backgroundColor: Colors.white,
          )
        ),

    );
  }
}
