// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SharedData {
  final String type = "game";
  final List<String> board;
  final bool turn;
  final String oponnent;

  SharedData({required this.board, required this.turn, required this.oponnent});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'board': board,
      'turn': turn,
      'oponnent': oponnent,
    };
  }

  factory SharedData.fromMap(Map<String, dynamic> map) {
    return SharedData(
      board: List<String>.from((map['board'] as List<String>)),
      turn: map['turn'] as bool,
      oponnent: map['oponnent'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SharedData.fromJson(String source) =>
      SharedData.fromMap(json.decode(source) as Map<String, dynamic>);
}
