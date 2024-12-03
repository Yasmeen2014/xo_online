// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SharedData {
  final String type;
  final List board;
  bool turn;
  final String oponnent;
  final String symbol;

  SharedData({
    required this.type,
    required this.board,
    required this.turn,
    required this.oponnent,
    required this.symbol,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'board': board,
      'turn': turn,
      'oponnent': oponnent,
      'symbol': symbol,
    };
  }

  factory SharedData.fromMap(Map<String, dynamic> map) {
    return SharedData(
      type: map['type'] as String,
      board: map['board'] as List,
      turn: map['turn'] as bool,
      oponnent: map['oponnent'] as String,
      symbol: map['symbol'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SharedData.fromJson(String source) =>
      SharedData.fromMap(json.decode(source) as Map<String, dynamic>);
}
