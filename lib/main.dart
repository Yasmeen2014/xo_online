import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// P A G E S
import 'package:xo_online/pages/pages_viewer.dart';

// S E R V I C E S
import 'package:xo_online/services/client/client_bloc.dart';

// T H E M E S
import 'package:xo_online/themes/light.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ClientBloc(),
        ),
      ],
      child: MaterialApp(
        theme: lightMode,
        home: const PagesViewer(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
