import 'package:flutter/material.dart';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  _QuoteScreenState createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  final List<Map<String, String>> _quotes = [
    {
      'quote': "Only through the right education can a better order of society be built up.",
      // 'author': "Steve Jobs",
    },
    {
      'quote': "Education is the key to unlocking the world, a passport to freedom.",
      // 'author': "Steve Jobs",
    },
    {
      'quote':
          "Your time is limited, don't waste it living someone else's life.",
    },
    {
      'quote': "You have to dream before your dreams can come true.",
    },
    {
      'quote': "Life is 10% what happens to us and 90% how we react to it.",
    },
    {
      'quote':
          "The beautiful thing about learning is that no one can take it away from you.",
    },
    {
      'quote':
          "Man needs his difficulties because they are necessary to enjoy success.",
    },
    {
      'quote': "Believe you can and you're halfway there.",
    },
    {
      'quote': "Don't watch the clock; do what it does. Keep going.",
    },
    {
      'quote':
          "Confidence and Hard-work is the only medicine to kill a disease called failure!",
    },
  ];

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startSlidingQuotes();
  }

  void _startSlidingQuotes() {
    Future.delayed(const Duration(seconds: 7), () {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _quotes.length;
        _startSlidingQuotes();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentQuote = _quotes[_currentIndex];


    
    return SizedBox(
    height: 165, 
    width: 500,
    child: Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Quote of the Day',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '"${currentQuote['quote']}"',
              style: const TextStyle(fontSize: 16,
              fontFamily: "Times New Roman" ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // Text(
            //   '- ${currentQuote['author']}',
            //   style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
            // ),
          ],
        ),
      ),
    ),
  );
}

}

