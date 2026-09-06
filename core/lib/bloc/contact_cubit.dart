import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

abstract class ContactState {}

class ContactInitial extends ContactState {}

class ContactSubmitting extends ContactState {}

class ContactSuccess extends ContactState {}

class ContactFailure extends ContactState {
  final String message;

  ContactFailure(this.message);
}

/// Handles the enquiry/contact form submission by posting it to a Google
/// Apps Script web app, which saves the enquiry to a Google Sheet and emails
/// a notification (see google_apps_script/Code.gs at the repo root).
class ContactCubit extends Cubit<ContactState> {
  ContactCubit() : super(ContactInitial());

  Future<void> submitEnquiry({
    required String endpoint,
    required String toEmail,
    required String subject,
    required String name,
    required String email,
    required String phone,
    required String message,
  }) async {
    emit(ContactSubmitting());

    try {
      final response = await http.post(
        Uri.parse(endpoint),
        // text/plain avoids a CORS preflight that Apps Script web apps don't
        // handle; the body is still JSON and is parsed as such server-side.
        headers: {'Content-Type': 'text/plain;charset=utf-8'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'phone': phone,
          'message': message,
          'subject': subject,
        }),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        if (decoded['status'] == 'success') {
          emit(ContactSuccess());
        } else {
          emit(ContactFailure(
            (decoded['message'] as String?) ?? 'Something went wrong. Please try again.',
          ));
        }
      } else {
        emit(ContactFailure('Something went wrong. Please try again or email us at $toEmail.'));
      }
    } catch (e) {
      emit(ContactFailure('Could not send your enquiry. Please try again or email us directly at $toEmail.'));
    }
  }

  void reset() => emit(ContactInitial());
}
