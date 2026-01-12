import 'package:college_project/authentication/auth_bloc/auth_bloc.dart';
import 'package:college_project/authentication/auth_bloc/auth_event.dart';
import 'package:college_project/authentication/repository/auth_repository.dart';
import 'package:college_project/authentication/screen/loginscreen.dart';
import 'package:college_project/map/map_bloc/map_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              AuthBloc(AuthRepository())..add(CheckAuthStatusEvent()),
        ),
        BlocProvider(create: (_) => MapBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginPage()),
    );
  }
}
