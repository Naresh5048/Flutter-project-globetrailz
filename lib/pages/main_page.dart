import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../app_state.dart';
import '../utils/localization.dart';
import '../widgets/search_bar_widget.dart';
import 'country_list_page.dart';
import 'profile_page.dart'; // Import ProfilePage for the menu

class MainPage extends StatefulWidget {
  final VoidCallback onLogout;
  const MainPage({super.key, required this.onLogout});
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  VideoPlayerController? _vc;
  bool vcReady = false;
  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    try {
      final v = VideoPlayerController.asset('assets/bg.mp4.mp4');
      await v.initialize();
      v.setLooping(true);
      v.setVolume(0);
      v.play();
      setState(() {
        _vc = v;
        vcReady = true;
      });
    } catch (e) {
      vcReady = false;
      // Added print for debugging video loading errors
      debugPrint("Error initializing video: $e");
    }
  }

  @override
  void dispose() {
    _vc?.dispose();
    super.dispose();
  }

  void _onSearch(String q) {
    // Add search query to trending list
    Provider.of<AppState>(context, listen: false).addSearch(q);
    
    // Navigate to search results page
    final app = Provider.of<AppState>(context, listen: false);
    final l = L(app.language);
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => Scaffold(
      appBar: AppBar(
        title: Text('${l.t('searchTitle')}$q'),
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
      body: CountryListPage(query: q),
    )));
  }

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    final l = L(app.language);
    
    return Scaffold(
      extendBodyBehindAppBar: true, // Crucial for transparent AppBar
      appBar: AppBar(
        // Apply gradient background to app bar
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: [
                Color(0xFFFCF9EA), // Top color
                Color(0xFFBADFDB), // Medium top color
              ],
              stops: [0.0, 1.0],
            ),
          ),
        ),
        elevation: 0, 
        title: Row(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset('assets/logo.png.png', height: 34, width: 34, fit: BoxFit.cover, errorBuilder: (_,__,___)=> FlutterLogo(size: 34)),
          ),
          SizedBox(width: 8),
          Text(l.t('appTitle'), style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
          SizedBox(width: 16),
          // SearchBar is now aligned with the app bar, which looks sleek
          Expanded(child: SearchBarWidget(onSearch: _onSearch)),
        ]),
        actions: [
          // NEW MENU BAR - Language, Theme, Profile
          PopupMenuButton<String>(
            icon: Icon(Icons.menu, color: Colors.black87),
            onSelected: (value) {
              if (value == 'logout') {
                widget.onLogout();
              } else if (value == 'profile') {
                // Navigate to Profile Page
                Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage()));
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              // Profile
              PopupMenuItem<String>(
                value: 'profile',
                child: ListTile(leading: Icon(Icons.person), title: Text(l.t('profile'))),
              ),
              const PopupMenuDivider(),
              // Theme Toggle
              PopupMenuItem<String>(
                child: Row(children: [
                  Icon(Icons.color_lens),
                  SizedBox(width: 10),
                  Text('${l.t('themeLabel')}${app.isDark ? l.t('dark') : l.t('light')}'),
                  Spacer(),
                  Switch(value: app.isDark, onChanged: app.setTheme),
                ]),
              ),
              const PopupMenuDivider(),
              // Language Selection
              PopupMenuItem<String>(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<AppLanguage>(
                    value: app.language,
                    items: [
                      DropdownMenuItem<AppLanguage>(value: AppLanguage.english, child: Text(l.t('english'))),
                      DropdownMenuItem<AppLanguage>(value: AppLanguage.hindi, child: Text(l.t('hindi'))),
                      DropdownMenuItem<AppLanguage>(value: AppLanguage.telugu, child: Text(l.t('telugu'))),
                    ],
                    onChanged: (v){ if (v!=null) app.setLanguage(v); },
                  ),
                ),
              ),
              const PopupMenuDivider(),
              // Logout
              PopupMenuItem<String>(
                value: 'logout',
                child: ListTile(leading: Icon(Icons.logout, color: Colors.red), title: Text(l.t('logout'))),
              ),
            ],
          ),
        ],
      ),
      body: Stack(children: [
        // Full background video (Ensures video fills the screen under the transparent app bar)
        Positioned.fill(
          child: vcReady && _vc != null
              ? Stack(children: [
                  Positioned.fill(
                    child: FittedBox(
                      fit: BoxFit.cover, 
                      child: SizedBox(
                        width: _vc!.value.size.width, 
                        height: _vc!.value.size.height, 
                        child: VideoPlayer(_vc!)
                      )
                    )
                  ),
                  // Added a denser overlay for better readability on top of the video
                  Positioned.fill(child: Container(color: Colors.black.withValues(alpha: 0.40))) 
                ])
              : Container(color: Colors.grey.shade400),
        ),
        
        // Foreground content - starting below the App Bar area
        SafeArea(
          child: Expanded(child: CountryListPage()),
        ),
      ]),
      // GRADIENT BOTTOM NAVIGATION BAR
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFA4A4), // Medium bottom color
              Color(0xFFFFBDBD), // Bottom color
            ],
            stops: [0.0, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _BottomBarButton(
              icon: Icons.home, 
              label: l.t('home'), 
              onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
            ),
            _BottomBarButton(
              icon: Icons.trending_up, 
              label: l.t('trending'), 
              onPressed: () {
                final searches = app.searches;
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (_) => Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFFCF9EA),
                          Color(0xFFBADFDB),
                          Color(0xFFFFA4A4),
                          Color(0xFFFFBDBD),
                        ],
                        stops: [0.0, 0.33, 0.66, 1.0],
                      ),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(l.t('trendingSearches'), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: app.isDark ? Colors.white : Colors.black87)),
                        ),
                        ...searches.map((s)=>ListTile(title: Text('#$s', style: TextStyle(color: app.isDark ? Colors.white : Colors.black87)))),
                      ],
                    ),
                  ),
                );
              },
            ),
            _BottomBarButton(
              icon: Icons.arrow_back, 
              label: l.t('back'), 
              onPressed: () {
                if (Navigator.of(context).canPop()) Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Custom widget for the streamlined bottom bar buttons
class _BottomBarButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _BottomBarButton({required this.icon, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87;
    return Expanded(
      child: InkWell(
        onTap: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor),
            Text(label, style: TextStyle(color: textColor, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}


class _HoverInfoTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _HoverInfoTile({required this.icon, required this.title, required this.subtitle});

  @override
  State<_HoverInfoTile> createState() => _HoverInfoTileState();
}

class _HoverInfoTileState extends State<_HoverInfoTile> {
  bool hovering = false;
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return MouseRegion(
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() => hovering = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 180),
        curve: Curves.easeOut,
        height: 64,
        decoration: BoxDecoration(
          color: (hovering ? Colors.white : Colors.white.withValues(alpha: 0.9)),
          borderRadius: BorderRadius.circular(12),
          boxShadow: hovering ? [BoxShadow(color: primaryColor.withValues(alpha: 0.3), blurRadius: 12, offset: Offset(0,6))] : [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: Offset(0,4))],
        ),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(widget.icon, color: primaryColor),
          ),
          SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(widget.title, style: TextStyle(fontWeight: FontWeight.w600)),
            SizedBox(height: 2),
                      Text(widget.subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
          ])),
        ]),
      ),
    );
  }
}