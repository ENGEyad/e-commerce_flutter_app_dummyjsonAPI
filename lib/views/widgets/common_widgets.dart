import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black45,
            child: const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          ),
      ],
    );
  }
}

class ErrorSnackbarListener extends StatelessWidget {
  final String? errorMessage;
  final VoidCallback onClearError;
  final Widget child;

  const ErrorSnackbarListener({
    super.key,
    required this.errorMessage,
    required this.onClearError,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage!),
            backgroundColor: Theme.of(context).colorScheme.error,
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: onClearError,
            ),
          ),
        );
        onClearError();
      });
    }
    return child;
  }
}

class CurrencyFormatter {
  static String format(double value) {
    return '\$${value.toStringAsFixed(2)}';
  }
}