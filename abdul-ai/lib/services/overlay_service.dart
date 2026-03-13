import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class OverlayService {
  static bool _isOverlayActive = false;

  static Future<void> showOverlay({
    required String callerId,
    required String callerInfo,
  }) async {
    if (_isOverlayActive) {
      await hideOverlay();
    }

    await FlutterOverlayWindow.showOverlay(
      height: 200,
      width: WindowSize.matchParent,
      alignment: OverlayAlignment.topCenter,
      enableDrag: true,
    );

    _isOverlayActive = true;

    await FlutterOverlayWindow.shareData({
      'callerId': callerId,
      'callerInfo': callerInfo,
    });
  }

  static Future<void> hideOverlay() async {
    if (_isOverlayActive) {
      await FlutterOverlayWindow.closeOverlay();
      _isOverlayActive = false;
    }
  }

  static Widget buildOverlayContent({
    required String callerId,
    required String callerInfo,
  }) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Incoming Call',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              callerId,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              callerInfo,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
