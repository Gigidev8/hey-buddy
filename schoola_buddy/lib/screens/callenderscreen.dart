import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Map<DateTime, List<_Reminder>> _reminders = {};
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  DateTime _reminderDateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _reminders.addAll({
      DateTime.utc(2025, 5, 15): [
        _Reminder(
          title: 'Submit Assignment',
          dateTime: DateTime(2025, 5, 15, 23, 59),
          notes: 'Network Security Paper due by midnight.',
        ),
      ],
      DateTime.utc(2025, 5, 18): [
        _Reminder(
          title: 'Guest Lecture',
          dateTime: DateTime(2025, 5, 18, 15, 0),
          notes: 'AI in Healthcare, Main Auditorium.',
        ),
      ],
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  void _addReminder() async {
    _titleController.clear();
    _notesController.clear();
    _reminderDateTime = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black, // Changed to solid black
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Add Reminder',
            style: GoogleFonts.spaceMono(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  style: GoogleFonts.spaceMono(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: GoogleFonts.spaceMono(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: _reminderDateTime,
                      firstDate: DateTime(2025),
                      lastDate: DateTime(2030),
                      builder: (context, child) {
                        return Theme(
                          data: ThemeData.dark().copyWith(
                            colorScheme: const ColorScheme.dark(
                              primary: Colors.yellow,
                              onPrimary: Colors.black,
                              surface: Colors.black, // Changed to black
                              onSurface: Colors.white,
                            ),
                            dialogBackgroundColor: Colors.black, // Changed to black
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (selectedDate != null) {
                      setState(() {
                        _reminderDateTime = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          _reminderDateTime.hour,
                          _reminderDateTime.minute,
                        );
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Date: ${DateFormat('MMM d, yyyy').format(_reminderDateTime)}',
                          style: GoogleFonts.spaceMono(color: Colors.white70),
                        ),
                        const Icon(Icons.calendar_today, color: Colors.white70, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () async {
                    final selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(_reminderDateTime),
                      builder: (context, child) {
                        return Theme(
                          data: ThemeData.dark().copyWith(
                            colorScheme: const ColorScheme.dark(
                              primary: Colors.yellow,
                              onPrimary: Colors.black,
                              surface: Colors.black, // Changed to black
                              onSurface: Colors.white,
                            ),
                            dialogBackgroundColor: Colors.black, // Changed to black
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (selectedTime != null) {
                      setState(() {
                        _reminderDateTime = DateTime(
                          _reminderDateTime.year,
                          _reminderDateTime.month,
                          _reminderDateTime.day,
                          selectedTime.hour,
                          selectedTime.minute,
                        );
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Time: ${DateFormat('HH:mm').format(_reminderDateTime)}',
                          style: GoogleFonts.spaceMono(color: Colors.white70),
                        ),
                        const Icon(Icons.access_time, color: Colors.white70, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _notesController,
                  style: GoogleFonts.spaceMono(color: Colors.white),
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Notes (Optional)',
                    labelStyle: GoogleFonts.spaceMono(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: GoogleFonts.spaceMono(color: Colors.white70)),
            ),
            ElevatedButton(
              onPressed: () {
                if (_titleController.text.isNotEmpty) {
                  final reminder = _Reminder(
                    title: _titleController.text,
                    dateTime: _reminderDateTime,
                    notes: _notesController.text,
                  );
                  setState(() {
                    final dateKey = DateTime.utc(
                      _reminderDateTime.year,
                      _reminderDateTime.month,
                      _reminderDateTime.day,
                    );
                    _reminders[dateKey] = [...?_reminders[dateKey], reminder];
                    _selectedDay = dateKey;
                  });
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow[600],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                'Add',
                style: GoogleFonts.spaceMono(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  List<_Reminder> _getRemindersForDay(DateTime day) {
    return _reminders[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSmallScreen = MediaQuery.of(context).size.width < 360;

    return Scaffold(
      backgroundColor: Colors.black, // Changed to solid black
      appBar: AppBar(
        title: FadeInDown(
          duration: const Duration(milliseconds: 600),
          child: Text(
            'CALENDAR',
            style: GoogleFonts.spaceMono(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: Colors.white, // Changed to white for contrast
            ),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black, // Already black, kept as is
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white70),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInUp(
                duration: const Duration(milliseconds: 600),
                child: _buildCalendar(theme, isSmallScreen),
              ),
              const SizedBox(height: 16),
              FadeInUp(
                duration: const Duration(milliseconds: 700),
                child: _buildRemindersList(theme, isSmallScreen),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: ZoomIn(
        duration: const Duration(milliseconds: 600),
        child: FloatingActionButton(
          onPressed: _addReminder,
          backgroundColor: Colors.yellow[600], // Kept yellow for contrast
          child: const Icon(Icons.add, color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildCalendar(ThemeData theme, bool isSmallScreen) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black, // Changed to black
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 8, offset: const Offset(2, 2)),
          BoxShadow(color: Colors.white.withOpacity(0.05), blurRadius: 8, offset: const Offset(-2, -2)),
        ],
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2025, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: _onDaySelected,
        calendarFormat: CalendarFormat.month,
        eventLoader: _getRemindersForDay,
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleTextStyle: GoogleFonts.spaceMono(
            fontSize: isSmallScreen ? 16 : 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.white70),
          rightChevronIcon: const Icon(Icons.chevron_right, color: Colors.white70),
        ),
        calendarStyle: CalendarStyle(
          defaultTextStyle: GoogleFonts.spaceMono(color: Colors.white70),
          weekendTextStyle: GoogleFonts.spaceMono(color: Colors.white70),
          outsideTextStyle: GoogleFonts.spaceMono(color: Colors.white30),
          todayDecoration: BoxDecoration(
            color: Colors.yellow[600]!.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          selectedDecoration: const BoxDecoration(
            color: Colors.yellow,
            shape: BoxShape.circle,
          ),
          markerDecoration: const BoxDecoration(
            color: Colors.redAccent,
            shape: BoxShape.circle,
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: GoogleFonts.spaceMono(color: Colors.white70),
          weekendStyle: GoogleFonts.spaceMono(color: Colors.white70),
        ),
      ),
    );
  }

  Widget _buildRemindersList(ThemeData theme, bool isSmallScreen) {
    final reminders = _getRemindersForDay(_selectedDay!);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            'Reminders for ${DateFormat('MMM d, yyyy').format(_selectedDay!)}',
            style: GoogleFonts.spaceMono(
              fontSize: 14,
              color: Colors.white70, // Changed to white70 for consistency
              letterSpacing: 1.5,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black, // Changed to black
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 8, offset: const Offset(2, 2)),
              BoxShadow(color: Colors.white.withOpacity(0.05), blurRadius: 8, offset: const Offset(-2, -2)),
            ],
          ),
          child: reminders.isEmpty
              ? Padding(
                  padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                  child: Text(
                    'No reminders for this day.',
                    style: GoogleFonts.spaceMono(color: Colors.white70, fontSize: isSmallScreen ? 12 : 14),
                  ),
                )
              : Column(
                  children: List.generate(reminders.length, (index) {
                    return ZoomIn(
                      duration: const Duration(milliseconds: 600),
                      delay: Duration(milliseconds: 100 * index),
                      child: _buildReminderCard(theme, reminders[index], isSmallScreen),
                    );
                  }),
                ),
        ),
      ],
    );
  }

  Widget _buildReminderCard(ThemeData theme, _Reminder reminder, bool isSmallScreen) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: isSmallScreen ? 4 : 8, horizontal: isSmallScreen ? 12 : 16),
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8), // Slightly lighter black for contrast
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
              color: Colors.white.withOpacity(0.1), // Changed to match black theme
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10),
            ),
            child: Icon(
              Icons.event,
              size: isSmallScreen ? 24 : 28,
              color: Colors.white70, // Changed to white70
            ),
          ),
          SizedBox(width: isSmallScreen ? 12 : 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reminder.title,
                  style: GoogleFonts.spaceMono(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Changed to white
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Time: ${DateFormat('HH:mm').format(reminder.dateTime)}',
                  style: GoogleFonts.spaceMono(
                    fontSize: isSmallScreen ? 11 : 12,
                    color: Colors.white70, // Changed to white70
                  ),
                ),
                if (reminder.notes.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    reminder.notes,
                    style: GoogleFonts.spaceMono(
                      fontSize: isSmallScreen ? 11 : 12,
                      color: Colors.white70, // Changed to white70
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent, size: 24),
            onPressed: () {
              setState(() {
                final dateKey = DateTime.utc(
                  reminder.dateTime.year,
                  reminder.dateTime.month,
                  reminder.dateTime.day,
                );
                _reminders[dateKey]?.remove(reminder);
                if (_reminders[dateKey]?.isEmpty ?? false) {
                  _reminders.remove(dateKey);
                }
              });
            },
          ),
        ],
      ),
    );
  }
}

class _Reminder {
  final String title;
  final DateTime dateTime;
  final String notes;

  _Reminder({
    required this.title,
    required this.dateTime,
    this.notes = '',
  });
}