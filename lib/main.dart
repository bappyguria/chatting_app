import 'package:chatting_app/screens/login/bloc/login_bloc.dart';
import 'package:chatting_app/screens/sign_up/bloc/sign_up_bloc.dart';
import 'package:chatting_app/screens/splash_screen.dart';
import 'package:chatting_app/screens/user_list/user_list.dart';
import 'package:chatting_app/screens/user_list/user_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'Repository/repository.dart' show Repository;
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('myBox');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LoginBloc(Repository())),
        BlocProvider(create: (_) => SignUpBloc(Repository())),
        BlocProvider(create: (_) => UserListBloc(Repository())),
      ],
      child: MaterialApp(
        title: 'Chat App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const OJANTA_SplashScreen(),
      ),
    );
  }
}
