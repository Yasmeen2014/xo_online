import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xo_online/models/shared_data.dart';
import 'package:xo_online/services/client/client_states.dart';

class ClientBloc extends Cubit<ClientStates> {
  ClientBloc() : super(ClientInitState());

  late Socket server;
  String username = "";

  String getUsername() {
    return username != "" ? username : "???";
  }

  connectToServer(String usernameInput) async {
    // Connect to server
    server = await Socket.connect('192.168.8.106', 8080);
    log('Connected to server at 127.0.0.1:8080');

    // Register username
    Map<String, dynamic> data = {
      "type": "username",
      "username": usernameInput,
    };
    username = usernameInput;
    server.write(jsonEncode(data));

    // Listen to server
    server.listen(
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
      print("Match found!");
      handleGame(data);
    }
  }

  handleGame(Map<String, dynamic> data) {
    // Convert data to Shared Data class

    // If your turn
    if (data["turn"]) {
      log("My turn");
      emit(ClientTurnState(
        board: data["board"],
        oponnent: data["oponnent"],
        symbol: data["symbol"],
      ));
    }
    // If oponnent turn
    else {
      log("Oponnent turn");
      emit(ClientOponnentTurnState(
        board: data["board"],
        oponnent: data["oponnent"],
        symbol: data["symbol"],
      ));
    }
  }

  makeMove(int index) {
    Map<String, dynamic> request = {
      "type": "move",
      "index": index,
    };
    server.write(jsonEncode(request));
  }

  searchForMatch() {
    Map<String, dynamic> data = {
      "type": "matchmaking",
    };
    server.write(jsonEncode(data));
  }
}
