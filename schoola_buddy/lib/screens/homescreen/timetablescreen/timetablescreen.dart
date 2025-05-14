import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const TimetableApp());
}

class TimetableApp extends StatelessWidget {
  const TimetableApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.dark(
          primary: Colors.white, // Primary color for text/icons on black background
          secondary: Colors.blueGrey[200]!, // Softer secondary color for accents
          surface: Colors.grey[900]!, // Slightly lighter than black for cards
          background: Colors.black, // True black background
          onSurface: Colors.white, // White text/icons on surface for contrast
        ),
        textTheme: GoogleFonts.spaceMonoTextTheme(
          Theme.of(context).textTheme.apply(
                bodyColor: Colors.white70, // Subtle white for body text
                displayColor: Colors.white, // Bright white for headers
              ),
        ),
        cardColor: Colors.grey[900]!, // Card color matches surface
      ),
      home: const TimetableScreen(),
    );
  }
}

class TimetableScreen extends StatelessWidget {
  const TimetableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSmallScreen = MediaQuery.of(context).size.width < 360;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: FadeInDown(
          duration: const Duration(milliseconds: 600),
          child: Text(
            'SEMESTER TIMETABLE',
            style: GoogleFonts.spaceMono(
              fontWeight: FontWeight.bold,
              letterSpacing: 0,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white70),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInUp(
                duration: const Duration(milliseconds: 600),
                child: _buildHeader(theme, isSmallScreen),
              ),
              const SizedBox(height: 16),
              FadeInUp(
                duration: const Duration(milliseconds: 700),
                child: _buildTimetable(theme, isSmallScreen),
              ),
              const SizedBox(height: 16),
              FadeInUp(
                duration: const Duration(milliseconds: 800),
                child: _buildCourseDetails(theme, isSmallScreen),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, bool isSmallScreen) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(2, 2),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(-2, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'COMPUTER SCIENCE',
                style: GoogleFonts.spaceMono(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                  letterSpacing: 1.5,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white10),
                ),
                child: Text(
                  'SEMESTER 5',
                  style: GoogleFonts.spaceMono(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.secondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Fall 2023 Schedule',
            style: GoogleFonts.spaceMono(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildInfoChip(
                theme,
                Icons.calendar_month_outlined,
                'Sep 4 - Dec 15',
              ),
              _buildInfoChip(
                theme,
                Icons.school_outlined,
                '15 Credits | 5 Courses',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(ThemeData theme, IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.onSurface),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.spaceMono(
              fontSize: 12,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimetable(ThemeData theme, bool isSmallScreen) {
    final timetable = {
      'MON': [
        _CourseSlot('08:00-10:00', 'CS501', 'A101'),
        _CourseSlot('10:30-12:30', 'CS503 Lab', 'LAB B205'),
        _CourseSlot('14:00-16:00', 'CS505', 'A201'),
      ],
      'TUE': [
        _CourseSlot('09:00-11:00', 'CS502', 'B102'),
        _CourseSlot('13:00-15:00', 'CS504', 'A101'),
      ],
      'WED': [
        _CourseSlot('08:00-10:00', 'CS501', 'A101'),
        _CourseSlot('11:00-13:00', 'CS503', 'C301'),
        _CourseSlot('14:00-16:00', 'CS505 Lab', 'LAB B205'),
      ],
      'THU': [
        _CourseSlot('10:00-12:00', 'CS502 Lab', 'LAB A205'),
        _CourseSlot('13:00-15:00', 'CS504', 'A101'),
      ],
      'FRI': [
        _CourseSlot('09:00-11:00', 'CS503', 'B102'),
        _CourseSlot('11:30-13:30', 'CS505', 'A201'),
      ],
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            'WEEKLY SCHEDULE',
            style: GoogleFonts.spaceMono(
              fontSize: 14,
              color: theme.colorScheme.onSurface,
              letterSpacing: 1.5,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(2, 2),
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(-2, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              for (final entry in timetable.entries)
                ZoomIn(
                  duration: const Duration(milliseconds: 600),
                  child: _buildDaySchedule(theme, entry.key, entry.value, isSmallScreen),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDaySchedule(
      ThemeData theme, String day, List<_CourseSlot> slots, bool isSmallScreen) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: isSmallScreen ? 8 : 12,
        horizontal: isSmallScreen ? 12 : 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                day,
                style: GoogleFonts.spaceMono(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                height: 4,
                width: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${slots.length} ${slots.length == 1 ? 'Class' : 'Classes'}',
                style: GoogleFonts.spaceMono(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Column(
            children: [
              for (final slot in slots)
                FadeInRight(
                  duration: const Duration(milliseconds: 600),
                  child: _buildClassItem(theme, slot, isSmallScreen),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildClassItem(ThemeData theme, _CourseSlot slot, bool isSmallScreen) {
    final isLab = slot.course.toLowerCase().contains('lab');

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            width: isSmallScreen ? 50 : 60,
            alignment: Alignment.center,
            child: Text(
              slot.time,
              style: GoogleFonts.spaceMono(
                fontSize: isSmallScreen ? 12 : 14,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          Container(
            width: 1,
            height: isSmallScreen ? 32 : 40,
            margin: EdgeInsets.symmetric(horizontal: isSmallScreen ? 8 : 12),
            color: Colors.white10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  slot.course,
                  style: GoogleFonts.spaceMono(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.bold,
                    color: isLab ? theme.colorScheme.secondary : theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: isSmallScreen ? 12 : 14,
                      color: theme.colorScheme.onSurface,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      slot.room,
                      style: GoogleFonts.spaceMono(
                        fontSize: isSmallScreen ? 11 : 12,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            size: isSmallScreen ? 18 : 24,
            color: theme.colorScheme.onSurface,
          ),
        ],
      ),
    );
  }

  Widget _buildCourseDetails(ThemeData theme, bool isSmallScreen) {
    final courses = [
      _CourseDetail('CS501', 'Advanced Algorithms', 'Dr. Smith'),
      _CourseDetail('CS502', 'Database Systems', 'Prof. Johnson'),
      _CourseDetail('CS503', 'Artificial Intelligence', 'Dr. Williams'),
      _CourseDetail('CS504', 'Computer Networks', 'Prof. Brown'),
      _CourseDetail('CS505', 'Software Engineering', 'Dr. Davis'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            'COURSE DETAILS',
            style: GoogleFonts.spaceMono(
              fontSize: 14,
              color: theme.colorScheme.onSurface,
              letterSpacing: 1.5,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(2, 2),
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(-2, -2),
              ),
            ],
          ),
          padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
          child: Column(
            children: [
              for (final course in courses)
                ZoomIn(
                  duration: const Duration(milliseconds: 600),
                  child: _buildCourseCard(theme, course, isSmallScreen),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCourseCard(ThemeData theme, _CourseDetail course, bool isSmallScreen) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            width: isSmallScreen ? 44 : 52,
            height: isSmallScreen ? 44 : 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10),
            ),
            child: Text(
              course.code,
              style: GoogleFonts.spaceMono(
                fontSize: isSmallScreen ? 14 : 16,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.secondary,
              ),
            ),
          ),
          SizedBox(width: isSmallScreen ? 12 : 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.name,
                  style: GoogleFonts.spaceMono(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  course.professor,
                  style: GoogleFonts.spaceMono(
                    fontSize: isSmallScreen ? 11 : 12,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.more_vert,
            size: isSmallScreen ? 18 : 24,
            color: theme.colorScheme.onSurface,
          ),
        ],
      ),
    );
  }
}

class _CourseSlot {
  final String time;
  final String course;
  final String room;

  _CourseSlot(this.time, this.course, this.room);
}

class _CourseDetail {
  final String code;
  final String name;
  final String professor;

  _CourseDetail(this.code, this.name, this.professor);
}