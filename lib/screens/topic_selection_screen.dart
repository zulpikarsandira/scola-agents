import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

class TopicSelectionScreen extends StatefulWidget {
  const TopicSelectionScreen({super.key});

  @override
  State<TopicSelectionScreen> createState() => _TopicSelectionScreenState();
}

class _TopicSelectionScreenState extends State<TopicSelectionScreen> with TickerProviderStateMixin {
  String? _selectedTeacher;
  final Map<String, GlobalKey> _teacherKeys = {};

  final List<Map<String, String>> _teachers = [
    {'name': 'Pak Budi', 'image': 'assets/pak budi.png'},
    {'name': 'Bu Rini', 'image': 'assets/buk rini.png'},
    {'name': 'Pak Aris', 'image': 'assets/pak aris.png'},
  ];

  @override
  void initState() {
    super.initState();
    for (var teacher in _teachers) {
      _teacherKeys[teacher['name']!] = GlobalKey();
    }
  }

  void _playFlyingAnimation(BuildContext buttonContext) {
    if (_selectedTeacher == null) return;

    final teacherKey = _teacherKeys[_selectedTeacher];
    if (teacherKey == null || teacherKey.currentContext == null) return;

    // 1. Get positions
    final RenderBox startBox = buttonContext.findRenderObject() as RenderBox;
    final RenderBox endBox = teacherKey.currentContext!.findRenderObject() as RenderBox;
    
    final startOffset = startBox.localToGlobal(Offset.zero);
    final endOffset = endBox.localToGlobal(Offset.zero);
    
    final startSize = startBox.size;
    final endSize = endBox.size;

    // Center points
    final startPoint = Offset(startOffset.dx + startSize.width / 2, startOffset.dy + startSize.height / 2);
    final endPoint = Offset(endOffset.dx + endSize.width / 2, endOffset.dy + endSize.height / 2 - 20); // Aim slightly above center

    // 2. Create Overlay Entry
    late OverlayEntry overlayEntry;
    
    final animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    final positionAnimation = Tween<Offset>(
      begin: startPoint,
      end: endPoint,
    ).animate(CurvedAnimation(parent: animationController, curve: Curves.easeInOutCubic));

    final scaleAnimation = Tween<double>(
      begin: 1.0, 
      end: 0.2
    ).animate(CurvedAnimation(parent: animationController, curve: Curves.easeIn));

    overlayEntry = OverlayEntry(
      builder: (context) {
        return AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            return Positioned(
              left: positionAnimation.value.dx - 10, // Center ball (20x20)
              top: positionAnimation.value.dy - 10,
              child: Transform.scale(
                scale: scaleAnimation.value,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Color(0xFF3B82F6),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent,
                        blurRadius: 10, 
                        spreadRadius: 2,
                      )
                    ]
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    Overlay.of(context).insert(overlayEntry);

    // 3. Play and Cleanup
    animationController.forward().then((_) {
      overlayEntry.remove();
      animationController.dispose();
    });
  }

  void _showInDevelopment() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Fitur ini dalam pengembangan"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F16), // Match reference dark bg
      body: SafeArea(
        child: Column(
          children: [
            // Dark Card Container
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                decoration: const BoxDecoration(
                  color: Color(0xFF14141E), // Slightly lighter than bg
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  children: [
                    // Scrollable Content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header
                            const SizedBox(height: 20),
                            
                            Text("Guru Virtual Berbasis\nArtificial Intelligence", 
                              style: Theme.of(context).textTheme.displayLarge
                            ),
                            
                            const SizedBox(height: 30),
                            Text("Mata Pelajaran", style: GoogleFonts.inter(color: Colors.white54, fontSize: 14)),
                            const SizedBox(height: 16),
                            
                            // Pills
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                _buildPill("Matematika"),
                                _buildPill("Bahasa Indonesia"),
                                _buildPill("IPA"),
                                _buildPill("IPS"),
                                _buildPill("Bahasa Inggris"),
                                _buildPill("Fisika"),
                                _buildPill("Kimia"),
                                _buildAddButton(),
                              ],
                            ),

                            const SizedBox(height: 40),
                            Text("Jadwal Belajar", style: GoogleFonts.inter(color: Colors.white54, fontSize: 14)),
                            const SizedBox(height: 8),
                            Text("14 Juli 2024 / 14:00", style: GoogleFonts.outfit(color: Colors.white, fontSize: 18)),
                            
                            const SizedBox(height: 32), // Bottom padding for scroll
                          ],
                        ),
                      ),
                    ),

                    // Fixed Footer (Bottom Sheet Style)
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1C26),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 20,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Model AI Guru Virtual", style: GoogleFonts.inter(color: Colors.white54, fontSize: 14)),
                          const SizedBox(height: 16),
                          
                          // Member List (Updated Names)
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                ..._teachers.map((teacher) => _buildMemberAvatar(
                                  teacher['name']!, 
                                  teacher['image']!
                                )).toList(),
                                GestureDetector(
                                   onTap: _showInDevelopment,
                                   child: Container(
                                      margin: const EdgeInsets.only(right: 20),
                                      child: const CircleAvatar(
                                        radius: 28,
                                        backgroundColor: Color(0xFF2C2C35),
                                        child: Text("+", style: TextStyle(color: Colors.white)),
                                      ),
                                   ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Start Button
                          Row(
                            children: [
                              // Button 1: Ngobrol (Voice)
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    if (_selectedTeacher == null) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("Pilih guru terlebih dahulu")),
                                      );
                                      return;
                                    }
                                    Navigator.pushNamed(
                                      context, 
                                      '/active_session',
                                      arguments: _teachers.firstWhere(
                                        (t) => t['name'] == _selectedTeacher
                                      ),
                                    );
                                  },
                                  icon: const Icon(LucideIcons.mic, size: 20),
                                  label: Text("Ngobrol", style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(28),
                                    ),
                                    elevation: 0,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Button 2: Chatting (Text)
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    if (_selectedTeacher == null) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("Pilih guru terlebih dahulu")),
                                      );
                                      return;
                                    }
                                    Navigator.pushNamed(
                                      context, 
                                      '/chat_screen',
                                      arguments: _teachers.firstWhere(
                                        (t) => t['name'] == _selectedTeacher
                                      ),
                                    );
                                  },
                                  icon: const Icon(LucideIcons.messageCircle, size: 20),
                                  label: Text("Chatting", style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(28),
                                      side: const BorderSide(color: Colors.white24), // Subtle border if needed, or just white
                                    ),
                                    elevation: 0,
                                  ),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPill(String text) {
    return Builder(
      builder: (context) {
        return GestureDetector(
          onTap: () {
            if (_selectedTeacher == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Pilih guru terlebih dahulu untuk menambahkan pelajaran")),
              );
              return;
            }
            _playFlyingAnimation(context);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF2C2C35),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(text, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w500)),
          ),
        );
      }
    );
  }
  
  Widget _buildAddButton() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Color(0xFF3B82F6), // Blue
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.add, color: Colors.white, size: 20),
    );
  }

  Widget _buildMemberAvatar(String name, String imagePath) {
    final isSelected = _selectedTeacher == name;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTeacher = name;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 20),
        child: Column(
          children: [
            SizedBox(
              key: _teacherKeys[name], // Assign GlobalKey here
              width: 60,
              height: 60,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  // Blue Background Circle
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6), // Blue
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                  
                  // Pop-out Image
                  if (!isSelected)
                  Positioned(
                    bottom: (name == 'Bu Rini' || name == 'Pak Aris') ? -8 : 0,
                    child: Builder(
                      builder: (context) {
                        double size = 65;
                        if (name == 'Bu Rini') {
                          size = 85; 
                        } else if (name == 'Pak Aris') {
                          size = 75; // Slightly smaller to balance
                        }
                        
                        return Image.asset(
                          imagePath,
                          width: size,
                          height: size,
                          fit: BoxFit.cover,
                        );
                      }
                    ),
                  ),
                  
                  // Selection Overlay
                  if (isSelected)
                    Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        color: Color(0xFF3B82F6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check, color: Colors.white, size: 32),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(name, style: GoogleFonts.inter(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
