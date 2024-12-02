import 'package:flutter/material.dart';

// P A G E S
import 'package:xo_online/pages/connect_page.dart';
import 'package:xo_online/pages/game_page.dart';
import 'package:xo_online/pages/home_page.dart';

// S E R V I C E S
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xo_online/services/client/client_bloc.dart';
import 'package:xo_online/services/client/client_states.dart';

class PagesViewer extends StatelessWidget {
  const PagesViewer({super.key});

  @override
  Widget build(BuildContext context) {
    ClientBloc clientBloc = context.watch<ClientBloc>();
    ClientStates clientState = clientBloc.state;

    return const HomePage();

    if (clientState is ClientConnectedState) {
      return const HomePage();
    } else if (clientState is ClientTurnState &&
        clientState is ClientOponnentTurnState) {
      return const GamePage();
    } else {
      return const ConnectPage();
    }
  }
}
