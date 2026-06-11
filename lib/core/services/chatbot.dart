


import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

// ── Small Chatbot Widget for Bottom Sheet ────────────────────────────────────
class SmallChatbotWidget extends StatefulWidget {
  const SmallChatbotWidget({super.key});

  @override
  State<SmallChatbotWidget> createState() => _SmallChatbotWidgetState();
}

class _SmallChatbotWidgetState extends State<SmallChatbotWidget> {
  final String apiKey = 'YOUR_API_KEY_HERE'; // Replace with your key

  late final GenerativeModel model;
  late final ChatSession chat;

  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
    chat = model.startChat();

    // Initial welcome message
    _messages.add({
      'role': 'ai',
      'text': 'Hi! I am the Praktix AI assistant. How can I help you find an expert today?'
    });
  }

  Future<void> _sendMessage() async {
    final text = _controller.text;
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'text': text});
      _isLoading = true;
    });
    _controller.clear();

    try {
      final response = await chat.sendMessage(Content.text(text));
      setState(() {
        _messages.add({'role': 'ai', 'text': response.text ?? 'No response'});
      });
    } catch (e) {
      setState(() {
        _messages.add({'role': 'error', 'text': 'Connection error. Check your API key.'});
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Grab your dynamic theme data here
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest, // Adapts to light/dark
          ),
          child: Row(
            children: [
              Icon(Icons.smart_toy_rounded, color: colorScheme.secondary, size: 24),
              const SizedBox(width: 12),
              Text(
                'AI Assistant',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.close_rounded, color: colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),

        // Chat List
        Expanded(
          child: Container(
            color: theme.scaffoldBackgroundColor,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['role'] == 'user';

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: isUser ? colorScheme.secondary : colorScheme.surface,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(isUser ? 16 : 4),
                        bottomRight: Radius.circular(isUser ? 4 : 16),
                      ),
                      border: isUser ? null : Border.all(color: colorScheme.outlineVariant),
                      boxShadow: [
                        if (!isUser)
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          )
                      ],
                    ),
                    child: Text(
                      msg['text']!,
                      style: textTheme.bodyMedium?.copyWith(
                        color: isUser ? colorScheme.onSecondary : colorScheme.onSurface,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        // Loading Indicator
        if (_isLoading)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'AI is typing...',
              style: textTheme.bodySmall?.copyWith(color: colorScheme.outline),
            ),
          ),

        // Input Area
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _sendMessage(),
                  style: textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Ask about experts or programs...',
                    hintStyle: textTheme.bodyMedium?.copyWith(color: colorScheme.outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: colorScheme.outlineVariant),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: colorScheme.outlineVariant),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: colorScheme.secondary),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: _sendMessage,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.secondary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.send_rounded, color: colorScheme.onSecondary, size: 20),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}