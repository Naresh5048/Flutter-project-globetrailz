import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'services/storage_service.dart';
import 'pages/login_page.dart';
import 'pages/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = StorageService();
  final appState = AppState(storage: storage);
  await appState.initialize();
  runApp(ChangeNotifierProvider(create: (_) => appState, child: GlobeTrailzApp()));
}

class GlobeTrailzApp extends StatelessWidget {
  const GlobeTrailzApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    
    // Define the new bold primary color
    final primaryPink = Color(0xFFFF69B4); // Hot Pink

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GlobeTrailz',
      theme: ThemeData(
        brightness: Brightness.light,
        // New primary color
        primaryColor: primaryPink, 
        colorScheme: ColorScheme.light(
          primary: primaryPink, 
          secondary: Colors.cyan.shade300,
          surface: Color(0xFFF0F4F8), // Light surface for contrast
        ),
        // Make AppBar transparent to show video background
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent, 
          elevation: 0, 
          foregroundColor: Colors.black87,
          iconTheme: IconThemeData(color: Colors.black87),
        ),
        cardColor: Colors.white,
        scaffoldBackgroundColor: Color(0xFFBADFDB), // Use medium gradient color
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xFFFF8AB4),
        colorScheme: ColorScheme.dark(
          primary: Color(0xFFFF8AB4), 
          secondary: Colors.cyan.shade300,
          surface: Color(0xFF121212),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent, 
          elevation: 0, 
          foregroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        cardColor: Color(0xFF1E1E1E),
        scaffoldBackgroundColor: Color(0xFF121212),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white),
          displayLarge: TextStyle(color: Colors.white),
          displayMedium: TextStyle(color: Colors.white),
          displaySmall: TextStyle(color: Colors.white),
          headlineLarge: TextStyle(color: Colors.white),
          headlineMedium: TextStyle(color: Colors.white),
          headlineSmall: TextStyle(color: Colors.white),
          labelLarge: TextStyle(color: Colors.white),
          labelMedium: TextStyle(color: Colors.white),
          labelSmall: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
          titleSmall: TextStyle(color: Colors.white),
        ),
      ),
      themeMode: app.isDark ? ThemeMode.dark : ThemeMode.light,
      home: RootRouter(),
    );
  }
}

class RootRouter extends StatelessWidget {
  const RootRouter({super.key});
  
  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    if (app.loggedIn != null) {
      return MainPage(onLogout: () {
        app.logout();
      });
    }
    return LoginPage(openMainIfLogged: () {
      // Logic handled by AppState, no manual rebuild needed
    });
  }
}