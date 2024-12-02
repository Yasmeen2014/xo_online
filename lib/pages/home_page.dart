import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xo_online/services/client/client_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Center(
        child: GestureDetector(
          onTap: () {
            context.read<ClientBloc>().searchForMatch();
          },
          child: Container(
            width: 300,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(360),
              color: colorScheme.secondary,
            ),
            child: Center(
              child: Text(
                "Play",
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                  fontSize: 25,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
