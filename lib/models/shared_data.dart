// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SharedData {
  final String type = "game";
  final List<String> board;
  final bool turn;
  final String oponnent;
  final String symbol;

  SharedData({
    required this.board,
    required this.turn,
    required this.oponnent,
    required this.symbol,
  });

  Map<String, dynamic> toMap() {
    return {
      'board': board,
      'turn': turn,
      'oponnent': oponnent,
      'symbol': symbol,
    };
  }

  factory SharedData.fromMap(Map<String, dynamic> map) {
    return SharedData(
      board: List<String>.from(map['board']),
      turn: map['turn'] ?? false,
      oponnent: map['oponnent'] ?? '',
      symbol: map['symbol'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SharedData.fromJson(String source) =>
      SharedData.fromMap(json.decode(source));
}
