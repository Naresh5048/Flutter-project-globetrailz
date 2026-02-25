import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../app_state.dart';
import '../utils/gradient_utils.dart';
import '../utils/localization.dart';

class CountryDetailPage extends StatelessWidget {
  final String countryName;
  final List<Map<String, dynamic>> spots;

  const CountryDetailPage({super.key, required this.countryName, required this.spots});

  Future<void> _openUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Could not launch $url');
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }

  // FIX: Corrected URL logic and dynamically typed arguments
  Future<void> _openRoute(dynamic lat, dynamic lng) async {
    final latValue = lat as double;
    final lngValue = lng as double;
    
    // Try Google Maps URL first (works on all platforms)
    final googleMapsUrl = 'https://www.google.com/maps?q=$latValue,$lngValue';
    
    try {
      await launchUrl(Uri.parse(googleMapsUrl), mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Could not launch Google Maps: $e');
      // Fallback to geo URI
      try {
        final geoUrl = 'geo:$latValue,$lngValue?q=$latValue,$lngValue';
        await _openUrl(geoUrl);
      } catch (e2) {
        debugPrint('Could not launch route: $e2');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    final l = L(app.language);
    return Scaffold(
      appBar: AppBar(
        title: Text(countryName),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: [
                Color(0xFFFCF9EA),
                Color(0xFFBADFDB),
              ],
              stops: [0.0, 1.0],
            ),
          ),
        ),
      ),
      body: GradientUtils.gradientBackground(
        child: ListView.separated(
        padding: EdgeInsets.all(12),
        itemBuilder: (ctx, i) {
          final s = spots[i];
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(children: [
                // Left image placeholder
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(s['image'] ?? 'assets/logo.png.png', width: 110, height: 80, fit: BoxFit.cover, errorBuilder: (_,__,___)=> Container(width:110,height:80,color:Colors.grey.shade200,child: Icon(Icons.photo))),
                ),
                SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(s['name'] ?? '', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(s['place'] ?? '', style: TextStyle(color: Colors.grey.shade600)),
                ])),
                Column(children: [
                  // Disabled button if wiki is missing
                  ElevatedButton(onPressed: s['wiki'] != null ? () => _openUrl(s['wiki']) : null, child: Text(l.t('more'))),
                  SizedBox(height: 8),
                  // Disabled button if coordinates are missing
                  OutlinedButton(onPressed: s['lat'] != null && s['lng'] != null ? () => _openRoute(s['lat'], s['lng']) : null, child: Text(l.t('route'))),
                ])
              ]),
            ),
          );
        },
        separatorBuilder: (_, __) => SizedBox(height: 10),
        itemCount: spots.length,
      ),
      ),
    );
  }
}