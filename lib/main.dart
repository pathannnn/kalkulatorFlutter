// File: kalkulator/lib/main.dart
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const CalculatorScreen(),
        '/history': (context) => HistoryScreen(
              history:
                  ModalRoute.of(context)?.settings.arguments as List<String>?,
            ),
      },
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => CalculatorScreenState();
}

class CalculatorScreenState extends State<CalculatorScreen> {
  String output = "0";
  String expression = "";
  bool resultDisplayed = false;
  List<String> history = [];

  void onButtonPressed(String value) {
    setState(() {
      if (value == "C") {
        output = "0";
        expression = "";
        resultDisplayed = false;
      } else if (value == "=") {
        try {
          String result = evaluateExpression(expression);
          output = result;
          history.add("$expression = $result");
          expression = result;
          resultDisplayed = true;
        } catch (e) {
          output = "Error";
        }
      } else {
        if (resultDisplayed) {
          expression = value;
          resultDisplayed = false;
        } else {
          expression += value;
        }
        output = expression;
      }
    });
  }

  String evaluateExpression(String expression) {
    try {
      Parser parser = Parser();
      Expression exp = parser.parse(expression);
      ContextModel contextModel = ContextModel();
      double result = exp.evaluate(EvaluationType.REAL, contextModel);

      // Remove .0 if the result is an integer
      if (result == result.toInt()) {
        return result.toInt().toString();
      }
      return result.toString();
    } catch (e) {
      return "Error";
    }
  }

  Widget createButton(String text, Color color) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () => onButtonPressed(text),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[300],
            padding: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: text == "C"
                  ? Colors.red
                  : (text == "=" ? Colors.green : Colors.black),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Calculator',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/history',
                arguments: history,
              );
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
            alignment: Alignment.centerRight,
            child: Text(
              output,
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              Row(
                children: [
                  createButton("7", Colors.blue),
                  createButton("8", Colors.blue),
                  createButton("9", Colors.blue),
                  createButton("/", Colors.orange),
                ],
              ),
              Row(
                children: [
                  createButton("4", Colors.blue),
                  createButton("5", Colors.blue),
                  createButton("6", Colors.blue),
                  createButton("*", Colors.orange),
                ],
              ),
              Row(
                children: [
                  createButton("1", Colors.blue),
                  createButton("2", Colors.blue),
                  createButton("3", Colors.blue),
                  createButton("-", Colors.orange),
                ],
              ),
              Row(
                children: [
                  createButton("0", Colors.blue),
                  createButton(".", Colors.blue),
                  createButton("C", Colors.red),
                  createButton("+", Colors.orange),
                ],
              ),
              Row(
                children: [
                  createButton("=", Colors.green),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}

class HistoryScreen extends StatelessWidget {
  final List<String>? history;

  const HistoryScreen({super.key, this.history});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'History',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: history == null || history!.isEmpty
          ? const Center(
              child: Text(
                'No history available.',
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            )
          : ListView.builder(
              itemCount: history!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    history![index],
                    style: const TextStyle(fontSize: 18),
                  ),
                );
              },
            ),
    );
  }
}
