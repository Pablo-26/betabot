import 'package:betabot/consts.dart';
import 'package:betabot/pages/boton_emergencia.dart';
import 'package:betabot/pages/calendario.dart';
import 'package:betabot/pages/chatbot.dart';
import 'package:betabot/pages/chatbot_receta.dart';
import 'package:betabot/pages/control_glucosa.dart';
import 'package:betabot/pages/home.dart';
import 'package:betabot/pages/login.dart';
import 'package:betabot/pages/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Gemini.init(
    apiKey: GEMINI_API_KEY,
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      locale: const Locale('es', 'ES'),
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('es', 'ES'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Splash();
          }

          if (snapshot.hasData) {
            return const Home();
          }
          return const Login();
        },
      ),
      // Definición de las rutas
      routes: {
        'login': (_) => const Login(),
        'home': (_) => const Home(),
        'chatbot': (_) => const Chatbot(),
        'calendario': (_) => const Calendario(),
        'boton_emergen': (_) => const BotonEmergencia(),
        'chatbot_receta': (_) => const ChatbotReceta(),
        'splash': (_) => const Splash(),
        'control_glucosa': (_) => const GlucoseDashboard(),
      },
    );
  }
}
