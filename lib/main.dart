import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'calculator_screen.dart';

Future<void> main() async{
  await Hive.initFlutter();
  await Hive.openBox('settings');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('settings').listenable(),
      builder: (context, box, child) {
        final isDark = box.get('isDark', defaultValue: false);
        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: isDark ? ThemeData.dark() : ThemeData(backgroundColor: Colors.grey),
          home: const MyHomePage(title: 'Calculator'),
        );
      }
    );
  }
}

