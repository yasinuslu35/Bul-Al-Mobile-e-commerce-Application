import 'package:bitirme_tezi/View/loginPages/name_surnamePage.dart';
import 'package:bitirme_tezi/ViewModel/LoginPageViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../ViewModel/nameSurnameViewModel.dart';
import '../../services/auth.dart';
import '../components/side_menu.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoginPage = false;

  final _registerFormKey = GlobalKey<FormState>();
  final _signInFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LoginPageViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('GİRİŞ YAP/KAYIT OL'),
        foregroundColor: Theme.of(context).colorScheme.secondary,
        centerTitle: true,
      ),
      drawer: SideMenu(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const FlutterLogo(
                size: 60,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(
                        () {
                          isLoginPage = false;
                          viewModel.resetTextFields();
                        },
                      );
                    },
                    child: Text(
                      'Kayıt Ol',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight:
                            isLoginPage ? FontWeight.normal : FontWeight.bold,
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(right: 42)),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isLoginPage = true;
                        viewModel.resetTextFields();
                      });
                    },
                    child: Text(
                      'Giriş Yap',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight:
                            isLoginPage ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                thickness: 2,
                endIndent: MediaQuery.of(context).size.width * 0.17,
                indent: MediaQuery.of(context).size.width * 0.17,
                color: Colors.black,
              ),
              isLoginPage ? loginPageKismi() : registerPageKismi(),
            ],
          ),
        ),
      ),
    );
  }

  Form loginPageKismi() {
    final viewModel = Provider.of<LoginPageViewModel>(context);
    final textFieldsLogin =
        Provider.of<LoginPageViewModel>(context).textFieldLogin;
    return Form(
      key: _signInFormKey,
      child: Column(
        children: [
          const SizedBox(height: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: textFieldsLogin.length,
              separatorBuilder: (context, index) => const SizedBox(
                height: 15,
              ),
              itemBuilder: (context, index) {
                final item = textFieldsLogin[index];
                return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: TextFormField(
                    style: const TextStyle(
                      decorationThickness: 0,
                      fontSize: 19,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                    controller: item.controller,
                    validator: item.validator,
                    obscureText: item.isPassword,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(20, 3, 0, 3),
                      errorBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 0.5,
                        ),
                      ),
                      hintText: item.yazi,
                      errorMaxLines: 8,
                      errorStyle: const TextStyle(
                        fontSize: 14,
                      ),
                      hintStyle: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () async {
              if (_signInFormKey.currentState!.validate()) {
                await Provider.of<LoginPageViewModel>(context, listen: false)
                    .btn_ClickLogin(_showErrorDialog);

                setState(
                  () {
                    Navigator.pop(context);
                  },
                );
              }
            },
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(
                    Theme.of(context).colorScheme.secondary)),
            child: const Text('E-posta ile giriş yap'),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Henüz hesabın yok mu?',
                style: TextStyle(fontSize: 15),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    isLoginPage = false;
                    viewModel.resetTextFields();
                  });
                },
                child: const Text(
                  'Hesap aç',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                  icon: const Icon(Icons.monochrome_photos_rounded),
                  label: const Text('Google ile giriş yap'),
                  style: const ButtonStyle(),
                  onPressed: () async {
                    final _auth = Provider.of<Auth>(context, listen: false);
                    final user = await _auth.signInWithGoogle();
                    if (user?.email == null) {
                      const CircularProgressIndicator();
                    }
                    setState(
                      () {
                        Navigator.pop(context);
                      },
                    );
                  }),
              const SizedBox(
                width: 5,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Form registerPageKismi() {
    final textFieldsRegister =
        Provider.of<LoginPageViewModel>(context).textFieldRegister;
    final viewModel = Provider.of<LoginPageViewModel>(context);
    return Form(
      key: _registerFormKey,
      child: Column(
        children: [
          const SizedBox(height: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: textFieldsRegister.length,
              separatorBuilder: (context, index) => const SizedBox(
                height: 15,
              ),
              itemBuilder: (context, index) {
                final item = textFieldsRegister[index];
                return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: TextFormField(
                    style: const TextStyle(
                      decorationThickness: 0,
                      fontSize: 19,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                    controller: item.controller,
                    validator: item.validator,
                    obscureText: item.isPassword,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(20, 3, 0, 3),
                      errorBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 0.5,
                        ),
                      ),
                      hintText: item.yazi,
                      errorMaxLines: 8,
                      errorStyle: const TextStyle(
                        fontSize: 14,
                      ),
                      hintStyle: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (_registerFormKey.currentState!.validate()) {
                final user = await Provider.of<LoginPageViewModel>(context,
                        listen: false)
                    .btn_ClickRegister(_showErrorDialog);

                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider(
                        create: (context) => NameSurnameViewModel(),
                        child: NameSurnamePage(
                          email: user?.email,
                        ),
                      ),
                    ),
                  );
                });
              }
            },
            child: const Text('Hesap aç'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Zaten hesabın var mı?',
                style: TextStyle(fontSize: 15),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    isLoginPage = true;
                    viewModel.resetTextFields();
                  });
                },
                child: const Text(
                  'Giriş Yap',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.monochrome_photos_rounded),
                label: const Text('Google ile kayıt ol'),
                style: const ButtonStyle(),
                onPressed: () async {
                  final _auth = Provider.of<Auth>(context, listen: false);
                  final user = await _auth.signInWithGoogle();

                  if (user?.email == null) {
                    const CircularProgressIndicator();
                  }
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hata'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              child: const Text('Tamam'),
              onPressed: () {
                Navigator.of(context).pop(); // Dialog'u kapat
              },
            ),
          ],
        );
      },
    );
  }
}
