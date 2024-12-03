import 'dart:convert';
import 'dart:io';

import 'package:xo_online/models/shared_data.dart';

void main() async {
  // Open server
  final server = await ServerSocket.bind(InternetAddress.anyIPv4, 45368);
  print('Server listening on port 45368');

  // Listen for users connection
  await for (Socket socket in server) {
    handleClient(socket);
  }
}

Map<String, Socket> connectedUsersUToC = {};
Map<Socket, String> connectedUsersCToU = {};

handleClient(Socket socket) {
  print(
      'Connection from: ${socket.remoteAddress.address}:${socket.remotePort}');

  socket.listen(
    (List<int> data) => handleClientRequest(socket, String.fromCharCodes(data)),
    onDone: () {
      print('Client disconnected');
      socket.close();
    },
    onError: (error) {
      print('Error: $error');
      socket.close();
    },
  );
}

List<Socket> matchmaking = [];
Map<Socket, SharedData> currentGames = {};

handleClientRequest(Socket client, String request) {
  Map<String, dynamic> data = jsonDecode(request);
  if (data["type"] == "username") {
    connectedUsersCToU[client] = data["username"];
    connectedUsersUToC[data["username"]] = client;
    Map<String, dynamic> request = {
      "type": "connected",
    };
    client.write(jsonEncode(request));
  } else if (data["type"] == "matchmaking") {
    if (matchmaking.isNotEmpty) {
      Socket oponnent = matchmaking.removeAt(0);

      startGame(client, oponnent);
    } else {
      matchmaking.add(client);
      Map<String, dynamic> data = {
        "type": "match_searching",
      };
      client.write(jsonEncode(data));
      print("Matchmaking ${connectedUsersCToU[client]}");
    }
  } else if (data["type"] == "move") {
    handleMove(data, client);
  }
}

startGame(Socket client, Socket oponnent) {
  // Shared data
  SharedData clientData = SharedData(
    type: "game",
    board: ["", "", "", "", "", "", "", "", ""],
    turn: false,
    oponnent: connectedUsersCToU[oponnent]!,
    symbol: "O",
  );
  SharedData oponnentData = SharedData(
    type: "game",
    board: ["", "", "", "", "", "", "", "", ""],
    turn: true,
    oponnent: connectedUsersCToU[client]!,
    symbol: "X",
  );

  currentGames[client] = clientData;
  currentGames[oponnent] = oponnentData;

  // Send infos to clients
  client.write(clientData.toJson());
  oponnent.write(oponnentData.toJson());

  print(
      "Match between ${connectedUsersCToU[client]} vs ${connectedUsersCToU[oponnent]}");
}

handleMove(Map<String, dynamic> data, Socket client) {
  SharedData clientGameData = currentGames[client]!;

  // Get oponnent & his data
  Socket oponnent = connectedUsersUToC[clientGameData.oponnent]!;
  SharedData oponnentGameData = currentGames[oponnent]!;

  // Update board
  clientGameData.board[data["index"]] = clientGameData.symbol;
  oponnentGameData.board[data["index"]] = clientGameData.symbol;

  // Switch turns
  clientGameData.turn = false;
  oponnentGameData.turn = true;

  // Check if the client won
  if (checkWinner(clientGameData.board, clientGameData.symbol)) {
    Map<String, dynamic> clientData = {
      "type": "match_finished",
      "winner": connectedUsersCToU[client],
    };
    Map<String, dynamic> oponnentData = {
      "type": "match_finished",
      "winner": connectedUsersCToU[client],
    };

    // Send to users
    client.write(jsonEncode(clientData));
    oponnent.write(jsonEncode(oponnentData));

    return;
  }

  client.write(clientGameData.toJson());
  connectedUsersUToC[clientGameData.oponnent]!.write(oponnentGameData.toJson());
}

bool checkWinner(List board, String player) {
  List<List<int>> winningCombos = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];

  // Check each winning combination
  for (var combo in winningCombos) {
    if (board[combo[0]] == player &&
        board[combo[1]] == player &&
        board[combo[2]] == player) {
      return true;
    }
  }
  return false;
}
