import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../services/api_service.dart';

class JoinGamePage extends StatefulWidget {
  const JoinGamePage({super.key});

  @override
  State<JoinGamePage> createState() => _JoinGamePageState();
}

class _JoinGamePageState extends State<JoinGamePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _gameCodeController = TextEditingController();
  final MobileScannerController _scannerController = MobileScannerController();
  bool _isScanning = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _gameCodeController.dispose();
    _scannerController.dispose();
    super.dispose();
  }

  void _joinGame(String username, String gameCode) async {
    if (gameCode.trim().isEmpty || username.trim().isEmpty) {
      if (username.trim().isEmpty) {
        _showErrorSnackBar('Please enter a username');
      } else if (gameCode.trim().isEmpty) {
        _showErrorSnackBar('Please enter a valid game code');
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final apiService = ApiService();
    final error = await apiService.joinGame(username, gameCode);

    if (error != null) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar(error);
      return;
    }

    // If joinGame was successful, fetch question from /api/Games/session
    final sessionId = apiService.joinedParticipant?['sessionId'];
    if (sessionId != null) {
      final questionData = await apiService.getSessionQuestion(sessionId);

      setState(() {
        _isLoading = false;
      });

      if (questionData != null) {
        Navigator.pushReplacementNamed(
          context,
          '/game_question',
          arguments: questionData,
        );
      } else {
        _showErrorSnackBar('Unauthorized or failed to fetch question.');
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Failed to get session ID.');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _toggleScanner() {
    setState(() {
      _isScanning = !_isScanning;
    });
  }

  void _onQRCodeDetected(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;

    if (barcodes.isNotEmpty) {
      final String? code = barcodes.first.rawValue;

      if (code != null && code.isNotEmpty) {
        // Stop scanning and close scanner
        setState(() {
          _isScanning = false;
        });

        HapticFeedback.mediumImpact();

        final Uri uri = Uri.parse(code);
        final String? sessionId =
            uri.pathSegments.isNotEmpty ? uri.pathSegments.last : null;

        if (sessionId != null && sessionId.isNotEmpty) {
          _gameCodeController.text = sessionId;
          // _joinGame(sessionId);
        } else {
          print('Invalid QR code format');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFF1E1E2E),
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo/Title
                  Container(
                    margin: const EdgeInsets.only(bottom: 48),
                    child: Column(
                      children: const [
                        // Container(
                        //   width: 80,
                        //   height: 80,
                        //   decoration: BoxDecoration(
                        //     color: const Color(0xFF6C5CE7),
                        //     borderRadius: BorderRadius.circular(20),
                        //     boxShadow: [
                        //       BoxShadow(
                        //         color: const Color(0xFF6C5CE7).withOpacity(0.3),
                        //         blurRadius: 20,
                        //         offset: const Offset(0, 8),
                        //       ),
                        //     ],
                        //   ),
                        //   child: const Icon(
                        //     Icons.quiz,
                        //     color: Colors.white,
                        //     size: 40,
                        //   ),
                        // ),
                        SizedBox(height: 16),
                        Text(
                          'Pop Quiz',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            // color: Colors.white,
                          ),
                        ),
                        Text(
                          'Join a game to get started',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF8E8E93),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Game Code Input
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name Code Field
                        const Text(
                          'Your Username',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            // color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _nameController,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            // color: Colors.white,
                            letterSpacing: 2,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter username',
                            hintStyle: const TextStyle(
                              color: Color(0xFF8E8E93),
                              fontWeight: FontWeight.normal,
                              letterSpacing: 0,
                            ),
                            filled: true,
                            // fillColor: const Color(0xFF2A2A3A),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Color(0xFF6C5CE7),
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
                          // textCapitalization: TextCapitalization.characters,
                          // inputFormatters: [
                          //   UpperCaseTextFormatter(),
                          // ],
                        ),
                        const SizedBox(height: 8),

                        // Game Code Field
                        const Text(
                          'Game Code',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            // color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _gameCodeController,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            // color: Colors.white,
                            letterSpacing: 2,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter game code',
                            hintStyle: const TextStyle(
                              color: Color(0xFF8E8E93),
                              fontWeight: FontWeight.normal,
                              letterSpacing: 0,
                            ),
                            filled: true,
                            // fillColor: const Color(0xFF2A2A3A),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Color(0xFF6C5CE7),
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
                          // textCapitalization: TextCapitalization.characters,
                          // inputFormatters: [
                          //   UpperCaseTextFormatter(),
                          // ],
                        ),
                      ],
                    ),
                  ),

                  // Join Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () => _joinGame(
                              _nameController.text, _gameCodeController.text),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C5CE7),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        disabledBackgroundColor: const Color(0xFF4A4A5A),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text(
                              'Join Game',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),

                  // Divider
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 32),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            color: const Color(0xFF4A4A5A),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'OR',
                            style: TextStyle(
                              color: Color(0xFF8E8E93),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: const Color(0xFF4A4A5A),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // QR Code Scanner Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton.icon(
                      onPressed: _toggleScanner,
                      icon: const Icon(Icons.qr_code_scanner),
                      label: const Text(
                        'Scan QR Code',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF6C5CE7),
                        side: const BorderSide(
                          color: Color(0xFF6C5CE7),
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // QR Scanner Overlay
            if (_isScanning)
              Container(
                color: Colors.black,
                child: Column(
                  children: [
                    // Scanner Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: _toggleScanner,
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const Expanded(
                            child: Text(
                              'Scan QR Code',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 44), // Balance the close button
                        ],
                      ),
                    ),

                    // Scanner View
                    Expanded(
                      child: Stack(
                        children: [
                          MobileScanner(
                            controller: _scannerController,
                            onDetect: _onQRCodeDetected,
                          ),

                          // Scanner overlay with rounded corners
                          Center(
                            child: Container(
                              width: 250,
                              height: 250,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFF6C5CE7),
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Scanner Instructions
                    Container(
                      padding: const EdgeInsets.all(24),
                      child: const Text(
                        'Position the QR code within the frame to scan',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Custom formatter to convert input to uppercase
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
