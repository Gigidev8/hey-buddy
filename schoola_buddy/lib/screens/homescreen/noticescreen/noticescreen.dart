import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LostAndFoundScreen extends StatefulWidget {
  const LostAndFoundScreen({super.key});

  @override
  _LostAndFoundScreenState createState() => _LostAndFoundScreenState();
}

class _LostAndFoundScreenState extends State<LostAndFoundScreen> {
  // Track expanded state for each item card
  final List<bool> _expandedStates = List.generate(4, (_) => false);
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _itemController.dispose();
    _descriptionController.dispose();
    _contactController.dispose();
    super.dispose();
  }

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
            'LOST AND FOUND',
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
            onPressed: () {
              // Add filter functionality if needed
            },
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
                  'SUBMIT LOST OR FOUND ITEM',
                  style: GoogleFonts.spaceMono(
                    fontSize: 14,
                    color: theme.colorScheme.onSurface,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              FadeInUp(
                duration: const Duration(milliseconds: 600),
                child: _buildSubmissionForm(theme, isSmallScreen),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 8),
                child: Text(
                  'RECENT LOST & FOUND POSTS',
                  style: GoogleFonts.spaceMono(
                    fontSize: 14,
                    color: theme.colorScheme.onSurface,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              FadeInUp(
                duration: const Duration(milliseconds: 600),
                child: _buildItemsList(theme, isSmallScreen),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmissionForm(ThemeData theme, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _itemController,
              decoration: InputDecoration(
                labelText: 'Item Name',
                labelStyle: GoogleFonts.spaceMono(
                  color: theme.colorScheme.onSurface,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              style: GoogleFonts.spaceMono(
                fontSize: isSmallScreen ? 12 : 14,
                color: theme.colorScheme.onSurface,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the item name';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: GoogleFonts.spaceMono(
                  color: theme.colorScheme.onSurface,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              style: GoogleFonts.spaceMono(
                fontSize: isSmallScreen ? 12 : 14,
                color: theme.colorScheme.onSurface,
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _contactController,
              decoration: InputDecoration(
                labelText: 'Contact Details (e.g., Phone/Email)',
                labelStyle: GoogleFonts.spaceMono(
                  color: theme.colorScheme.onSurface,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              style: GoogleFonts.spaceMono(
                fontSize: isSmallScreen ? 12 : 14,
                color: theme.colorScheme.onSurface,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter contact details';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Simulate submitting the form
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Item submitted successfully!',
                        style: GoogleFonts.spaceMono(),
                      ),
                      backgroundColor: theme.colorScheme.primary,
                    ),
                  );
                  _itemController.clear();
                  _descriptionController.clear();
                  _contactController.clear();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: isSmallScreen ? 12 : 16,
                  horizontal: isSmallScreen ? 24 : 32,
                ),
              ),
              child: Text(
                'Submit',
                style: GoogleFonts.spaceMono(
                  fontSize: isSmallScreen ? 14 : 16,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsList(ThemeData theme, bool isSmallScreen) {
    final items = [
      _Item(
        title: 'Lost: Black Wallet',
        date: 'May 14, 2025',
        poster: 'John Doe',
        contact: 'john.doe@university.com',
        description: 'Lost a black leather wallet near the library. Contains ID and some cash. Please contact if found.',
        isLost: true,
      ),
      _Item(
        title: 'Found: Blue Backpack',
        date: 'May 13, 2025',
        poster: 'Jane Smith',
        contact: 'jane.smith@university.com',
        description: 'Found a blue backpack in the cafeteria. Contact me to claim it.',
        isLost: false,
      ),
      _Item(
        title: 'Lost: Wireless Earbuds',
        date: 'May 12, 2025',
        poster: 'Alex Brown',
        contact: 'alex.brown@university.com',
        description: 'Lost white wireless earbuds in a black case near the gym. Reward offered.',
        isLost: true,
      ),
      _Item(
        title: 'Found: Silver Ring (User Chat)',
        date: 'May 11, 2025',
        poster: 'Sarah Lee',
        contact: 'sarah.lee@university.com',
        description: 'Found a silver ring in the lecture hall. Message me to describe and claim it.',
        isLost: false,
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
        children: List.generate(items.length, (index) {
          return ZoomIn(
            duration: const Duration(milliseconds: 600),
            delay: Duration(milliseconds: 100 * index),
            child: _buildItemCard(theme, items[index], index, isSmallScreen),
          );
        }),
      ),
    );
  }

  Widget _buildItemCard(ThemeData theme, _Item item, int index, bool isSmallScreen) {
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
                  child: Icon(
                    item.isLost ? Icons.remove_circle : Icons.add_circle,
                    size: isSmallScreen ? 24 : 28,
                    color: item.isLost ? Colors.redAccent : Colors.greenAccent,
                  ),
                ),
                SizedBox(width: isSmallScreen ? 12 : 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: GoogleFonts.spaceMono(
                          fontSize: isSmallScreen ? 14 : 16,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${item.date} | ${item.poster}',
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
                      'Details:',
                      style: GoogleFonts.spaceMono(
                        fontSize: isSmallScreen ? 12 : 14,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      style: GoogleFonts.spaceMono(
                        fontSize: isSmallScreen ? 11 : 12,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Contact: ${item.contact}',
                      style: GoogleFonts.spaceMono(
                        fontSize: isSmallScreen ? 11 : 12,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        // Simulate sending a notification
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Notification successfully sent to ${item.poster}!',
                              style: GoogleFonts.spaceMono(),
                            ),
                            backgroundColor: theme.colorScheme.primary,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: isSmallScreen ? 8 : 12,
                          horizontal: isSmallScreen ? 16 : 24,
                        ),
                      ),
                      child: Text(
                        'Send Message',
                        style: GoogleFonts.spaceMono(
                          fontSize: isSmallScreen ? 12 : 14,
                          color: theme.colorScheme.onPrimary,
                        ),
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

class _Item {
  final String title;
  final String date;
  final String poster;
  final String contact;
  final String description;
  final bool isLost;

  _Item({
    required this.title,
    required this.date,
    required this.poster,
    required this.contact,
    required this.description,
    required this.isLost,
  });
}