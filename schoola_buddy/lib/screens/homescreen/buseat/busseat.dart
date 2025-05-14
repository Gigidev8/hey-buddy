import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BusSeatBookingScreen extends StatelessWidget {
  const BusSeatBookingScreen({super.key});

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
            'SCHOOL BUS BOOKING',
            style: GoogleFonts.spaceMono(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: Colors.black87,
            ),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.yellow[600],
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              FadeInUp(
                duration: const Duration(milliseconds: 600),
                child: _buildHeader(theme, isSmallScreen),
              ),
              const SizedBox(height: 24),
              FadeInUp(
                duration: const Duration(milliseconds: 700),
                child: _buildScanButton(theme, isSmallScreen),
              ),
              const SizedBox(height: 24),
              FadeInUp(
                duration: const Duration(milliseconds: 800),
                child: _buildBusList(theme, isSmallScreen),
              ),
              const SizedBox(height: 16),
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
        color: Colors.yellow[100],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(2, 2),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.5),
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
                'SCHOOL BUS ROUTES',
                style: GoogleFonts.spaceMono(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  letterSpacing: 1.5,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black26),
                ),
                child: Text(
                  '2025-2026',
                  style: GoogleFonts.spaceMono(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Book Your Seat',
            style: GoogleFonts.spaceMono(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildInfoChip(
                theme,
                Icons.directions_bus,
                '5 Routes Available',
              ),
              _buildInfoChip(
                theme,
                Icons.event_seat,
                'Seats: 40 per bus',
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
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black26),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.black87),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.spaceMono(
              fontSize: 12,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanButton(ThemeData theme, bool isSmallScreen) {
    return Builder(
      builder: (context) => Center(
        child: ZoomIn(
          duration: const Duration(milliseconds: 600),
          child: ElevatedButton(
            onPressed: () {
              // Placeholder for QR code scanning functionality
              // Add package like `qr_code_scanner` for actual implementation
              ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('QR Code Scanner Placeholder')),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.yellow[600],
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 24 : 32,
              vertical: isSmallScreen ? 16 : 20,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 8,
            shadowColor: Colors.black.withOpacity(0.3),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.qr_code_scanner,
                size: isSmallScreen ? 24 : 28,
                color: Colors.black87,
              ),
              const SizedBox(width: 8),
              Text(
                'SCAN QR CODE',
                style: GoogleFonts.spaceMono(
                  fontSize: isSmallScreen ? 16 : 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _buildBusList(ThemeData theme, bool isSmallScreen) {
    final buses = [
      _Bus(route: 'Route A  ', seatsAvailable: 12, qrCode: 'QR_A_001'),
      _Bus(route: 'Route B ', seatsAvailable: 8, qrCode: 'QR_B_002'),
      _Bus(route: 'Route C -', seatsAvailable: 15, qrCode: 'QR_C_003'),
      _Bus(route: 'Route D -', seatsAvailable: 5, qrCode: 'QR_D_004'),
      _Bus(route: 'Route E -', seatsAvailable: 20, qrCode: 'QR_E_005'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            'AVAILABLE BUSES',
            style: GoogleFonts.spaceMono(
              fontSize: 14,
              color: Colors.black87,
              letterSpacing: 1.5,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.yellow[100],
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(2, 2),
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.5),
                blurRadius: 8,
                offset: const Offset(-2, -2),
              ),
            ],
          ),
          child: Column(
            children: List.generate(buses.length, (index) {
              return FadeInRight(
                duration: const Duration(milliseconds: 600),
                delay: Duration(milliseconds: 100 * index),
                child: _buildBusCard(theme, buses[index], isSmallScreen),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildBusCard(ThemeData theme, _Bus bus, bool isSmallScreen) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: isSmallScreen ? 4 : 8,
        horizontal: isSmallScreen ? 12 : 16,
      ),
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black26),
      ),
      child: Row(
        children: [
          Container(
            width: isSmallScreen ? 44 : 52,
            height: isSmallScreen ? 44 : 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.yellow[600]!.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black26),
            ),
            child: Icon(
              Icons.directions_bus,
              size: isSmallScreen ? 24 : 28,
              color: Colors.black87,
            ),
          ),
          SizedBox(width: isSmallScreen ? 12 : 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bus.route,
                  style: GoogleFonts.spaceMono(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Seats Available: ${bus.seatsAvailable}',
                  style: GoogleFonts.spaceMono(
                    fontSize: isSmallScreen ? 11 : 12,
                    color: Colors.black87.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'QR Code: ${bus.qrCode}',
                  style: GoogleFonts.spaceMono(
                    fontSize: isSmallScreen ? 11 : 12,
                    color: Colors.black87.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: isSmallScreen ? 18 : 24,
            color: Colors.black87.withOpacity(0.7),
          ),
        ],
      ),
    );
  }
}

class _Bus {
  final String route;
  final int seatsAvailable;
  final String qrCode;

  _Bus({
    required this.route,
    required this.seatsAvailable,
    required this.qrCode,
  });
}