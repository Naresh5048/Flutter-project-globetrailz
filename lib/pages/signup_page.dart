import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../app_state.dart';
import '../utils/gradient_utils.dart';
import '../utils/localization.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _form = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _confirm = TextEditingController();
  bool _o1 = true, _o2 = true;
  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _pass.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    final primaryColor = Theme.of(context).primaryColor;
    final l = L(app.language);

    return Scaffold(
      body: GradientUtils.gradientBackground(
        child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 22),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/logo.png.png', height: 90, errorBuilder: (_,__,___)=> FlutterLogo(size: 80)),
                    SizedBox(height: 8),
                    Text(l.t('signup'), style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryColor)),
                    SizedBox(height: 14),
                    Form(
                      key: _form,
                      child: Column(
                        children: [
                          TextFormField(controller: _username, decoration: InputDecoration(labelText: l.t('username'), border: OutlineInputBorder()),
                            validator: (v)=> (v==null||v.trim().isEmpty) ? l.t('requiredField') : null),
                          SizedBox(height: 12),
                          TextFormField(controller: _email, decoration: InputDecoration(labelText: l.t('email'), border: OutlineInputBorder()),
                            validator: (v)=> (v==null||v.trim().isEmpty) ? l.t('requiredField') : null),
                          SizedBox(height: 12),
                          TextFormField(controller: _pass, obscureText: _o1, decoration: InputDecoration(labelText: l.t('password'),
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(icon: Icon(_o1?Icons.visibility_off:Icons.visibility), onPressed: ()=>setState(()=>_o1=!_o1))),
                            validator: (v)=> (v==null||v.isEmpty) ? l.t('requiredField') : null),
                          SizedBox(height: 12),
                          TextFormField(controller: _confirm, obscureText: _o2, decoration: InputDecoration(labelText: l.t('confirmPassword'),
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(icon: Icon(_o2?Icons.visibility_off:Icons.visibility), onPressed: ()=>setState(()=>_o2=!_o2))),
                            validator: (v){
                              if (v==null || v.isEmpty) return l.t('requiredField');
                              if (v != _pass.text) return l.t('passwordsDontMatch');
                              return null;
                            }),
                          SizedBox(height: 16),
                          ElevatedButton(onPressed: () async {
                            if (!_form.currentState!.validate()) return;
                            final newUser = AppUser(username: _username.text.trim(), email: _email.text.trim(), password: _pass.text);
                            await app.register(newUser);
                            // After signup go back to login
                            if (context.mounted) {
                              Navigator.of(context).pop();
                            }
                          }, 
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor, // Use new primary color
                              foregroundColor: Colors.white,
                            ),
                            child: Padding(padding:EdgeInsets.symmetric(vertical:12), child: Text(l.t('signupButton'))),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      ),
    );
  }
}