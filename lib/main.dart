import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lobrand_flutter/providers/user_provider.dart';
import 'package:lobrand_flutter/responsive/mobile_layout_screen.dart';
import 'package:lobrand_flutter/responsive/responsive_layout_screen.dart';
import 'package:lobrand_flutter/responsive/web_layout_screen.dart';
import 'package:lobrand_flutter/screens/login_screen.dart';
import 'package:lobrand_flutter/screens/signup_screen.dart';
import 'package:lobrand_flutter/utils/color.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyDoSznjJTIYK6yYbzdwZizDxXpRGUmqi2I',
        appId: '1:174397920097:web:689873b1a45242bda4ab20',
        messagingSenderId: '174397920097',
        projectId: 'lobrand-flutter',
        storageBucket: "lobrand-flutter.appspot.com",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
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
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'LoBrand',
        theme: ThemeData.dark()
            .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
        // home: const ResponsiveLayout(
        //   mobileScreenLayout: MobileScreenLayout(),
        //   webScreenLayout: WebScreenLayout(),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: primaryColor,
              ));
            }
            return LoginScreen();
          },
        ),
      ),
    );
  }
}
