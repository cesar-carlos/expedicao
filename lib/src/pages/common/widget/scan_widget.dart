import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';

class ScanWidget extends StatelessWidget {
  final bool viewMode;

  final FocusNode scanFocusNode;
  final TextEditingController scanController;
  final Function(String value) onSubmittedScan;

  const ScanWidget({
    super.key,
    required this.viewMode,
    required this.scanController,
    required this.scanFocusNode,
    required this.onSubmittedScan,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorHeight: 22,
      enabled: viewMode,
      controller: scanController,
      focusNode: scanFocusNode,
      onSubmitted: onSubmittedScan,
      textAlign: TextAlign.start,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(left: 10, right: 10),
        prefixIcon: const Icon(
          size: 20,
          BootstrapIcons.upc,
          color: Colors.black87,
        ),
        suffix: Container(
          padding: const EdgeInsets.all(5),
          child: const Icon(
            size: 15,
            BootstrapIcons.search,
            color: Colors.black87,
          ),
        ),
        border: const OutlineInputBorder(),
        labelText: 'Leitor código de barras',
        labelStyle: const TextStyle(
          fontSize: 12,
          color: Colors.black87,
        ),
      ),
    );
  }
}
