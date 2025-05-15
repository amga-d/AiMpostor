import 'dart:io';

import 'package:agriwise/helpers/download_webp_as_file.dart';
import 'package:agriwise/services/http_service.dart';
import 'package:agriwise/widgets/disease_history_drawer.dart';
import 'package:flutter/material.dart';
import 'package:agriwise/models/chat_message.dart';
import 'package:agriwise/screens/disease_detection/result_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:agriwise/services/chat_service.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:agriwise/screens/home_screen.dart';
import 'package:agriwise/screens/profile_screen.dart';

class ChatbotScreen extends StatefulWidget {
  final String chatId;
  final File? imageFile;

  const ChatbotScreen({required this.chatId, this.imageFile}) : super();

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  int _selectedIndex = 0; // 0 for Home since this is not Profile
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<dynamic> _history = [];

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatService _chatService = ChatService();
  bool _isLoading = true;
  Map<String, dynamic> _diseaseData = {};
  // Messages list
  List<ChatMessage> _messages = [];
  File _imageFile = File('');
  @override
  void initState() {
    super.initState();
    _loadChatHistory();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    try {
      final history = await HttpService().getChatHistory();
      setState(() {
        _history.addAll(history);
      });
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error fetching history: $e')));
    } finally {
      if (_history.isNotEmpty) {
        for (var chat in _history) {
          final createdAt = chat['createdAt'];
          if (createdAt != null && createdAt['_seconds'] != null) {
            final date = DateTime.fromMillisecondsSinceEpoch(
              createdAt['_seconds'] * 1000,
            );
            final formattedDate =
                '${date.day} - ${date.month.toString().padLeft(2, '0')}';
            chat['formattedDate'] = formattedDate;
          }
        }
      }
    }
  }

  Future<void> _loadChatHistory() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final messagesHistory = await _chatService.getMessagesHistory(
        widget.chatId,
      );

      setState(() {
        _messages = messagesHistory['messages'] as List<ChatMessage>;
        _diseaseData = messagesHistory['reportData'] as Map<String, dynamic>;
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
    final String diseaseName;
    final String detectionDate;
    if (_diseaseData != null &&
        _diseaseData.isNotEmpty &&
        _diseaseData['content'] != null) {
      // Extract disease name and date from the report data
      diseaseName =
          _diseaseData['content']['detectedDisease'] ??
          'Unknown Disease'; // Extract disease name if available
      detectionDate =
          _diseaseData['detectionDate'].toString() ??
          'Unknown Date'; // Extract date if available
    } else {
      diseaseName = 'Unknown Disease';
      detectionDate = 'Unknown Date';
    }
    print(_diseaseData);
    if (widget.imageFile == null) {
      downloadWebpAsFile(_diseaseData['publicUrl']).then((file) {
        _imageFile = file;
      });
    } else {
      _imageFile = widget.imageFile!;
    }
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
                            diseaseName.length > 10
                                ? '${diseaseName.substring(0, 10)}...'
                                : diseaseName,
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
                            'response': _diseaseData['content'],
                            'chatId': widget.chatId,
                          }),
                          imageFile: _imageFile,
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
      key: _scaffoldKey,
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
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/disease_detection',
              (Route<dynamic> route) => false,
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.black),
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
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
      endDrawer: DiseaseHistoryDrawer(
        history: _history,
        onHistoryItemTap: (chatId) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ChatbotScreen(chatId: chatId),
            ),
          );
        },
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  void _sendMessage() async {
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

    // Here you would send the message to your API
    // and handle the response
    try {
      // Simulate sending message to the server
      final response = await _chatService.sendMessage(
        widget.chatId,
        messageText,
      );
      final modleMessage = setState(() {
        _messages.add(
          ChatMessage(text: response, isUser: false, timestamp: DateTime.now()),
        );
      });
    } catch (e) {
      // Handle error if needed
      print('Error sending message: $e');
    }

    // Scroll to bottom after response
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
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
        child:
            message.isUser
                ? Text(message.text, style: const TextStyle(fontSize: 14))
                : MarkdownBody(
                  data: message.text,
                  styleSheet: MarkdownStyleSheet(
                    p: const TextStyle(fontSize: 14),
                    strong: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    em: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                  ),
                ),
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

    return GestureDetector(
      onTap: () {
        if (label == 'Home') {
          if (_selectedIndex != 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          }
        } else if (label == 'Profile') {
          if (_selectedIndex != 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }
}
