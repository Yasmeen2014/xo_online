import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xo_online/models/shared_data.dart';
import 'package:xo_online/services/client/client_states.dart';

class ClientBloc extends Cubit<ClientStates> {
  ClientBloc() : super(ClientInitState());

  late Socket socket;

  connectToServer(String usernameInput) async {
    // Connect to server
    socket = await Socket.connect('127.0.0.1', 8080);
    log('Connected to server at 127.0.0.1:8080');

    // Register username
    Map<String, dynamic> data = {
      "type": "username",
      "username": usernameInput,
    };
    socket.write(jsonEncode(data));

    // Listen to server
    socket.listen(
      (List<int> request) => handleServerRequests(
        String.fromCharCodes(request),
      ),
    );
  }

  handleServerRequests(String request) {
    // Decode request to map
    Map<String, dynamic> data = jsonDecode(request);

    // Get request type
    if (data["type"] == "connected") {
      log("Connected to server");
      emit(ClientConnectedState());
    } else if (data["type"] == "match_searching") {
      log("Searching for a match...");
      emit(ClientMatchmakingState());
    } else if (data["type"] == "game") {
      handleGame(data);
    }
  }

  handleGame(Map<String, dynamic> data) {
    // Convert data to Shared Data class
    SharedData gameData = SharedData.fromMap(data);

    // If your turn
    if (gameData.turn) {
      log("My turn");
      emit(ClientTurnState(
        board: gameData.board,
        oponnent: gameData.oponnent,
      ));
    }
    // If oponnent turn
    else {
      log("Oponnent turn");
      emit(ClientOponnentTurnState(
        board: gameData.board,
        oponnent: gameData.oponnent,
      ));
    }
  }

  searchForMatch() {
    Map<String, dynamic> data = {
      "type": "matchmaking",
    };
    socket.write(jsonEncode(data));
  }
}
