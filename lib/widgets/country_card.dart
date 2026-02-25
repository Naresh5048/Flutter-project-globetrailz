import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../utils/localization.dart';

class CountryCard extends StatefulWidget {
  final String title;
  final String imagePath; // local asset for placeholder
  final VoidCallback onExplore;

  const CountryCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onExplore,
  });

  @override
  State<CountryCard> createState() => _CountryCardState();
}

class _CountryCardState extends State<CountryCard> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    final l = L(app.language);
    final primaryColor = Theme.of(context).primaryColor;
    final borderRadius = BorderRadius.circular(12);
    final hoverColor = primaryColor.withValues(alpha: 0.05); // Lighter hover shade

    return MouseRegion(
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() => hovering = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 220),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: hovering ? hoverColor : Theme.of(context).cardColor,
          borderRadius: borderRadius,
          boxShadow: hovering ? [
            BoxShadow(color: primaryColor.withValues(alpha: 0.3), blurRadius: 16, offset: Offset(0,6))
          ] : [
            BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: Offset(0,3))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // image area
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: SizedBox(
                height: 120,
                width: double.infinity,
                child: Image.asset(
                  widget.imagePath,
                  fit: BoxFit.cover,
                  // Error builder is fine, but added a background color in dark mode context
                  errorBuilder: (context, error, stackTrace) {
                    debugPrint('Image loading error for ${widget.imagePath}');
                    return SizedBox(
                      height: 120,
                      child: Container(
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade300,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.photo, size: 48, color: primaryColor),
                            Text('Error loading image', style: TextStyle(color: primaryColor.withValues(alpha: 0.8), fontSize: 10)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(widget.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor, // Use new primary color
                      foregroundColor: Colors.white,
                    ),
                    onPressed: widget.onExplore,
                    child: Text(l.t('explore')),
                  ),
                )
              ]),
            )
          ],
        ),
      ),
    );
  }
}