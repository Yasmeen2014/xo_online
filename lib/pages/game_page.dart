import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    List<String> board = ["", "X", "O", "", "X", "X", "O", "X", "O"];
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 350,
            child: Row(
              children: [
                SizedBox(
                  width: 155,
                  child: Text(
                    "Yousef",
                    style: TextStyle(
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
                        fontSize: 40,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 155,
                  child: Text(
                    "Zozo",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
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
              height: 350,
              child: GridView.builder(
                itemCount: 9,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(2.5),
                    child: Cell(
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

class Cell extends StatelessWidget {
  const Cell({
    super.key,
    required this.colorScheme,
    required this.symbol,
    required this.index,
  });

  final ColorScheme colorScheme;
  final String symbol;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
