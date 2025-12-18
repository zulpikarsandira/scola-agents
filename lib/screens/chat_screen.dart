import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../services/openrouter_service.dart';
import '../config/api_keys.dart';
import 'package:markdown/markdown.dart' as org_markdown;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = []; // 'sender': 'user'|'ai', 'text': '...'
  
  String _teacherName = "Guru";
  String _teacherImage = "";
  
  final ScrollController _scrollController = ScrollController();
  bool _showAppBar = true;
  double _lastOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset <= 0) {
      if (!_showAppBar) setState(() => _showAppBar = true);
      return;
    }

    if (_scrollController.offset > _lastOffset && _showAppBar) {
      setState(() => _showAppBar = false);
    } else if (_scrollController.offset < _lastOffset && !_showAppBar) {
      setState(() => _showAppBar = true);
    }
    _lastOffset = _scrollController.offset;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, String>) {
       if (args.containsKey('name')) _teacherName = args['name']!;
       if (args.containsKey('image')) _teacherImage = args['image']!;
    }
  }

  final OpenRouterService _chatService = OpenRouterService(
    apiKey: Config.openRouterKey,
  );
  bool _isTyping = false;

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    
    _controller.clear();
    setState(() {
      _messages.add({'sender': 'user', 'text': text});
      _isTyping = true;
    });

    try {
      final response = await _chatService.chatWithText(
        text,
        systemPrompt: "Kamu adalah $_teacherName. Jawablah dengan singkat, jelas, dan membantu dalam Bahasa Indonesia.",
        model: "google/gemma-3n-e2b-it:free",
      );

      if (mounted) {
        setState(() {
          _isTyping = false;
          if (response != null) {
            _messages.add({
              'sender': 'ai', 
              'text': response
            });
          } else {
             _messages.add({
              'sender': 'ai', 
              'text': 'Maaf, saya sedang mengalami gangguan koneksi.'
            });
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add({
             'sender': 'ai', 
             'text': 'Terjadi kesalahan: $e'
           });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F16),
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: _showAppBar ? kToolbarHeight + MediaQuery.of(context).padding.top : 0,
          child: AppBar(
            backgroundColor: Colors.transparent, 
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: _showAppBar ? IconButton(
              icon: const Icon(LucideIcons.menu, color: Colors.white),
              onPressed: () {}, 
            ) : null,
            title: _showAppBar ? Center(
                child: Text(
              "Guru Virtual",
              style: GoogleFonts.outfit(color: Colors.white, fontSize: 18),
            )) : null,
            actions: _showAppBar ? [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.pinkAccent,
                  child: Text("S",
                      style: GoogleFonts.outfit(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              )
            ] : null,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty 
              ? SingleChildScrollView(
                  controller: _scrollController,
                  child: _buildGreetingView()
                ) 
              : _buildMessageList(),
          ),
          Stack(
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: [
              Positioned(
                bottom: 80, // Stick out from behind the bar
                left: 0,
                right: 0,
                child: Opacity(
                  opacity: 1.0, // Full vibrancy like the image
                  child: Lottie.asset(
                    'assets/animation.json',
                    fit: BoxFit.contain,
                    height: 250,
                  ),
                ),
              ),
              _buildInputBar(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGreetingView() {
    return Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF4285F4), Color(0xFF9B72CB)], // Google Blue to Purple
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: Text(
                "Halo Siswa",
                style: GoogleFonts.outfit(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Required for ShaderMask
                  height: 1.1,
                ),
              ),
            ),
            Text(
              "Sebaiknya kita mulai\ndari mana?",
              style: GoogleFonts.outfit(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF444746), // Dimmed text like Gemini
                height: 1.1,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ));
  }
  
  Widget _buildSkeletonLine({required double width}) {
    return Container(
      width: width,
      height: 16,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1F20),
        borderRadius: BorderRadius.circular(8),
      ),
    )
    .animate(onPlay: (controller) => controller.repeat())
    .shimmer(
      duration: 1.5.seconds,
      color: Colors.white.withOpacity(0.05),
    )
    .then()
    .fadeIn(duration: 800.ms);
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(top: kToolbarHeight + 40, left: 16, right: 16, bottom: 16),
      itemCount: _messages.length + (_isTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _messages.length) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSkeletonLine(width: 150),
                  const SizedBox(height: 8),
                  _buildSkeletonLine(width: 250),
                  const SizedBox(height: 8),
                  _buildSkeletonLine(width: 200),
                ],
              ),
            ),
          );
        }
        final msg = _messages[index];
        final isUser = msg['sender'] == 'user';
        return Align(
          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isUser ? const Color(0xFF3B82F6) : const Color(0xFF1E1F20),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: isUser ? const Radius.circular(16) : const Radius.circular(0),
                bottomRight: isUser ? const Radius.circular(0) : const Radius.circular(16),
              ),
            ),
            child: MarkdownBody(
              data: msg['text']!,
              selectable: false, // Builders work better when not trying to strictly maintain single SelectableText
              styleSheet: MarkdownStyleSheet(
                p: GoogleFonts.inter(color: Colors.white, fontSize: 14),
                strong: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                code: GoogleFonts.jetBrainsMono(
                   backgroundColor: Colors.transparent, 
                   color: Colors.white
                ),
                // codeblockDecoration removed to let builder handle it
              ),
              builders: {
                'pre': CodeElementBuilder(context),
                'code': CodeElementBuilder(context),
              },
            ),
          ),
        );
      },
    );
  }
  
  // existing _buildInputBar ...


  Widget _buildInputBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1F20), // Solid dark gray like in image
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            style: GoogleFonts.outfit(color: Colors.white, fontSize: 18),
            decoration: InputDecoration(
              hintText: "Malu bertanya sesat di jalan, jadi ayo nanya",
              hintStyle: GoogleFonts.outfit(color: Colors.white54, fontSize: 18),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            onSubmitted: (_) => _sendMessage(),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFF2C2C2C),
                radius: 22,
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.white, size: 22),
                  onPressed: () {},
                ),
              ),
              const Spacer(),
              CircleAvatar(
                backgroundColor: const Color(0xFF2C2C2C),
                radius: 22,
                child: IconButton(
                  icon: const Icon(LucideIcons.mic, color: Colors.white, size: 22),
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 12),
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 22,
                child: IconButton(
                  icon: const Icon(LucideIcons.sparkles, color: Colors.black, size: 22), // Gemini Sparkle
                  onPressed: _sendMessage,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10), // Extra bottom padding for mobile aesthetic
        ],
      ),
    );
  }
}

class CodeElementBuilder extends MarkdownElementBuilder {
  final BuildContext context;
  CodeElementBuilder(this.context);

  @override
  Widget? visitText(org_markdown.Text text, TextStyle? preferredStyle) {
     return null; 
  }

  @override
  Widget? visitElementAfter(org_markdown.Element element, TextStyle? preferredStyle) {
    // 1. If it's a 'pre' tag, it's definitely a code block. Render container.
    if (element.tag == 'pre') {
      return _buildCodeContainer(element.textContent);
    }

    // 2. If it's a 'code' tag:
    if (element.tag == 'code') {
      // Check if it's multiline. If yes, wrap in container.
      // Note: If this 'code' is inside a 'pre' that we ALREADY handled, this might not validly trigger 
      // if the 'pre' builder replaced the subtree. 
      // But if 'pre' builder didn't fire (e.g. standard indented code?), checking newline is a good heuristic.
      if (element.textContent.contains('\n')) {
         return _buildCodeContainer(element.textContent);
      }
      // Otherwise, let valid inline code be rendered by default (text span)
      return null; 
    }
    
    return null;
  }

  Widget _buildCodeContainer(String textContent) {
    final cleanText = textContent.trimRight(); // minor cleanup

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2B2D31),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF1E1F22),
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Code",
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: cleanText));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Code copied!'), duration: Duration(seconds: 1)),
                    );
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.copy, size: 14, color: Colors.white70),
                      SizedBox(width: 4),
                      Text("Copy", style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SelectableText(
                cleanText,
                style: GoogleFonts.jetBrainsMono(fontSize: 13, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
