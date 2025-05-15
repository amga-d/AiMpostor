import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:agriwise/models/chat_message.dart';
import 'package:agriwise/screens/disease_detection/result_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:agriwise/services/chat_service.dart';

class ChatbotScreen extends StatefulWidget {
  final String chatId;
  final dynamic imageFile;

  const ChatbotScreen({required this.chatId, this.imageFile}) : super();

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatService _chatService = ChatService();
  bool _isLoading = true;
  Map<String, dynamic>? _diseaseData;

  // Messages list
  List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadChatHistory();
  }

  Future<void> _loadChatHistory() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final messages = await _chatService.getChatHistory(widget.chatId);

      // Extract disease info from the response if available
      for (var i = 0; i < messages.length; i++) {
        var message = messages[i];
        if (!message.isUser) {
          try {
            final data = jsonDecode(message.text);
            if (data is Map && data.containsKey('detectedDisease')) {
              _diseaseData = data.cast<String, dynamic>();
              // Remove this message from the chat display
              messages.removeAt(i);
              break;
            }
          } catch (e) {
            // Not JSON content, continue
          }
        }
      }

      setState(() {
        _messages = messages;
        _isLoading = false;
      });

      // Scroll to bottom after loading
      Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
    } catch (e) {
      setState(() {
        _isLoading = false;
        // Add fallback messages if there's an error
        _messages = [
          ChatMessage(
            text:
                _diseaseData != null
                    ? _diseaseData.toString()
                    : 'Error loading chat history.',
            isUser: false,
            timestamp: DateTime.now(),
          ),
        ];
      });
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Widget _buildDiseaseInfoCard() {
    final String diseaseName =
        _diseaseData?['detectedDisease'] ?? 'Bacterial Leaf';
    final String detectionDate =
        '4 May 2025'; // You might want to extract this from somewhere

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Column(
        children: [
          // Disease info
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              children: [
                // Green plant icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFECF8ED),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/plant.svg',
                    width: 67,
                    height: 67,
                  ),
                ),
                const SizedBox(width: 16),
                // Disease details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Detected Disease',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const Text(
                            ' : ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            diseaseName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            'Detected on',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          Text(
                            ' : ',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          Text(
                            detectionDate,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // View Full Report button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: InkWell(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => ResultScreen(
                          results: Map<String, dynamic>.from({
                            'disease': diseaseName,
                            'severity': 'Moderate',
                            'recommendations':
                                'Apply recommended bactericides and monitor daily.',
                          }),
                          imageFile: widget.imageFile,
                        ),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'View Full Report',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: Colors.grey.shade700,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F7F7),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Disease Detection',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: 361,
          height: MediaQuery.of(context).size.height - 140,
          margin: const EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: const Color(0xffA8A8A8), width: 1),
          ),
          child:
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                    children: [
                      // Disease information card
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: _buildDiseaseInfoCard(),
                      ),

                      // Chat messages
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            return _buildMessage(_messages[index]);
                          },
                        ),
                      ),

                      // Message input
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            // Text input field
                            Expanded(
                              child: Container(
                                height: 45,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: 1,
                                  ),
                                ),
                                child: TextField(
                                  controller: _messageController,
                                  decoration: InputDecoration(
                                    hintText: 'Type your question',
                                    hintStyle: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 14,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Send button
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xFF307C42),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 22,
                                ),
                                onPressed: _sendMessage,
                                padding: EdgeInsets.zero,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final messageText = _messageController.text.trim();
    _messageController.clear();

    final userMessage = ChatMessage(
      text: messageText,
      isUser: true,
      timestamp: DateTime.now(),
    );

    // Add user message to chat
    setState(() {
      _messages.add(userMessage);
    });

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);

    // Here you would send the message to your API
    // and handle the response
    // For now, we'll simulate a response

    // For testing, simulate AI response after a delay
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages.add(
          ChatMessage(
            text:
                "Thank you for your question. I'll provide more detailed guidance on managing ${_diseaseData?['detectedDisease'] ?? 'Bacterial Leaf Blight'}. Make sure to follow the recommended actions to control the disease.",
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
      });

      // Scroll to bottom after response
      Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
    });
  }

  Widget _buildMessage(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: message.isUser ? Colors.white : const Color(0xFFF1F1F1),
          borderRadius: BorderRadius.circular(16),
          border:
              message.isUser ? Border.all(color: Colors.grey.shade300) : null,
        ),
        child: Text(message.text, style: const TextStyle(fontSize: 14)),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, -1),
          ),
        ],
        border: Border(top: BorderSide(color: Colors.grey.shade300, width: 1)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(Icons.home, 'Home', true),
            _buildNavItem(Icons.person, 'Profile', false),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    final color = isSelected ? const Color(0xFF3C8D40) : Colors.grey;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: color, fontSize: 12)),
      ],
    );
  }
}
