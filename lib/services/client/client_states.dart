abstract class ClientStates {}

// M E N U

class ClientInitState extends ClientStates {}

class ClientConnectedState extends ClientStates {}

// G A M E

class ClientMatchmakingState extends ClientStates {}

class ClientTurnState extends ClientStates {
  final List<String> board;
  final String oponnent;

  ClientTurnState({required this.board, required this.oponnent});
}

class ClientOponnentTurnState extends ClientStates {
  final List<String> board;
  final String oponnent;

  ClientOponnentTurnState({required this.board, required this.oponnent});
}
