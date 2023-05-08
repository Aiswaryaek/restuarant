import 'package:flutter/material.dart';
import 'package:restaurant/provider/google_sign_in.dart';
import 'app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    // MultiProvider(
    //   providers: [
    //     ChangeNotifierProvider(
    //         create: (_) =>
    //             DishesProvider(categoryRepository: CategoryRepository())),
    //   ],
    //   child:
    MyApp(),
    // ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          // theme: appTheme,
          home: FlutterBasicApp(),
        ),
      );
}
