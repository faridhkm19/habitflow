import 'package:flutter/material.dart';
import 'mobile_scaffold.dart';
import 'web_scaffold.dart';

class AdaptiveScaffold extends StatelessWidget {
  final Widget child;

  const AdaptiveScaffold({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Gunakan LayoutBuilder sebagai alternatif MediaQuery.of(context).size.width
    // agar merespons secara real-time terhadap constraints dari parent jika diperlukan.
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return MobileScaffold(child: child);
        } else {
          return WebScaffold(child: child);
        }
      },
    );
  }
}
