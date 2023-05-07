import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:hive_flutter/hive_flutter.dart';



class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String userInput = '';
  String result = '0';


  List<String> buttonList = [
    'AC',
    '(',
    ')',
    '/',
    '7',
    '8',
    '9',
    '*',
    '4',
    '5',
    '6',
    '+',
    '1',
    '2',
    '3',
    '-',
    'C',
    '0',
    '*',
    '=',
   ];
   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          ValueListenableBuilder(
            valueListenable: Hive.box('settings').listenable(),
            builder: (BuildContext context, dynamic box, Widget? child) {
              final isDark = box.get('isDark', defaultValue: false);
              return Switch(
              value: isDark,
              onChanged: (val) {
               box.put('isDark', val); 
              },
            );
            }
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.centerRight,
                  child: ValueListenableBuilder(
                    valueListenable: Hive.box('settings').listenable(),
                    builder: (context, box, child) {
                    final isDark = box.get('isDark', defaultValue: false);
                    return Text(
                      userInput,
                      style: TextStyle(
                        fontSize: 32,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    );
                    }
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.centerRight,
                  child: ValueListenableBuilder(
                    valueListenable: Hive.box('settings').listenable(),
                    builder: (context, box, child) {
                    final isDark = box.get('isDark', defaultValue: false);
                    return Text(
                      result,
                      style: TextStyle(
                        fontSize: 48,
                        color: isDark ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold
                      ),
                    );
                    }
                  )
                )
              ],
            ) 
          ),
      const Divider(color: Colors.white),
      Expanded(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: GridView.builder(
            itemCount: buttonList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12),
            itemBuilder: (context, index) {
              return customButton(buttonList[index]);
            }),
          

      ),)
        ],
      ), 
    );
  }
  
  Widget customButton(String text) {
    return InkWell(
      splashColor: const Color(0xFF1d2630),
      onTap: (){
        setState(() {
          handleButtons(text);
        });
      },
      child: Ink(
        decoration: BoxDecoration(
          color: getBgColor(text),
          borderRadius: BorderRadius.circular(10),
      boxShadow: [
           BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 0.5,
            offset: const Offset(-3, -3))],
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: getColor(text),
            fontSize: 30,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    ),
  );
  }
  
  getColor(String text) {
    if(
      text == '/' || 
      text == '*' || 
      text == '+' || 
      text == '-' || 
      text == 'C' || 
      text == '(' || 
      text == ')' ) {
        return Color.fromARGB(255, 252, 100, 100);
      }
      return Colors.white;
  }
  
  getBgColor(String text) {
    if (text == 'AC') {
      return Color.fromARGB(255, 252, 100, 100);
    }
    if (text == '=') {
      return Color.fromARGB(255, 104, 204, 159);
    }
    return Color(0xFF1d2630);
  }
  
  void handleButtons(String text) {
    if(text == 'AC') {
      userInput = '';
      result = '0';
      return;
    }
    if(text == 'C') {
      if(userInput.isNotEmpty) {
        userInput = userInput.substring(0, userInput.length - 1);
        return;
      } else {
        return;
      }      
    }

    if(text == '=') {
      result = calculate()!;
      userInput = result;
      if (userInput.endsWith('.0')) {
        userInput = userInput.replaceAll(".0", "");
        return;
      }

      if (result.endsWith('.0')) {
        result = result.replaceAll(".0", "");
        return;
      }
    }

    userInput = userInput + text;
  }
  
  String? calculate() {
    try {
      var exp = Parser().parse(userInput);
      var evaluation = exp.evaluate(EvaluationType.REAL, ContextModel());
      return evaluation.toString();
    } catch (e) {
      return 'Error';
    }
  }
}
