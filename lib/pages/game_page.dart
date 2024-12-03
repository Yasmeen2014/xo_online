import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:xo_online/services/client/client_bloc.dart';
import 'package:xo_online/services/client/client_states.dart';
import 'package:xo_online/widgets/glitchy_text.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    // Client
    ClientBloc clientBloc = context.watch<ClientBloc>();
    ClientStates clientState = clientBloc.state;

    // Get board
    List board = ["", "", "", "", "", "", "", "", ""];
    if (clientState is ClientTurnState) {
      board = clientState.board;
    } else if (clientState is ClientOponnentTurnState) {
      board = clientState.board;
    }
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 350,
            child: clientState is ClientMatchmakingState
                ? MatchmakingRow(clientBloc: clientBloc)
                : GameRow(clientBloc: clientBloc),
          ),
          const Gap(5),
          Container(
            height: 2,
            width: 320,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(360),
            ),
          ),
          const Gap(40),
          Center(
            child: SizedBox(
              width: 350,
              height: 380,
              child: GridView.builder(
                itemCount: 9,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(2.5),
                    child: Cell(
                      clientBloc: clientBloc,
                      colorScheme: colorScheme,
                      index: index,
                      symbol: board[index],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GameRow extends StatelessWidget {
  const GameRow({
    super.key,
    required this.clientBloc,
  });

  final ClientBloc clientBloc;

  @override
  Widget build(BuildContext context) {
    ClientStates clientState = clientBloc.state;

    // Get symbol & oponnent
    String symbol = "";
    String oponnent = "";
    if (clientState is ClientOponnentTurnState) {
      symbol = clientState.symbol;
      oponnent = clientState.oponnent;
    } else if (clientState is ClientTurnState) {
      symbol = clientState.symbol;
      oponnent = clientState.oponnent;
    }
    return Row(
      children: [
        SizedBox(
          width: 155,
          child: Text(
            symbol == "X" ? clientBloc.getUsername() : oponnent,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: Colors.blue,
            ),
          ),
        ),
        SizedBox(
          width: 40,
          child: Center(
            child: Text(
              "vs",
              style: TextStyle(
                fontSize: 35,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 155,
          child: Text(
            symbol == "O" ? clientBloc.getUsername() : oponnent,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }
}

class MatchmakingRow extends StatelessWidget {
  const MatchmakingRow({
    super.key,
    required this.clientBloc,
  });

  final ClientBloc clientBloc;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 155,
          child: Text(
            clientBloc.getUsername(),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: Colors.blue,
            ),
          ),
        ),
        SizedBox(
          width: 40,
          child: Center(
            child: Text(
              "vs",
              style: TextStyle(
                fontSize: 35,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 155,
          child: Align(
            alignment: Alignment.centerRight,
            child: GlitchText(
              text: "??????",
              fontSize: 30,
              customCharacterSet:
                  "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()_-+=<>?/|}{[]:;,.~`'°²³€¥∞∑≈≠±÷×†‡§•♪♫",
              glitchFrequency: 5,
              textStyle: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
          ),
        )
        // SizedBox(
        //   width: 155,
        //   child: Text(
        //     "Zozo",
        //     textAlign: TextAlign.end,
        //     style: TextStyle(
        //       fontSize: 32,
        //       fontWeight: FontWeight.w600,
        //       color: Colors.red,
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

class Cell extends StatelessWidget {
  const Cell({
    super.key,
    required this.clientBloc,
    required this.colorScheme,
    required this.symbol,
    required this.index,
  });

  final ClientBloc clientBloc;
  final ColorScheme colorScheme;
  final String symbol;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (clientBloc.state is ClientOponnentTurnState && symbol == "") {
          return;
        }
        clientBloc.makeMove(index);
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: colorScheme.secondary,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            symbol,
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.w600,
              color: symbol == "X"
                  ? Colors.blue
                  : (symbol == "O" ? Colors.red : Colors.transparent),
            ),
          ),
        ),
      ),
    );
  }
}
