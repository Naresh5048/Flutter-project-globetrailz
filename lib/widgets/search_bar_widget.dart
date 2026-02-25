import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../utils/localization.dart';
import '../services/country_service.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(String) onSearch;
  const SearchBarWidget({super.key, required this.onSearch});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final _controller = TextEditingController();
  List<String> suggestions = [];
  OverlayEntry? overlay;

  @override
  void dispose() {
    _controller.dispose();
    hideOverlay();
    super.dispose();
  }

  void showSuggestions(BuildContext context, List<String> data) {
    hideOverlay();
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);
    final overlayState = Overlay.of(context);
    
    // Calculate position based on the search bar's position
    overlay = OverlayEntry(
      builder: (ctx) => Positioned(
        left: position.dx,
        top: position.dy + size.height + 8, // Below the search bar
        width: size.width,
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(8),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 240),
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: data.map((s) {
                return ListTile(
                  title: Text(s),
                  onTap: () {
                    _controller.text = s;
                    widget.onSearch(s);
                    Provider.of<AppState>(context, listen: false).addSearch(s);
                    hideOverlay();
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
    overlayState.insert(overlay!);
  }

  void hideOverlay() {
    overlay?.remove();
    overlay = null;
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final l = L(appState.language);
    final placeholder = l.t('searchPlaceholder');

    return SizedBox(
      height: 44,
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: placeholder,
          filled: true,
          // Use the card color for visibility over the transparent app bar/video
          fillColor: Theme.of(context).cardColor.withValues(alpha: 0.9), 
          prefixIcon: Icon(Icons.search),
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
        ),
        onChanged: (v) {
          // Show country suggestions instead of search history
          final countries = CountryService.searchCountries(v);
          if (v.isNotEmpty && countries.isNotEmpty) {
            showSuggestions(context, countries);
          } else {
            hideOverlay();
          }
        },
        onSubmitted: (v) {
          if (v.trim().isEmpty) return;
          widget.onSearch(v.trim());
          appState.addSearch(v.trim());
          hideOverlay();
        },
        // Added on tap to dismiss overlay on tap outside (simple fix for mobile/web)
        onTap: () {
          // Check for existing text to show suggestions on tap if needed
          final list = appState.searches.where((s) => s.toLowerCase().contains(_controller.text.toLowerCase())).toList();
          if (_controller.text.isNotEmpty && list.isNotEmpty && overlay == null) {
            showSuggestions(context, list);
          }
        },
      ),
    );
  }
}