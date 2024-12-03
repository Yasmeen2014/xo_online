abstract class ClientStates {}

// M E N U

class ClientInitState extends ClientStates {}

class ClientConnectedState extends ClientStates {}

// G A M E

class ClientMatchmakingState extends ClientStates {}

class ClientTurnState extends ClientStates {
  final List board;
  final String oponnent;
  final String symbol;

  ClientTurnState({
    required this.board,
    required this.oponnent,
    required this.symbol,
  });
}

class ClientOponnentTurnState extends ClientStates {
  final List board;
  final String oponnent;
  final String symbol;

  ClientOponnentTurnState({
    required this.board,
    required this.oponnent,
    required this.symbol,
  });
}
