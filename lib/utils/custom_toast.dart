import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void successToast(context, String text) {
  toastification.show(
    context: context,
    title: Text(text),
    style: ToastificationStyle.fillColored,
    type: ToastificationType.success,
    autoCloseDuration: Duration(seconds: 3),
  );
}

void errorToast(context, String text) {
  toastification.show(
    context: context,
    title: Text(text),
    style: ToastificationStyle.fillColored,
    type: ToastificationType.error,
    autoCloseDuration: const Duration(seconds: 3),
  );
}

void infoToast(context, String text) {
  toastification.show(
    context: context,
    title: Text(text),
    style: ToastificationStyle.fillColored,
    type: ToastificationType.info,
    autoCloseDuration: const Duration(seconds: 3),
  );
}

void warningToast(context, String text) {
  toastification.show(
    context: context,
    title: Text(text),
    style: ToastificationStyle.fillColored,
    type: ToastificationType.warning,
    autoCloseDuration: const Duration(seconds: 3),
  );
}
