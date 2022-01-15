import 'package:flutter/material.dart';
import 'package:tic_tac_toe/utils/constants.dart';
import 'package:tic_tac_toe/utils/logic.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String lastValue = "X";
  bool gameOver = false;
  int turn = 0;
  String output = "";

  Game game = Game();
  int canWinPos = 999;

  //Initate game board
  @override
  void initState() {
    game.board = Game.initGameBoard();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double boardWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: MainColor.primaryColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "It's $lastValue turn".toUpperCase(),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 52,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            SizedBox(
              width: boardWidth,
              height: boardWidth,
              child: GridView.count(
                crossAxisCount: Game.boardLength ~/
                    3, // 3 because we have 3 rows and 3 columns
                padding: const EdgeInsets.all(16.0),
                mainAxisSpacing: 6.0,
                crossAxisSpacing: 6.0,
                children: List.generate(Game.boardLength, (index) {
                  return InkWell(
                    splashColor: Colors.transparent,
                    onTap: gameOver
                        ? null
                        : () {
                            if (game.board![index] == 2) {
                              setState(() {
                                turn++;
                                game.board![index] = turn.isOdd ? 3 : 5;
                                canWinPos = game.winnerCheck(
                                    lastValue == "X" ? 3 : 5,
                                    index,
                                    turn,
                                    game.board!);

                                gameOver = (canWinPos == 555) ? true : false;
                                if (gameOver) {
                                  output = "$lastValue is the Winner";
                                } else if (!gameOver && turn == 9) {
                                  output = "It's a Draw!";
                                  gameOver = true;
                                }

                                lastValue == "X"
                                    ? lastValue = "O"
                                    : lastValue = "X";

                                //computer play
                                if (turn < 9 && !gameOver) {
                                  turn++;
                                  if (canWinPos != 999 && canWinPos != 555) {
                                    game.board![canWinPos] = turn.isOdd ? 3 : 5;
                                  } else {
                                    //no one can win so we just fill the bot in any place
                                    canWinPos = game.board!.indexOf(2);
                                    game.board![canWinPos] = turn.isOdd ? 3 : 5;
                                  }
                                  canWinPos = game.winnerCheck(
                                      lastValue == "X" ? 3 : 5,
                                      canWinPos,
                                      turn,
                                      game.board!);

                                  gameOver = (canWinPos == 555) ? true : false;
                                  if (gameOver) {
                                    output = "$lastValue is the Winner";
                                  } else if (!gameOver && turn == 9) {
                                    output = "It's a Draw!";
                                    gameOver = true;
                                  }

                                  lastValue == "X"
                                      ? lastValue = "O"
                                      : lastValue = "X";
                                }
                              });
                            }
                          },
                    child: Container(
                      width: Game.blockSize,
                      height: Game.blockSize,
                      decoration: BoxDecoration(
                        color: MainColor.secondaryColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: Text(
                          game.board![index] == 3
                              ? "X"
                              : game.board![index] == 5
                                  ? "O"
                                  : "",
                          style: TextStyle(
                            color: game.board![index] == 3
                                ? Colors.blue
                                : Colors.pink,
                            fontSize: 64.0,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(
              height: 25.0,
            ),
            Text(
              output,
              style: const TextStyle(color: Colors.black, fontSize: 44.0),
            ),
            const SizedBox(
              height: 25.0,
            ),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  //erase
                  game.board = Game.initGameBoard();
                  lastValue = "X";
                  gameOver = false;
                  turn = 0;
                  output = "";
                });
              },
              style: ElevatedButton.styleFrom(primary: MainColor.accentColor),
              icon: const Icon(Icons.replay),
              label: const Text(
                "Repeat the Game",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ));
  }
}
