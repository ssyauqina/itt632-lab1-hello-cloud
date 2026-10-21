import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hello Cloud',
      home: CloudMessageScreen(),
    );
  }
}

class CloudMessageScreen extends StatefulWidget {
  @override
  _CloudMessageScreenState createState() => _CloudMessageScreenState();
}

class _CloudMessageScreenState extends State<CloudMessageScreen> {
  String message = "Press the button to fetch message from cloud.";
  final TextEditingController controller = TextEditingController();

  Future<void> fetchMessage() async {
    final doc = await FirebaseFirestore.instance
        .collection('messages')
        .doc('welcome')
        .get();

    setState(() {
      message = doc['text'];
    });
  }

  Future<void> updateMessage() async {
    await FirebaseFirestore.instance
        .collection('messages')
        .doc('welcome')
        .update({'text': controller.text});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hello Cloud')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: fetchMessage,
                child: const Text("Fetch from Cloud"),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: 'Enter new message',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: updateMessage,
                child: const Text("Update Cloud Message"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}