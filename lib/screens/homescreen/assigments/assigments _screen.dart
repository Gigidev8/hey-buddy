import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AssignmentsScreen extends StatefulWidget {
  const AssignmentsScreen({super.key});

  @override
  _AssignmentsScreenState createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  // Track expanded state for each assignment card
  final List<bool> _expandedStates = List.generate(8, (_) => false);

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
            'ASSIGNMENTS',
            style: GoogleFonts.spaceMono(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white70),
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
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 8),
                child: Text(
                  'COMPUTER SCIENCE ASSIGNMENTS',
                  style: GoogleFonts.spaceMono(
                    fontSize: 14,
                    color: theme.colorScheme.onSurface,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              FadeInUp(
                duration: const Duration(milliseconds: 600),
                child: _buildAssignmentsList(theme, isSmallScreen),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAssignmentsList(ThemeData theme, bool isSmallScreen) {
    final assignments = [
      _Assignment(
        courseCode: 'CS501',
        title: 'Algorithm Analysis Project',
        dueDate: 'May 20, 2025',
        description: 'Implement and analyze sorting algorithms for efficiency.',
        status: 'Not Submitted',
      ),
      _Assignment(
        courseCode: 'CS502',
        title: 'Database Design Assignment',
        dueDate: 'May 22, 2025',
        description: 'Design a normalized database schema for a library system.',
        status: 'In Progress',
      ),
      _Assignment(
        courseCode: 'CS503',
        title: 'AI Model Evaluation',
        dueDate: 'May 25, 2025',
        description: 'Evaluate a pre-trained ML model on a given dataset.',
        status: 'Not Submitted',
      ),
      _Assignment(
        courseCode: 'CS504',
        title: 'Network Security Report',
        dueDate: 'May 27, 2025',
        description: 'Analyze common network vulnerabilities and mitigation.',
        status: 'Not Submitted',
      ),
      _Assignment(
        courseCode: 'CS505',
        title: 'Software Design Document',
        dueDate: 'May 30, 2025',
        description: 'Create a design document for a task management app.',
        status: 'In Progress',
      ),
      _Assignment(
        courseCode: 'CS501',
        title: 'Graph Traversal Assignment',
        dueDate: 'June 1, 2025',
        description: 'Implement BFS and DFS algorithms for a graph.',
        status: 'Not Submitted',
      ),
      _Assignment(
        courseCode: 'CS502',
        title: 'SQL Query Optimization',
        dueDate: 'June 3, 2025',
        description: 'Optimize complex SQL queries for performance.',
        status: 'Not Submitted',
      ),
      _Assignment(
        courseCode: 'CS503',
        title: 'Neural Network Implementation',
        dueDate: 'June 5, 2025',
        description: 'Build a simple neural network using TensorFlow.',
        status: 'Not Submitted',
      ),
    ];

    return Container(
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
        children: List.generate(assignments.length, (index) {
          return ZoomIn(
            duration: const Duration(milliseconds: 600),
            delay: Duration(milliseconds: 100 * index),
            child: _buildAssignmentCard(theme, assignments[index], index, isSmallScreen),
          );
        }),
      ),
    );
  }

  Widget _buildAssignmentCard(
      ThemeData theme, _Assignment assignment, int index, bool isSmallScreen) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: isSmallScreen ? 4 : 8,
        horizontal: isSmallScreen ? 12 : 16,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
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
                    assignment.courseCode,
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
                        assignment.title,
                        style: GoogleFonts.spaceMono(
                          fontSize: isSmallScreen ? 14 : 16,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Due: ${assignment.dueDate}',
                        style: GoogleFonts.spaceMono(
                          fontSize: isSmallScreen ? 11 : 12,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _expandedStates[index]
                        ? Icons.expand_less
                        : Icons.expand_more,
                    size: isSmallScreen ? 18 : 24,
                    color: theme.colorScheme.onSurface,
                  ),
                  onPressed: () {
                    setState(() {
                      _expandedStates[index] = !_expandedStates[index];
                    });
                  },
                ),
              ],
            ),
          ),
          if (_expandedStates[index])
            FadeInDown(
              duration: const Duration(milliseconds: 300),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description:',
                      style: GoogleFonts.spaceMono(
                        fontSize: isSmallScreen ? 12 : 14,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      assignment.description,
                      style: GoogleFonts.spaceMono(
                        fontSize: isSmallScreen ? 11 : 12,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Status: ${assignment.status}',
                      style: GoogleFonts.spaceMono(
                        fontSize: isSmallScreen ? 11 : 12,
                        color: assignment.status == 'In Progress'
                            ? Colors.blueGrey[200]
                            : Colors.red[300],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Assignment {
  final String courseCode;
  final String title;
  final String dueDate;
  final String description;
  final String status;

  _Assignment({
    required this.courseCode,
    required this.title,
    required this.dueDate,
    required this.description,
    required this.status,
  });
}