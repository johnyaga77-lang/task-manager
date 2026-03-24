import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

void showTopSnackBar(
  BuildContext context,
  String message, {
  Color? backgroundColor,
}) {
  final overlay = Overlay.of(context);
  final topPadding = MediaQuery.of(context).padding.top;

  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: topPadding + 16,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child:
            Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color:
                        backgroundColor ?? Theme.of(context).colorScheme.error,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: Colors.white),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          message,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                .animate()
                .slideY(
                  begin: -1,
                  end: 0,
                  duration: 400.ms,
                  curve: Curves.easeOutBack,
                )
                .fadeIn(duration: 300.ms),
      ),
    ),
  );

  overlay.insert(overlayEntry);

  Future.delayed(const Duration(seconds: 4), () {
    if (overlayEntry.mounted) {
      overlayEntry.remove();
    }
  });
}
