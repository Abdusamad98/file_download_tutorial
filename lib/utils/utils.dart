import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showLoader(BuildContext context) {
  showDialog(
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      context: context,
      builder: (_) {
        return const AlertDialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: Center(child: CircularProgressIndicator()),
        );
      });
}

void hideLoader(BuildContext? context) {
  if (context != null) {
    Navigator.pop(context);
  }
}
