import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'login_page.dart';
import 'signup_page.dart';
import 'home_page.dart';
import 'semester_selection_page.dart';
import 'subject_selection_page.dart';
import 'resource_page.dart';
import 'profile_page.dart';
import 'admin_login_page.dart';
import 'admin_dashboard_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Resource App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/home': (context) => HomePage(),
        '/semester': (context) => SemesterSelectionPage(),
        '/profile': (context) => ProfilePage(),
        '/admin_login': (context) => AdminLoginPage(),
        '/admin_dashboard': (context) => AdminDashboardPage(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/subject':
            final semesterName = settings.arguments as String?;
            return MaterialPageRoute(
              builder: (context) => SubjectSelectionPage(
                semesterName: semesterName ?? '',
              ),
            );
          case '/resources':
            final args = settings.arguments as Map<String, String>;
            final semesterName = args['semesterName'];
            final subjectName = args['subjectName'];
            return MaterialPageRoute(
              builder: (context) => ResourcePage(
                semesterName: semesterName ?? '',
                subjectName: subjectName ?? '',
              ),
            );
          default:
            return null;
        }
      },
    );
  }
}
