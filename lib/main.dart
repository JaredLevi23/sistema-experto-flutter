import 'package:provider/provider.dart';
import 'package:sistema_experto_flutter/src/screens/archive_screen.dart';
import 'package:sistema_experto_flutter/src/screens/dashboard_screen.dart';
import 'package:sistema_experto_flutter/src/screens/detail_screen.dart';
import 'package:sistema_experto_flutter/src/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:sistema_experto_flutter/src/screens/questions_screen.dart';
import 'package:sistema_experto_flutter/src/screens/test_screen.dart';
import 'package:sistema_experto_flutter/src/services/api_service.dart';

void main() => runApp( const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> ApiService())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'home',
        routes: {
          'home': (_) => const HomeScreen(),
          'dashboard': ( _ ) =>  const DashboardScreen(),
          'detail': (_ ) => const DetailsScreen(),
          'archive': (_) => const ArchiveScreen(),
          'test': ( _ ) => const TestScreen(),
          'question': ( _ )=> const QuestionsScreen()
        },
      ),
    );
  }
}