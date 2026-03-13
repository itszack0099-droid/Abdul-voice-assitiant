import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_phone_state/flutter_phone_state.dart';
import 'overlay_service.dart';
import 'groq_service.dart';

class PhoneService {
  static const platform = MethodChannel('com.halalbillionaires.abdulai/phone');
  static StreamSubscription<PhoneState>? _phoneStateSubscription;
  static final GroqService _groqService = GroqService();
  static String? _currentCallerId;

  static void initialize(ServiceInstance service) {
    _phoneStateSubscription = FlutterPhoneState.phoneStateStream.listen((PhoneState state) {
      _handlePhoneState(state);
    });
  }

  static Future<void> _handlePhoneState(PhoneState state) async {
    if (state.status == PhoneStateStatus.CALL_INCOMING) {
      _currentCallerId = state.number;
      if (_currentCallerId != null) {
        await _fetchCallerInfo(_currentCallerId!);
      }
    } else if (state.status == PhoneStateStatus.CALL_ENDED) {
      await OverlayService.hideOverlay();
      _currentCallerId = null;
    }
  }

  static Future<void> _fetchCallerInfo(String phoneNumber) async {
    try {
      final prompt = 'Based on the phone number $phoneNumber, provide brief caller information if it\'s a known spam/scam number or business. Keep response under 50 words.';

      final response = await _groqService.getResponse(prompt);

      await OverlayService.showOverlay(
        callerId: phoneNumber,
        callerInfo: response,
      );
    } catch (e) {
      await OverlayService.showOverlay(
        callerId: phoneNumber,
        callerInfo: 'Unknown caller',
      );
    }
  }

  static Future<String?> getContactName(String phoneNumber) async {
    try {
      final String? name = await platform.invokeMethod('getContactName', {'phoneNumber': phoneNumber});
      return name;
    } catch (e) {
      return null;
    }
  }

  static void dispose() {
    _phoneStateSubscription?.cancel();
  }
}
