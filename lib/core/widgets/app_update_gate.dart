import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shorebird_code_push/shorebird_code_push.dart';
import '../theme.dart';

class AppUpdateGate extends StatefulWidget {
  final Widget child;

  const AppUpdateGate({super.key, required this.child});

  @override
  State<AppUpdateGate> createState() => _AppUpdateGateState();
}

enum UpdateGateStatus {
  checkingConnection,
  noInternet,
  checkingUpdate,
  downloadingUpdate,
  updateComplete,
  ready,
}

class _AppUpdateGateState extends State<AppUpdateGate> {
  final _shorebirdUpdater = ShorebirdUpdater();
  UpdateGateStatus _status = UpdateGateStatus.checkingConnection;
  Timer? _autoReconnectTimer;
  bool _isRetrying = false;
  String _statusMessage = 'Checking internet connection...';

  @override
  void initState() {
    super.initState();
    _startFlow();
  }

  @override
  void dispose() {
    _autoReconnectTimer?.cancel();
    super.dispose();
  }

  /// Start the check flow: Internet Check -> Shorebird Update Check -> Ready
  Future<void> _startFlow() async {
    // On Web, immediately proceed to app so it uses the native web loading screen
    if (kIsWeb) {
      if (mounted) {
        setState(() {
          _status = UpdateGateStatus.ready;
        });
      }
      return;
    }

    setState(() {
      _status = UpdateGateStatus.checkingConnection;
      _statusMessage = 'Checking internet connection...';
    });

    final hasInternet = await _checkInternetConnection();
    if (!hasInternet) {
      setState(() {
        _status = UpdateGateStatus.noInternet;
        _isRetrying = false;
      });
      _startAutoReconnectTimer();
      return;
    }

    _autoReconnectTimer?.cancel();
    await _checkAndApplyShorebirdUpdate();
  }

  /// Checks whether the device is currently connected to the internet.
  Future<bool> _checkInternetConnection() async {
    try {
      if (kIsWeb) {
        final response = await http
            .get(Uri.parse('https://api.github.com'))
            .timeout(const Duration(seconds: 4));
        return response.statusCode == 200 || response.statusCode == 204;
      } else {
        // Fast DNS lookup
        try {
          final result = await InternetAddress.lookup('google.com')
              .timeout(const Duration(seconds: 3));
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            return true;
          }
        } catch (_) {}

        // Fallback HTTP check to Google captive portal
        final response = await http
            .get(Uri.parse('https://clients3.google.com/generate_204'))
            .timeout(const Duration(seconds: 4));
        return response.statusCode == 204 || response.statusCode == 200;
      }
    } catch (_) {
      return false;
    }
  }

  /// Automatically polls every 3 seconds when offline to detect network connection
  void _startAutoReconnectTimer() {
    _autoReconnectTimer?.cancel();
    _autoReconnectTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      if (_status != UpdateGateStatus.noInternet || _isRetrying) return;
      final connected = await _checkInternetConnection();
      if (connected) {
        timer.cancel();
        _startFlow();
      }
    });
  }

  /// Checks Shorebird server for updates and downloads if available
  Future<void> _checkAndApplyShorebirdUpdate() async {
    setState(() {
      _status = UpdateGateStatus.checkingUpdate;
      _statusMessage = 'Checking for application updates...';
    });

    try {
      // Check if Shorebird code push is active on this device/build
      if (_shorebirdUpdater.isAvailable) {
        final updateStatus = await _shorebirdUpdater.checkForUpdate();

        if (updateStatus == UpdateStatus.outdated) {
          setState(() {
            _status = UpdateGateStatus.downloadingUpdate;
            _statusMessage = 'Downloading latest performance & UI patch...';
          });

          await _shorebirdUpdater.update();

          setState(() {
            _status = UpdateGateStatus.updateComplete;
            _statusMessage = 'Update installed successfully!';
          });

          // Small delay so user sees update success before entering app
          await Future.delayed(const Duration(milliseconds: 1200));
        }
      }
    } catch (e) {
      debugPrint('Shorebird update check failed: $e');
    }

    // Proceeds to main app
    if (mounted) {
      setState(() {
        _status = UpdateGateStatus.ready;
      });
    }
  }

  /// Manual Retry button handler
  Future<void> _handleManualRetry() async {
    if (_isRetrying) return;
    setState(() {
      _isRetrying = true;
    });
    await _startFlow();
  }

  @override
  Widget build(BuildContext context) {
    if (_status == UpdateGateStatus.ready) {
      return widget.child;
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _buildBodyContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildBodyContent() {
    switch (_status) {
      case UpdateGateStatus.noInternet:
        return _buildNoInternetWidget();
      case UpdateGateStatus.downloadingUpdate:
        return _buildStatusCard(
          icon: Icons.system_update_rounded,
          title: 'Updating Application',
          subtitle: _statusMessage,
          showProgress: true,
          accentColor: AppColors.accentPurple,
        );
      case UpdateGateStatus.updateComplete:
        return _buildStatusCard(
          icon: Icons.check_circle_rounded,
          title: 'Update Complete',
          subtitle: _statusMessage,
          showProgress: false,
          accentColor: const Color(0xFF00E676),
        );
      case UpdateGateStatus.checkingConnection:
      case UpdateGateStatus.checkingUpdate:
      default:
        return _buildStatusCard(
          icon: Icons.cloud_sync_rounded,
          title: 'Initializing App',
          subtitle: _statusMessage,
          showProgress: true,
          accentColor: AppColors.accentCyan,
        );
    }
  }

  Widget _buildNoInternetWidget() {
    return ConstrainedBox(
      key: const ValueKey('no_internet'),
      constraints: const BoxConstraints(maxWidth: 420),
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.cardColor.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.redAccent.withValues(alpha: 0.4),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.redAccent.withValues(alpha: 0.15),
              blurRadius: 30,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.redAccent.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.wifi_off_rounded,
                size: 48,
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Internet Connection',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Please turn on your Mobile Data or Wi-Fi to check for essential app updates and load portfolio assets.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary.withValues(alpha: 0.9),
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: _isRetrying ? null : _handleManualRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentCyan,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 4,
              ),
              child: _isRetrying
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.black,
                      ),
                    )
                  : const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.refresh_rounded, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Retry Connection',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: AppColors.accentCyan.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Auto-detecting network connection...',
                  style: TextStyle(
                    color: AppColors.textSecondary.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool showProgress,
    required Color accentColor,
  }) {
    return ConstrainedBox(
      key: ValueKey(title),
      constraints: const BoxConstraints(maxWidth: 400),
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.cardColor.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: accentColor.withValues(alpha: 0.4),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: 0.15),
              blurRadius: 30,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 44,
                color: accentColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary.withValues(alpha: 0.9),
                fontSize: 14,
                height: 1.4,
              ),
            ),
            if (showProgress) ...[
              const SizedBox(height: 24),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  backgroundColor: accentColor.withValues(alpha: 0.15),
                  color: accentColor,
                  minHeight: 4,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
