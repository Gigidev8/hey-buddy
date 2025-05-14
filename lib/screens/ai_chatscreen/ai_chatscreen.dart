
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:schoola_buddy/screens/ai_chatscreen/backend/gemini_api.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  String? _imagePath;
  bool _isLoading = false;
  bool _isStreaming = false;
  String _streamingText = "";
  Timer? _streamingTimer;
  String _pendingResponse = "";
  int _currentResponseIndex = 0;
  bool _showCodeBlock = false;
  final int _typingSpeed = 15; // milliseconds per character

  @override
  void initState() {
    super.initState();
    // Add welcome message
    _messages.add(ChatMessage(
      text: "Hi there! I'm your SchoolaBuddy AI assistant. How can I help you today?",
      isUser: false,
      timestamp: DateTime.now(),
    ));
    
    // Ensure initial scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _streamingTimer?.cancel();
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    if (_controller.text.isEmpty && _imagePath == null) return;

    final userMessage = ChatMessage(
      text: _controller.text,
      image: _imagePath,
      isUser: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMessage);
      _isLoading = true;
      _controller.clear();
      _imagePath = null;
    });

    // Scroll to bottom after adding the message
    _scrollToBottom();

    // Get AI response
    final response = await GeminiService.generateResponse(userMessage.text ?? '');
    _pendingResponse = response;
    
    setState(() {
      _isLoading = false;
      _isStreaming = true;
      _streamingText = "";
      _currentResponseIndex = 0;
      
      // Check if response contains code block
      _showCodeBlock = response.contains("```") || 
                      response.contains("class ") || 
                      response.contains("function ") ||
                      response.contains("def ") ||
                      response.contains("import ");
    });

    _streamResponse();
  }

  void _streamResponse() {
    // Create empty message for streaming
    final aiMessage = ChatMessage(
      text: "",
      isUser: false,
      timestamp: DateTime.now(),
      isStreaming: true,
    );
    _messages.add(aiMessage);
    
    // Ensure we scroll to the bottom after adding the initial empty message
    _scrollToBottom();

    _streamingTimer = Timer.periodic(Duration(milliseconds: _typingSpeed), (timer) {
      if (_currentResponseIndex >= _pendingResponse.length) {
        timer.cancel();
        setState(() {
          _isStreaming = false;
          // Update the final complete message
          _messages.last = ChatMessage(
            text: _pendingResponse,
            isUser: false,
            timestamp: _messages.last.timestamp,
            containsCode: _showCodeBlock,
          );
          
          // Final scroll to ensure we're at the bottom with the complete message
          _scrollToBottom();
        });
        return;
      }

      setState(() {
        _streamingText = _pendingResponse.substring(0, _currentResponseIndex + 1);
        _messages.last = ChatMessage(
          text: _streamingText,
          isUser: false,
          timestamp: _messages.last.timestamp,
          isStreaming: true,
          containsCode: _showCodeBlock,
        );
        _currentResponseIndex++;
      });

      // Scroll on every few characters to ensure continuous scrolling
      if (_currentResponseIndex % 20 == 0) {
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    // Improved scroll function that ensures we always reach the bottom
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Theme(
      data: _buildDarkThemeData(theme),
      child: Builder(
        builder: (context) {
          final newTheme = Theme.of(context);
          return Scaffold(
            backgroundColor: newTheme.colorScheme.background,
            appBar: _buildAppBar(newTheme),
            body: Column(
              children: [
                Expanded(child: _buildChatList(newTheme)),
                if (_isLoading) _buildTypingIndicator(newTheme),
                _buildInputSection(newTheme),
              ],
            ),
          );
        }
      ),
    );
  }

  ThemeData _buildDarkThemeData(ThemeData baseTheme) {
    const primaryColor = Color(0xFF7B90FF); // Lighter blue for dark mode
    const backgroundColor = Color(0xFF1A1C23); // Dark background
    const surfaceColor = Color(0xFF252836); // Slightly lighter surface color
    const textColor = Color(0xFFE5E7EB); // Light text for dark background
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        onPrimary: Colors.white,
        secondary: primaryColor.withOpacity(0.2),
        background: backgroundColor,
        surface: surfaceColor,
        onSurface: textColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        foregroundColor: textColor,
        titleTextStyle: TextStyle(
          color: textColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
        ),
      ),
      textTheme: baseTheme.textTheme.copyWith(
        titleLarge: const TextStyle(
          color: textColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: const TextStyle(
          color: textColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: const TextStyle(
          color: textColor,
          fontSize: 16,
          height: 1.5,
        ),
        bodyMedium: const TextStyle(
          color: textColor,
          fontSize: 14,
          height: 1.4,
        ),
        labelMedium: TextStyle(
          color: textColor.withOpacity(0.7),
          fontSize: 12,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: Color(0xFF3A3F50)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: Color(0xFF3A3F50)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: primaryColor),
        ),
        filled: true,
        fillColor: const Color(0xFF1E2029), // Darker input field
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      iconTheme: IconThemeData(
        color: textColor.withOpacity(0.8),
        size: 20,
      ),
      cardTheme: CardTheme(
        elevation: 1,
        color: surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF3A3F50),
        thickness: 1,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme) {
    return AppBar(
      backgroundColor: theme.appBarTheme.backgroundColor,
      elevation: theme.appBarTheme.elevation,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(LucideIcons.arrowLeft, color: theme.iconTheme.color),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        "Study Assistant",
        style: theme.appBarTheme.titleTextStyle,
      ),
      actions: [
        IconButton(
          icon: Icon(LucideIcons.helpCircle, color: theme.iconTheme.color),
          onPressed: _showHelpOverlay,
        ).animate().scale(duration: 200.ms),
      ],
    );
  }

  Widget _buildChatList(ThemeData theme) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        final prevUser = index > 0 ? _messages[index - 1].isUser : !message.isUser;
        final showAvatar = !message.isUser && prevUser != message.isUser;
        final showTimestamp = index == 0 || 
            DateFormat('yyyy-MM-dd').format(_messages[index - 1].timestamp) != 
            DateFormat('yyyy-MM-dd').format(message.timestamp);

        return Column(
          children: [
            if (showTimestamp) _buildDateDivider(message.timestamp, theme),
            ChatBubble(
              message: message,
              showAvatar: showAvatar,
              theme: theme,
            ).animate(delay: 100.ms).slideY(
                begin: 0.1, 
                end: 0,
                curve: Curves.easeOutCubic)
              ..fadeIn(),
          ],
        );
      },
    );
  }

  Widget _buildDateDivider(DateTime timestamp, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(child: Divider(color: theme.dividerTheme.color)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              _formatDateHeader(timestamp),
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(child: Divider(color: theme.dividerTheme.color)),
        ],
      ),
    );
  }

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) {
      return "Today";
    } else if (messageDate == yesterday) {
      return "Yesterday";
    } else {
      return DateFormat('MMMM d, yyyy').format(date);
    }
  }

  Widget _buildTypingIndicator(ThemeData theme) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, bottom: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ).animate(onPlay: (controller) => controller.repeat())
                .fadeOut(duration: 600.ms)
                .fadeIn(duration: 600.ms),
              const SizedBox(width: 5),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ).animate(onPlay: (controller) => controller.repeat())
                .fadeOut(delay: 200.ms, duration: 600.ms)
                .fadeIn(duration: 600.ms),
              const SizedBox(width: 5),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ).animate(onPlay: (controller) => controller.repeat())
                .fadeOut(delay: 400.ms, duration: 600.ms)
                .fadeIn(duration: 600.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputSection(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          if (_imagePath != null) _buildImagePreview(theme),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: const Color(0xFF1E2029), // Darker input background
              border: Border.all(color: const Color(0xFF3A3F50)),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    LucideIcons.image,
                    color: theme.iconTheme.color?.withOpacity(0.6),
                    size: theme.iconTheme.size,
                  ),
                  onPressed: _handleImageUpload,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: theme.textTheme.bodyMedium,
                    maxLines: 5,
                    minLines: 1,
                    decoration: InputDecoration(
                      hintText: "Message SchoolaBuddy...",
                      hintStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.4),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Material(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      onTap: _sendMessage,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Icon(
                          LucideIcons.send,
                          color: theme.colorScheme.onPrimary,
                          size: theme.iconTheme.size,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF3A3F50)),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              _imagePath!,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () => setState(() => _imagePath = null),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleImageUpload() {
    // This is where you'd implement image picking functionality
    setState(() => _imagePath = 'https://example.com/placeholder-image.jpg');
  }

  void _showHelpOverlay() {
    final theme = Theme.of(context);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.4,
        minChildSize: 0.3,
        maxChildSize: 0.8,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.dividerTheme.color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "I can help with...",
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                _buildHelpSection(
                  theme: theme,
                  icon: LucideIcons.bookOpen,
                  title: "Study materials",
                  examples: [
                    "Explain quantum computing",
                    "Summarize this psychology concept",
                    "Help me understand calculus derivatives",
                  ],
                ),
                const SizedBox(height: 20),
                _buildHelpSection(
                  theme: theme,
                  icon: LucideIcons.code,
                  title: "Coding assistance",
                  examples: [
                    "Debug my Python code",
                    "Explain this JavaScript function",
                    "Convert this algorithm to pseudocode",
                  ],
                ),
                const SizedBox(height: 20),
                _buildHelpSection(
                  theme: theme,
                  icon: LucideIcons.calendar,
                  title: "Academic planning",
                  examples: [
                    "Create a study schedule for finals",
                    "Help plan my research project timeline",
                    "Generate a checklist for college applications",
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHelpSection({
    required ThemeData theme,
    required IconData icon,
    required String title,
    required List<String> examples,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: theme.colorScheme.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: theme.textTheme.titleMedium,
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...examples.map((example) => _buildSuggestionChip(example, theme)),
      ],
    );
  }

  Widget _buildSuggestionChip(String text, ThemeData theme) {
    return GestureDetector(
      onTap: () {
        _controller.text = text;
        Navigator.pop(context);
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF313442), // Darker suggestion background
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF3A3F50)),
        ),
        child: Text(
          text,
          style: theme.textTheme.bodyMedium,
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final bool showAvatar;
  final ThemeData theme;

  const ChatBubble({
    super.key,
    required this.message,
    required this.theme,
    this.showAvatar = true,
  });

  @override
  Widget build(BuildContext context) {
    final userBubbleColor = const Color(0xFF2E3655); // Dark blue for user
    final assistantBubbleColor = const Color(0xFF252836); // Dark for assistant
    final cursorColor = theme.colorScheme.primary;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isUser && showAvatar) _buildAvatar(),
          if (!message.isUser && !showAvatar) const SizedBox(width: 40),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isUser ? userBubbleColor : assistantBubbleColor,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.image != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        message.image!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  if (message.image != null) const SizedBox(height: 8),
                  if (message.containsCode)
                    _buildCodeContent(message.text ?? '', theme)
                  else
                    Text(
                      message.text ?? '',
                      style: theme.textTheme.bodyMedium,
                    ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        DateFormat('h:mm a').format(message.timestamp),
                        style: theme.textTheme.labelMedium,
                      ),
                      if (message.isStreaming) ...[
                        const SizedBox(width: 4),
                        Container(
                          width: 5,
                          height: 14,
                          color: cursorColor,
                        ).animate(onPlay: (controller) => controller.repeat())
                          .fadeOut(duration: 600.ms)
                          .fadeIn(duration: 600.ms),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeContent(String text, ThemeData theme) {
    // Parse the text to find code blocks
    final parts = <Widget>[];
    
    // Check if text contains markdown code blocks
    if (text.contains("```")) {
      final blocks = text.split("```");
      
      for (int i = 0; i < blocks.length; i++) {
        if (i % 2 == 0) {
          // Regular text
          if (blocks[i].isNotEmpty) {
            parts.add(Text(
              blocks[i],
              style: theme.textTheme.bodyMedium,
            ));
          }
        } else {
          // Code block
          final codeLines = blocks[i].trim().split('\n');
          String language = '';
          String code = blocks[i].trim();
          
          // Check if first line is language identifier
          if (codeLines.isNotEmpty && !codeLines[0].contains(' ')) {
            language = codeLines[0];
            code = codeLines.sublist(1).join('\n');
          }
          
          parts.add(Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF131417), // Darker code block background
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (language.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      language,
                      style: const TextStyle(
                        color: Color(0xFFBBBBBB),
                        fontSize: 12,
                      ),
                    ),
                  ),
                Text(
                  code,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'monospace',
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ));
        }
      }
    } else if (message.containsCode) {
      // Treat the entire message as code if no markdown but has code markers
      parts.add(Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF131417), // Darker code block background
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'monospace',
            fontSize: 13,
            height: 1.5,
          ),
        ),
      ));
    } else {
      // Regular text if no code detected
      parts.add(Text(
        text,
        style: theme.textTheme.bodyMedium,
      ));
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: parts,
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        LucideIcons.bot,
        color: theme.colorScheme.primary,
        size: 16,
      ),
    );
  }
}

class ChatMessage {
  final String? text;
  final String? image;
  final bool isUser;
  final DateTime timestamp;
  final bool isStreaming;
  final bool containsCode;

  ChatMessage({
    this.text,
    this.image,
    required this.isUser,
    required this.timestamp,
    this.isStreaming = false,
    this.containsCode = false,
  });
}