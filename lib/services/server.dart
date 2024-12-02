import 'dart:convert';
import 'dart:io';

import 'package:xo_online/models/shared_data.dart';

void main() async {
  // Open server
  final server = await ServerSocket.bind(InternetAddress.anyIPv4, 8080);
  print('Server listening on port 8080');

  // Listen for users connection
  await for (Socket socket in server) {
    handleClient(socket);
  }
}

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

Map<Socket, String> connectedUsers = {};
List<Socket> matchmaking = [];
Map<Socket, SharedData> currentGames = {};

handleClientRequest(Socket client, String request) {
  Map<String, dynamic> data = jsonDecode(request);
  if (data["type"] == "username") {
    connectedUsers[client] = data["username"];
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
      print("Matchmaking ${connectedUsers[client]}");
    }
  }
}

startGame(Socket client, Socket oponnent) {
  // Shared data
  SharedData clientData = SharedData(
    board: List.filled(9, ""),
    turn: false,
    oponnent: connectedUsers[oponnent]!,
    symbol: "O",
  );
  SharedData oponnentData = SharedData(
    board: List.filled(9, ""),
    turn: true,
    oponnent: connectedUsers[client]!,
    symbol: "X",
  );

  // Send infos to clients
  client.write(clientData.toJson());
  oponnent.write(oponnentData.toJson());

  print(
      "Match between ${connectedUsers[client]} vs ${connectedUsers[oponnent]}");
}
