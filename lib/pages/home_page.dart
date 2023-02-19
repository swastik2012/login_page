// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class HomePage extends StatelessWidget {
//    HomePage({super.key});

//   final user = FirebaseAuth.instance.currentUser!;

//   void signUserOut() {
//     FirebaseAuth.instance.signOut();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [IconButton(onPressed: signUserOut, icon: Icon(Icons.logout))],
//       ),
//       body: Center(
//         child: Text("Logged In As: " + user.email!, 
//         style: TextStyle(fontSize: 20),),
//       ),
//     );
//   }
// }
// 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

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final String apiUrl = 'https://api.openai.com/v1/engines/davinci/jobs';
  final String apiKey = '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';
  final TextEditingController _textController = TextEditingController();
  List<String> _messages = [];

  Future<void> _sendMessage(String message) async {
    final response = await http.post(
      apiUrl as Uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'prompt': message,
        'max_tokens': 100,
        'temperature': 0.5,
      }),
    );

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      final generatedMessage = responseJson['choices'][0]['text'];

      setState(() {
        _messages.insert(0, generatedMessage);
        _textController.clear();
      });
    } else {
      throw Exception('Failed to send message');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with GPT-3'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: EdgeInsets.all(10.0),
                  child: Text(_messages[index]),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                  ),
                ),
                SizedBox(width: 10.0),
                ElevatedButton(
                  onPressed: () async {
                    await _sendMessage(_textController.text);
                  },
                  child: Text('Send'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
