import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const CatchGame());
}

class CatchGame extends StatelessWidget {
  const CatchGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // Ball
  double ballX = 0;
  double ballY = -1;
  double ballSize = 40;
  double ballSpeedX = 0.02;
  double ballSpeedY = 0.02;
  bool movingDown = true;

  // Basket
  double basketX = 0;
  double basketWidth = 100;

  // Game state
  int score = 0;
  int lives = 3;
  bool gameHasStarted = false;
  Timer? gameTimer;

  @override
  void initState() {
    super.initState();
    resetGame();
  }

  void startGame() {
    gameHasStarted = true;
    gameTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      setState(() {
        moveBall();
      });
    });
  }

  void resetGame() {
    setState(() {
      ballX = 0;
      ballY = -1;
      movingDown = true;
      score = 0;
      lives = 3;
      gameHasStarted = false;
    });
    gameTimer?.cancel();
  }

  void moveBall() {
    // Move horizontally
    ballX += ballSpeedX;

    if (ballX <= -1 || ballX >= 1) {
      ballSpeedX *= -1;
    }

    // Move vertically
    ballY += movingDown ? ballSpeedY : -ballSpeedY;

    // Ball reaches bottom
    if (ballY > 0.95) {
      if (ballX >= basketX - basketWidth / MediaQuery.of(context).size.width &&
          ballX <= basketX + basketWidth / MediaQuery.of(context).size.width) {
        score++;
      } else {
        lives--;
        if (lives == 0) {
          gameOver();
          return;
        }
      }
      movingDown = false;
    }

    // Ball reaches top
    if (ballY < -1) {
      movingDown = true;
    }
  }

  void gameOver() {
    gameTimer?.cancel();
    gameHasStarted = false;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Game Over"),
        content: Text("Final Score: $score"),
        actions: [
          TextButton(
            onPressed: () {
              resetGame();
              Navigator.of(context).pop();
            },
            child: const Text("Restart"),
          )
        ],
      ),
    );
  }

  void moveBasket(DragUpdateDetails details) {
    setState(() {
      basketX += details.delta.dx / (MediaQuery.of(context).size.width / 2);
      basketX = basketX.clamp(-1.0, 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!gameHasStarted) startGame();
      },
      onHorizontalDragUpdate: moveBasket,
      child: Scaffold(
        backgroundColor: Colors.blue[200],
        body: Column(
          children: [
            Expanded(
              flex: 4,
              child: Stack(
                children: [
                  // Ball
                  AnimatedContainer(
                    alignment: Alignment(ballX, ballY),
                    duration: const Duration(milliseconds: 0),
                    child: Container(
                      width: ballSize,
                      height: ballSize,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  // Basket
                  Align(
                    alignment: Alignment(basketX, 1),
                    child: Container(
                      width: basketWidth,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  // Tap to start
                  if (!gameHasStarted)
                    const Center(
                      child: Text(
                        "TAP TO START",
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
            // Score & Lives
            Expanded(
              child: Container(
                color: Colors.brown[300],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Score: $score",
                      style: const TextStyle(fontSize: 24, color: Colors.white),
                    ),
                    Text(
                      "Lives: $lives",
                      style: const TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
