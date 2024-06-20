import 'package:bitirme_tezi/Model/firebase_options.dart';
import 'package:bitirme_tezi/ViewModel/AnaSayfaViewModel.dart';
import 'package:bitirme_tezi/ViewModel/urunOzellikleriViewModel.dart';
import 'package:bitirme_tezi/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/on_board.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProvider(create: (context) => UrunOzellikleriViewModel()),
        ChangeNotifierProvider(create: (context) => AnaSayfaViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          background: Color.fromRGBO(176, 224, 230, 1),
          secondary: Color.fromRGBO(242, 242, 242, 1),
          primary: Color.fromRGBO(58, 95, 205, 1),


          inversePrimary: Color.fromRGBO(95, 95, 95, 1),
        ),
        useMaterial3: true,
      ),
      home: const OnBoardWidget(),
    );
  }
}
