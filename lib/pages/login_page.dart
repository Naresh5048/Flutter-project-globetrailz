import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../utils/gradient_utils.dart';
import '../utils/localization.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback openMainIfLogged;
  const LoginPage({super.key, required this.openMainIfLogged});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _uoe = TextEditingController();
  final _pass = TextEditingController();
  bool obscure = true;
  String? _error;
  
  @override
  void dispose() {
    _uoe.dispose();
    _pass.dispose();
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
          padding: EdgeInsets.symmetric(horizontal: 26),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 520),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 26),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // logo centered (no appbar)
                    SizedBox(
                      height: 92,
                      child: Image.asset('assets/logo.png.png', fit: BoxFit.contain, errorBuilder: (_,__,___) => FlutterLogo(size: 72)),
                    ),
                    SizedBox(height: 12),
                    Text(l.t('appTitle'), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryColor)),
                    SizedBox(height: 18),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _uoe,
                            decoration: InputDecoration(labelText: l.t('usernameOrEmail'), border: OutlineInputBorder()),
                            validator: (v) => (v==null || v.trim().isEmpty) ? l.t('requiredField') : null,
                          ),
                          SizedBox(height: 12),
                          TextFormField(
                            controller: _pass,
                            obscureText: obscure,
                            decoration: InputDecoration(
                              labelText: l.t('password'),
                              border: OutlineInputBorder(),
                              suffixIcon: IconButton(icon: Icon(obscure?Icons.visibility_off:Icons.visibility), onPressed: ()=>setState(()=>obscure=!obscure)),
                            ),
                            validator: (v) => (v==null || v.trim().isEmpty) ? l.t('requiredField') : null,
                          ),
                          if (_error!=null) ...[
                            SizedBox(height: 10),
                            Text(_error!, style: TextStyle(color: Colors.red))
                          ],
                          SizedBox(height: 16),
                          Row(children: [
                            Expanded(child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor, // Use new primary color
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                if (!_formKey.currentState!.validate()) return;
                                final ok = app.login(_uoe.text.trim(), _pass.text);
                                if (ok) {
                                  widget.openMainIfLogged();
                                } else {
                                  setState(()=>_error = l.t('invalidCredentials'));
                                }
                              },
                              child: Padding(padding: EdgeInsets.symmetric(vertical:12), child: Text(l.t('loginButton'))),
                            )),
                          ]),
                          SizedBox(height: 10),
                          Row(children: [
                            Expanded(child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: primaryColor,
                                side: BorderSide(color: primaryColor),
                              ),
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (_) => SignupPage()));
                              }, child: Text(l.t('signupButton')))),
                          ]),
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
