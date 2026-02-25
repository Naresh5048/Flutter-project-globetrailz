import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../utils/gradient_utils.dart';
import '../utils/localization.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    final user = app.loggedIn;
    final primaryColor = Theme.of(context).primaryColor;
    final l = L(app.language);

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l.t('profile'))), 
        body: GradientUtils.gradientBackground(child: Center(child: Text(l.t('noUserLoggedIn')))));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l.t('profileView')),
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
        child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                GestureDetector(
                  onTap: () {
                    // TODO: implement image picker using image_picker package.
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Add image picker (image_picker) integration')));
                  },
                  child: CircleAvatar(
                    radius: 42,
                    backgroundColor: primaryColor.withValues(alpha: 0.2),
                    child: user.avatarPath == null ? Text(user.username.isNotEmpty ? user.username[0].toUpperCase() : 'U', style: TextStyle(fontSize: 28, color: primaryColor)) : null,
                    // if avatarPath present, use FileImage(File(user.avatarPath)) (requires permission)
                  ),
                ),
                SizedBox(width: 12),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(user.username, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor)),
                  SizedBox(height: 6),
                  Text(user.email),
                ]),
              ]),
              SizedBox(height: 12),
              Expanded( // Wrap DataTable in Expanded for better layout
                  child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(columns: [
                    DataColumn(label: Text(l.t('field'), style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text(l.t('value'), style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text(l.t('action'), style: TextStyle(fontWeight: FontWeight.bold))),
                  ], rows: [
                    DataRow(cells: [
                      DataCell(Text(l.t('username'))),
                      DataCell(Text(user.username)),
                      DataCell(Text('')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text(l.t('email'))),
                      DataCell(Text(user.email)),
                      DataCell(Text('')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text(l.t('password'))),
                      DataCell(Text('*' * (user.password.length > 1 ? user.password.length : 1))),
                      DataCell(
                        IconButton(
                          icon: Icon(Icons.edit, color: primaryColor),
                          onPressed: () => _showEditPasswordDialog(context),
                        ),
                      ),
                    ]),
                  ]),
                ),
              ),
            ]),
          ),
        ),
      ),
      ),
    );
  }

  void _showEditPasswordDialog(BuildContext context) {
    final app = Provider.of<AppState>(context, listen: false);
    final primaryColor = Theme.of(context).primaryColor;
    final l = L(app.language);
    final a = TextEditingController();
    final b = TextEditingController();
    bool o1 = true, o2 = true;
    showDialog(context: context, builder: (ctx){
      return StatefulBuilder(builder: (ctx2, setState2){
        return AlertDialog(
          title: Text(l.t('editPassword')),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: a, obscureText: o1, decoration: InputDecoration(labelText: l.t('newPassword'), suffixIcon: IconButton(icon: Icon(o1?Icons.visibility_off:Icons.visibility), onPressed: ()=>setState2(()=>o1=!o1)))),
            SizedBox(height:8),
            TextField(controller: b, obscureText: o2, decoration: InputDecoration(labelText: l.t('confirmPassword'), suffixIcon: IconButton(icon: Icon(o2?Icons.visibility_off:Icons.visibility), onPressed: ()=>setState2(()=>o2=!o2)))),
          ]),
          actions: [
            TextButton(onPressed: ()=>Navigator.pop(ctx), child: Text(l.t('cancel'), style: TextStyle(color: primaryColor))),
            ElevatedButton(onPressed: (){
              if (a.text.isEmpty || b.text.isEmpty) return;
              if (a.text != b.text) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.t('passwordsDontMatch'))));
                return;
              }
              app.updatePassword(a.text);
              Navigator.pop(ctx);
            }, style: ElevatedButton.styleFrom(backgroundColor: primaryColor), child: Text(l.t('save'))),
          ],
        );
      });
    });
  }
}