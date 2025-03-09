import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(QuizApp());
}

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}

// Welcome Screen
class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[400],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Quiz App",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuizScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Text("Start Quiz", style: TextStyle(color: Colors.blue, fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}

// Quiz Screen with Timer and Score Tracking
class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  int? selectedOptionIndex;
  bool answered = false;
  int score = 0;
  int timer = 10;
  late Timer questionTimer;

  final List<Map<String, dynamic>> questions = [
    {
      "question": "What is the capital of France?",
      "options": ["Berlin", "Paris", "Madrid", "Rome"],
      "answerIndex": 1,
    },
    {
      "question": "What is 2 + 2?",
      "options": ["3", "4", "5", "6"],
      "answerIndex": 1,
    },
  ];

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = 10;
    questionTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (this.timer > 0) {
        setState(() {
          this.timer--;
        });
      } else {
        nextQuestion();
      }
    });
  }

  void checkAnswer(int index) {
    if (!answered) {
      questionTimer.cancel();
      setState(() {
        selectedOptionIndex = index;
        answered = true;
        if (index == questions[currentQuestionIndex]["answerIndex"]) {
          score++;
        }
        Future.delayed(Duration(seconds: 2), nextQuestion);
      });
    }
  }

  void nextQuestion() {
    questionTimer.cancel();
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedOptionIndex = null;
        answered = false;
        startTimer();
      });
    } else {
      showScore();
    }
  }

  void showScore() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Quiz Completed"),
        content: Text("Your score: $score/${questions.length}"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                currentQuestionIndex = 0;
                selectedOptionIndex = null;
                answered = false;
                score = 0;
                startTimer();
              });
            },
            child: Text("Restart"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    questionTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            Text(
              "Time Left: $timer s",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            SizedBox(height: 10),
            Text(
              "Question ${currentQuestionIndex + 1}/${questions.length}",
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            SizedBox(height: 10),
            LinearProgressIndicator(
              value: (currentQuestionIndex + 1) / questions.length,
              color: Colors.blue,
            ),
            SizedBox(height: 30),
            Text(
              currentQuestion["question"],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Column(
              children: List.generate(currentQuestion["options"].length, (index) {
                Color? optionColor;
                if (answered) {
                  if (index == currentQuestion["answerIndex"]) {
                    optionColor = Colors.green[300]; // Correct answer
                  } else if (index == selectedOptionIndex) {
                    optionColor = Colors.red[300]; // Wrong answer
                  } else {
                    optionColor = Colors.grey[200];
                  }
                } else {
                  optionColor = Colors.grey[200];
                }

                return GestureDetector(
                  onTap: () => checkAnswer(index),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(15),
                    margin: EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: optionColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      currentQuestion["options"][index],
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: answered ? nextQuestion : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: answered ? Colors.blue : Colors.grey,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Text("Next", style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
