// lib/screens/chatbot.dart
import 'package:flutter/material.dart';
import '../services/ai_service.dart';

class ChatbotPage extends StatefulWidget {
  final Map<String, dynamic>? analysisResults;

  const ChatbotPage({
    super.key,
    this.analysisResults,
  });

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final AIService _aiService = AIService();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();

    // Different greeting based on whether there's analysis data
    if (widget.analysisResults != null) {
      // Analysis results exist - provide context
      _addBotMessage("Hello! I see you've analyzed a plant with potential ${widget.analysisResults!['disease_name']}. What would you like to know about this condition?");
    } else {
      // No analysis - general greeting
      _addBotMessage("Hello! I'm your agricultural assistant. How can I help you with your plant health questions today?");
    }
  }

  void _addBotMessage(String message) {
    setState(() {
      _messages.add(ChatMessage(
        text: message,
        isUser: false,
      ));
    });

    // Scroll to bottom after adding message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSubmitted(String text) async {
    _messageController.clear();

    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
      ));
      _isTyping = true;
    });

    // Scroll to bottom after adding message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    try {
      // Get context from analysis results if available
      String? context;
      if (widget.analysisResults != null) {
        context = "Plant disease detected: ${widget.analysisResults!['disease_name']}, "
                + "Severity: ${widget.analysisResults!['severity']}, "
                + "Symptoms: ${widget.analysisResults!['symptoms']}";
      }

      // Get response from AI
      final response = await _aiService.chatWithAI(text, context: context);

      setState(() {
        _messages.add(ChatMessage(
          text: response,
          isUser: false,
        ));
        _isTyping = false;
      });

      // Scroll to bottom after adding message
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          text: "Sorry, I couldn't process your request. Please try again.",
          isUser: false,
        ));
        _isTyping = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agricultural Assistant'),
        backgroundColor: const Color(0xFF4CAF50),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (_, int index) => _messages[index],
            ),
          ),

          if (_isTyping)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 8.0),
                    child: const CircleAvatar(
                      backgroundColor: Color(0xFF4CAF50),
                      child: Text('AI'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text("Typing..."),
                ],
              ),
            ),

          const Divider(height: 1.0),

          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _messageController,
              onSubmitted: _isTyping ? null : _handleSubmitted,
              decoration: const InputDecoration(
                hintText: 'Ask a question about plant care...',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            color: const Color(0xFF4CAF50),
            onPressed: _isTyping
                ? null
                : () => _handleSubmitted(_messageController.text),
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatMessage({
    super.key,
    required this.text,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: const CircleAvatar(
                backgroundColor: Color(0xFF4CAF50),
                child: Text('AI'),
              ),
            ),
          ],

          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: isUser ? Colors.blue[100] : Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
          ),

          if (isUser)
            Container(
              margin: const EdgeInsets.only(left: 16.0),
              child: const CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text('You'),
              ),
            ),
        ],
      ),
    );
  }
}