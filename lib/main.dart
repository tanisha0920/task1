import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Password Generator',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".



  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _length = 12;
  bool _useUpper = true;
  bool _useLower = true;
  bool _useNumbers = true;
  bool _useSymbols = false;
  String _password = '';

   void _generatePassword() {
    if (!_useUpper && !_useLower && !_useNumbers && !_useSymbols) {
      setState(() {
        _password = 'Select at least one option';
      });
      return;
  }
   setState(() {
      _password = PasswordGenerator.generate(
        length: _length.toInt(),
        useUpper: _useUpper,
        useLower: _useLower,
        useNumbers: _useNumbers,
        useSymbols: _useSymbols,
      );
    });
  }

  void _copyPassword() {
    Clipboard.setData(ClipboardData(text: _password));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Password copied to clipboard!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
                // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('Password Generator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          
          children: [
            Text("Password Length: ${_length.toInt()}"),
            Slider(
              min: 8,
              max: 32,
              divisions: 24,
              value: _length,
              onChanged: (val) => setState(() => _length = val),
            ),
            OptionsSwitch(title: 'Include Uppercase', value: _useUpper, onChanged: (v) => setState(() => _useUpper = v)),
            OptionsSwitch(title: 'Include Lowercase', value: _useLower, onChanged: (v) => setState(() => _useLower = v)),
            OptionsSwitch(title: 'Include Numbers', value: _useNumbers, onChanged: (v) => setState(() => _useNumbers = v)),
            OptionsSwitch(title: 'Include Symbols', value: _useSymbols, onChanged: (v) => setState(() => _useSymbols = v)),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _generatePassword, child: const Text('Generate Password')),
            const SizedBox(height: 20),
            PasswordDisplay(password: _password, onCopy: _copyPassword),
          ],
        ),
      ),
    );
  }
}

class OptionsSwitch extends StatelessWidget {
  final String title;
  final bool value;
  final Function(bool) onChanged;

  const OptionsSwitch({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }
}

class PasswordDisplay extends StatelessWidget {
  final String password;
  final VoidCallback onCopy;

  const PasswordDisplay({
    super.key,
    required this.password,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: SelectableText(password, style: const TextStyle(fontSize: 16))),
        IconButton(onPressed: onCopy, icon: const Icon(Icons.copy)),
      ],
    );
  }
}

class PasswordGenerator {
  static String generate({
    required int length,
    required bool useUpper,
    required bool useLower,
    required bool useNumbers,
    required bool useSymbols,
  }) {
    const upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const lower = 'abcdefghijklmnopqrstuvwxyz';
    const numbers = '0123456789';
    const symbols = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

    String chars = '';
    if (useUpper) chars += upper;
    if (useLower) chars += lower;
    if (useNumbers) chars += numbers;
    if (useSymbols) chars += symbols;

    if (chars.isEmpty) return '';

    final rand = Random.secure();
    return List.generate(length, (_) => chars[rand.nextInt(chars.length)]).join();
  }
}
