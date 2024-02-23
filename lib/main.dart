import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

// When you first launch the app the size of the window will be set to default size
// I wanted to change that so I tried the below method to set the screen size of the app but it didn't work
// Please decrease the wize of the window to match with the border of the calculator
// to have the buttons of the app aligned properly and to avoid overflowing


//// import 'package:desktop_window/desktop_window.dart';

// Future testWindowFunctions() async {
//     Size size = await DesktopWindow.getWindowSize();
//     print(size);
//     await DesktopWindow.setWindowSize(Size(500,500));

//     await DesktopWindow.setMinWindowSize(Size(400,400));
//     await DesktopWindow.setMaxWindowSize(Size(800,800));

//     await DesktopWindow.resetMaxWindowSize();
//     await DesktopWindow.toggleFullScreen();
//     // ignore: unused_local_variable
//     bool isFullScreen = await DesktopWindow.getFullScreen();
//     await DesktopWindow.setFullScreen(true);
//     await DesktopWindow.setFullScreen(false);
// }


void main() {
  runApp(CalculatorApp());
}

// Root widget for the application
class CalculatorApp extends StatelessWidget {
  const CalculatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator App',
      theme: ThemeData(
      ),
      debugShowCheckedModeBanner: false,
      home: const CalculatorView(),
      //Set the size/boundaries for the application
      builder: (context, child) {
        return Center(
          child: SizedBox(
            width: 400, // Set the desired width
            height: 900, // Set the desired height
            child: child,
          ),
        );
      },
    );
  }
}

// Main calculator widget
class CalculatorView extends StatefulWidget {
  const CalculatorView({Key? key}) : super(key: key);

  @override
  State<CalculatorView> createState() => _CalculatorViewState();
}

// State for the CalculatorView widget
class _CalculatorViewState extends State<CalculatorView> {
  // State variables
  String equation = "0";
  String result = "0";
  String expression = "";

  // Function to handle button presses
  void buttonPressed(String buttonText) {
    // Function to remove decimal if it doesn't have any value after it
    String removeDecimal(dynamic result) {
      if (result.toString().contains('.')) {
        List<String> splitDecimal = result.toString().split('.');
        if (!(int.parse(splitDecimal[1]) > 0)) {
          return result = splitDecimal[0].toString();
        }
      }
      return result;
    }

    setState(() {
      // Clear the equation and result
      if (buttonText == "C") {
        equation = "0";
        result = "0";
      }
      // Delete the last character from the equation
      else if (buttonText == "⌫") {
        equation = equation.substring(0, equation.length - 1);
        if (equation == "") {
          equation = "0";
        }
      }
      // Change sign of the number
      else if (buttonText == "+/-") {
        if (equation[0] != '-') {
          equation = '-$equation';
        } else {
          equation = equation.substring(1);
        }
      }
      // Calculate the result
      else if (buttonText == "=") {
        expression = equation;
        expression = expression.replaceAll('×', '*');
        expression = expression.replaceAll('÷', '/');
        expression = expression.replaceAll('%', '%');

        try {
          Parser p = Parser();
          Expression exp = p.parse(expression);

          ContextModel cm = ContextModel();
          result = '${exp.evaluate(EvaluationType.REAL, cm)}';
          // Remove decimal if not necessary
          if (expression.contains('%')) {
            result = removeDecimal(result);
          }
          // Handle NaN and Infinity
          if (result == 'NaN') {
            result = 'Invalid expression';
          } else if (result == 'Infinity' || result == '-Infinity') {
            result = 'Division Error';
          }
          
        } catch (e) {
          result = "Error";
        }
      }
      // Append the button text to the equation
      else {
        if (equation == "0") {
          equation = buttonText;
        } else {
          equation = equation + buttonText;
        }
      }
    });
  }

  //Build the UI of the application
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blueGrey,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Result display
            Align(
              alignment: Alignment.bottomRight,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Result text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            result,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 50,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),


                    
                    // Equation text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            equation,
                            style: const TextStyle(
                              fontSize: 30,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.backspace_outlined,
                            color: Colors.lightBlue,
                            size: 30,
                          ),
                          onPressed: () {
                            buttonPressed("⌫");
                          },
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Calculator buttons
            // Buttons for clearing, percentage, division, multiplication
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                calcButton('C', Colors.lightBlue, () => buttonPressed('C')),
                calcButton('%', Colors.blueGrey, () => buttonPressed('%')),
                calcButton('÷', Colors.blueGrey, () => buttonPressed('÷')),
                calcButton("×", Colors.blueGrey, () => buttonPressed('×')),
              ],
            ),
            const SizedBox(height: 10), // Space between rows
            // Buttons for numbers 7, 8, 9, subtraction
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                calcButton('7', Colors.grey, () => buttonPressed('7')),
                calcButton('8', Colors.grey, () => buttonPressed('8')),
                calcButton('9', Colors.grey, () => buttonPressed('9')),
                calcButton('-', Colors.blueGrey, () => buttonPressed('-')),
              ],
            ),
            const SizedBox(height: 10),
            // Buttons for numbers 4, 5, 6, addition
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                calcButton('4', Colors.grey, () => buttonPressed('4')),
                calcButton('5', Colors.grey, () => buttonPressed('5')),
                calcButton('6', Colors.grey, () => buttonPressed('6')),
                calcButton('+', Colors.blueGrey, () => buttonPressed('+')),
              ],
            ),
            const SizedBox(height: 10),
            // Buttons for numbers 1, 2, 3, +/-, 0, decimal, and equals
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        calcButton('1', Colors.grey, () => buttonPressed('1')),
                        SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                        calcButton('2', Colors.grey, () => buttonPressed('2')),
                        SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                        calcButton('3', Colors.grey, () => buttonPressed('3')),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        calcButton('+/-', Colors.blueGrey, () => buttonPressed('+/-')),
                        SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                        calcButton('0', Colors.blueGrey, () => buttonPressed('0')),
                        SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                        calcButton('.', Colors.blueGrey, () => buttonPressed('.')),
                      ],
                    ),
                  ],
                ),
                calcButton('=', Colors.lightBlue, () => buttonPressed('=')),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

// Function to create calculator buttons
Widget calcButton(
  String buttonText, Color buttonColor, void Function()? buttonPressed) {
  return Container(
    width: 80,
    height: buttonText == '=' ? 150 : 70, // Set button height
    padding: const EdgeInsets.all(0),
    child: ElevatedButton(
      onPressed: buttonPressed,
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        backgroundColor: buttonColor,
      ),
      child: Text(
        buttonText,
        style: const TextStyle(fontSize: 22, color: Colors.white),
      ),
    ),
  );
}
