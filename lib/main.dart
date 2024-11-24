import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RandomPostApp(),
    );
  }
}

class RandomPostApp extends StatefulWidget {
  const RandomPostApp({super.key});

  @override
  State<RandomPostApp> createState() => _RandomPostAppState();
}

class _RandomPostAppState extends State<RandomPostApp> {
  Map<String, dynamic>? _post;
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _fetchRandomPost() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await http.get(Uri.parse(
          'https://jsonplaceholder.typicode.com/posts/${Random().nextInt(100) + 1}'));
      if (response.statusCode == 200) {
        setState(() {
          _post = jsonDecode(response.body);
          _isLoading = false;
        });
      } else {
        throw Exception('No Post found');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'An error occurred: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Fetch Data from an API',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _post != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Title: ${_post!['title']}',
                          style: const TextStyle(
                              fontSize: 18, color: Colors.white)),
                      const SizedBox(height: 16),
                      Text('Body: ${_post!['body']}',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white)),
                    ],
                  )
                : _errorMessage.isNotEmpty
                    ? Text(_errorMessage)
                    : const Text('No post found. Try again',
                        style: TextStyle(fontSize: 16, color: Colors.white)),
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(12),
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(5),
          ),
        ),
        backgroundColor: Colors.red,
        onPressed: _fetchRandomPost,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
