import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:schoola_buddy/functions/auth/auth_provider.dart';
import 'package:schoola_buddy/screens/callenderscreen.dart';
import 'package:schoola_buddy/screens/homescreen/assigments/assigments%20_screen.dart';
import 'package:schoola_buddy/screens/homescreen/buseat/busseat.dart';
import 'package:schoola_buddy/screens/homescreen/noticescreen/noticescreen.dart';
import 'package:schoola_buddy/screens/homescreen/timetablescreen/timetablescreen.dart';


class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with SingleTickerProviderStateMixin {
  bool _showNotilubot = false;
  bool _isListening = false;
  late AnimationController _animationController;
  final List<double> _soundWaves = List.generate(5, (_) => 0.0);
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  void _toggleNotilubot() {
    setState(() {
      _showNotilubot = !_showNotilubot;
      _isListening = false;
    });
  }
  
  void _startListening() {
    setState(() {
      _isListening = true;
    });
    
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted && _isListening) {
        _updateSoundWaves();
      }
    });
  }
  
  void _updateSoundWaves() {
    if (!mounted || !_isListening) return;
    
    setState(() {
      for (int i = 0; i < _soundWaves.length; i++) {
        _soundWaves[i] = math.Random().nextDouble() * 0.8 + 0.2;
      }
    });
    
    Future.delayed(const Duration(milliseconds: 100), _updateSoundWaves);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final now = DateTime.now();
    final formatter = DateFormat('EEEE, MMM d');
    final timeFormatter = DateFormat('HH:mm');

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          formatter.format(now),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                timeFormatter.format(now),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.white10,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.notifications_outlined,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.white30,
                              child: Text(
                                user?.displayName?.substring(0, 1).toUpperCase() ?? 'U',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hello, ${user?.displayName?.split(' ')[0] ?? 'User'}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  user?.email ?? 'No email available',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.6),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(
                                Icons.logout_rounded,
                                color: Colors.white54,
                              ),
                              onPressed: () async {
                                await ref.read(authProvider.notifier).signOut();
                                if (context.mounted) {
                                  Navigator.pushReplacementNamed(context, '/login');
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.grey.shade900, Colors.black],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white10, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Quad AI Assistant",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.circle, color: Colors.greenAccent, size: 8),
                                  SizedBox(width: 4),
                                  Text(
                                    "Online",
                                    style: TextStyle(color: Colors.white70, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "What can I help you with today?",
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, '/ai_chatscreen');
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    "Ask a question",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      "Quick Actions",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const TimetableScreen()));
                          },
                          child: _buildQuickActionCard("Timetable", Icons.calendar_today_outlined, Colors.blueAccent),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const AssignmentsScreen()));
                          },
                          child: _buildQuickActionCard("Assignments", Icons.assignment_outlined, Colors.orangeAccent),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const BusSeatBookingScreen()));
                          },
                          child: _buildQuickActionCard("Bus Seats", Icons.directions_bus_outlined, Colors.green),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const LostAndFoundScreen()));
                          },
                          child: _buildQuickActionCard("Lost&found", Icons.campaign_outlined, Colors.redAccent),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: Text(
                      "Today's Overview",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildStatusCard(
                            "Arena Crowd Status",
                            "Light - best time to visit",
                            Icons.sports_score_outlined,
                            Colors.greenAccent,
                            progress: 0.3,
                          ),
                          _buildStatusCard(
                            "Next Class",
                            "Database Systems - 2:30 PM, Room 302",
                            Icons.school_outlined,
                            Colors.blueAccent,
                            countdown: "In 45 minutes",
                          ),
                          _buildStatusCard(
                            "Assignment Due",
                            "Network Security Paper - 11:59 PM",
                            Icons.assignment_outlined,
                            Colors.orangeAccent,
                            countdown: "In 8 hours",
                          ),
                          _buildStatusCard(
                            "Campus Event",
                            "Tech Talk - Auditorium A, 4:00 PM",
                            Icons.event_outlined,
                            Colors.purpleAccent,
                            hasButton: true,
                            buttonText: "Register",
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (_showNotilubot)
            Container(
              color: Colors.black.withOpacity(0.8),
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutBack,
                  width: 320,
                  height: _isListening ? 400 : 280,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.deepPurple.shade800, Colors.deepPurple.shade900],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(color: Colors.purple.withOpacity(0.3), blurRadius: 30, spreadRadius: 5),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Notilubot",
                            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            onPressed: _toggleNotilubot,
                            icon: const Icon(Icons.close, color: Colors.white70),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (!_isListening) ...[
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.deepPurple.shade700,
                            boxShadow: [
                              BoxShadow(color: Colors.purple.withOpacity(0.5), blurRadius: 20, spreadRadius: 5),
                            ],
                          ),
                          child: const Icon(Icons.mic, color: Colors.white, size: 50),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          "Would you like to activate voice assistant?",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(height: 25),
                        ElevatedButton(
                          onPressed: _startListening,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purpleAccent,
                            minimumSize: const Size(200, 45),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text(
                            "Yes, I'm ready",
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ] else ...[
                        const SizedBox(height: 20),
                        Text(
                          "Listening...",
                          style: TextStyle(color: Colors.purpleAccent.shade100, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          height: 160,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: List.generate(
                              _soundWaves.length,
                              (index) => AnimatedBuilder(
                                animation: _animationController,
                                builder: (context, child) {
                                  final wave = _soundWaves[index];
                                  return Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 4),
                                    width: 12,
                                    height: 20 + (wave * 120),
                                    decoration: BoxDecoration(
                                      color: Colors.purpleAccent.withOpacity(0.7 + (wave * 0.3)),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          "Speak now...",
                          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: _toggleNotilubot,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(color: Colors.white70, fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          child: BottomNavigationBar(
            backgroundColor: Colors.grey.shade900,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white38,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month_outlined),
                activeIcon: Icon(Icons.calendar_month),
                label: 'Calendar',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline),
                activeIcon: Icon(Icons.chat_bubble),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            currentIndex: 0,
            onTap: (index) {
              if (index == 1) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CalendarScreen()));
              }
              // Handle other navigation indices if needed
            },
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(String title, IconData icon, Color color) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(
    String title,
    String subtitle,
    IconData icon,
    Color color, {
    double? progress,
    String? countdown,
    bool hasButton = false,
    String? buttonText,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13),
                ),
                if (hasButton)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        buttonText ?? "Action",
                        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (progress != null)
            CircularPercentIndicator(
              radius: 18.0,
              lineWidth: 4.0,
              percent: progress,
              center: Text(
                "${(progress * 100).toInt()}%",
                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              ),
              progressColor: color,
              backgroundColor: Colors.white10,
            ),
          if (countdown != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                countdown,
                style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
        ],
      ),
    );
  }
}