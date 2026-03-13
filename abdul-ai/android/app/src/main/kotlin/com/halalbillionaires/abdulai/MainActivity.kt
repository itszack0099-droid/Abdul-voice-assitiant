package com.halalbillionaires.abdulai

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.provider.ContactsContract
import android.database.Cursor

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.halalbillionaires.abdulai/phone"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "getContactName") {
                val phoneNumber = call.argument<String>("phoneNumber")
                if (phoneNumber != null) {
                    val contactName = getContactName(phoneNumber)
                    result.success(contactName)
                } else {
                    result.error("INVALID_ARGUMENT", "Phone number is required", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getContactName(phoneNumber: String): String? {
        val uri = ContactsContract.PhoneLookup.CONTENT_FILTER_URI.buildUpon()
            .appendPath(phoneNumber)
            .build()

        val projection = arrayOf(ContactsContract.PhoneLookup.DISPLAY_NAME)
        var cursor: Cursor? = null
        var contactName: String? = null

        try {
            cursor = contentResolver.query(uri, projection, null, null, null)
            if (cursor != null && cursor.moveToFirst()) {
                contactName = cursor.getString(0)
            }
        } catch (e: Exception) {
            e.printStackTrace()
        } finally {
            cursor?.close()
        }

        return contactName
    }
}
