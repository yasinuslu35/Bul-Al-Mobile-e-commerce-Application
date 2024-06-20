import 'package:bitirme_tezi/Model/LoggedInModel.dart';
import 'package:bitirme_tezi/View/UserInformationPages/ChangePassword.dart';
import 'package:bitirme_tezi/View/UserInformationPages/userInformation.dart';
import 'package:bitirme_tezi/View/products/SepetSayfasi.dart';
import 'package:bitirme_tezi/View/products/Siparislerim.dart';
import 'package:bitirme_tezi/ViewModel/ChangePasswordViewModel.dart';
import 'package:bitirme_tezi/ViewModel/LoggedInViewModel.dart';
import 'package:bitirme_tezi/ViewModel/SiparislerimViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../ViewModel/UserInformationViewModel.dart';
import '../../services/auth.dart';
import '../components/side_menu.dart';

class LoggedInBilgiler extends StatefulWidget {
  final String? title;

  const LoggedInBilgiler({super.key, required this.title});

  @override
  State<LoggedInBilgiler> createState() => _LoggedInBilgilerState();
}

class _LoggedInBilgilerState extends State<LoggedInBilgiler> {
  @override
  Widget build(BuildContext context) {
    String? email = Provider.of<Auth>(context).getEmail();
    final _loggedInViewModel = Provider.of<LoggedInViewModel>(context);
    final List<LoggedInModel> _titlesDiger = _loggedInViewModel.titlesDiger;
    final List<LoggedInModel> _titles = _loggedInViewModel.titles;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title!),
            const Text(
              'Bana Özel',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
        foregroundColor: Theme.of(context).colorScheme.secondary,
      ),
      drawer: SideMenu(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).colorScheme.secondary,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Text(
                    'HESABIM',
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _titles.length,
                itemBuilder: (context, index) {
                  final item = _titles[index];
                  return Column(
                    children: [
                      Divider(
                        height: 0,
                        thickness: 1,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      ListTile(
                        tileColor: Theme.of(context).colorScheme.secondary,
                        onTap: () {
                          switch (index) {
                            case 0:
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SepetSayfasi(
                                    onReturn: () {
                                      setState(() {});
                                    },
                                  ),
                                ),
                              );
                              break;

                            case 1:
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChangeNotifierProvider(
                                    create: (context) =>
                                        SiparislerimViewModel(),
                                    builder: (context, child) => Siparislerim(
                                      onReturn: () {
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ),
                              );
                              break;
                            case 2:
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChangeNotifierProvider(
                                    create: (context) =>
                                        UserInformationViewModel(),
                                    child: const UserInformation(),
                                  ),
                                ),
                              );
                              break;
                            case 3:
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChangeNotifierProvider(
                                    create: (context) =>
                                        ChangePswordViewModel(),
                                    child: const ChangePasswordPage(),
                                  ),
                                ),
                              );
                              break;
                          }
                        },
                        title: Text(item.title),
                        trailing: Icon(
                          Icons.navigate_next,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      Divider(
                        height: 0,
                        thickness: 1,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  );
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 6.0),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).colorScheme.secondary,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Text(
                    'DİĞER',
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _titlesDiger.length,
                itemBuilder: (context, index) {
                  final item = _titlesDiger[index];
                  return Column(
                    children: [
                      Divider(
                        height: 0,
                        thickness: 1,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      ListTile(
                        tileColor: Theme.of(context).colorScheme.secondary,
                        onTap: () {},
                        title: Text(item.title),
                        trailing: Icon(
                          Icons.navigate_next,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      Divider(
                        height: 0,
                        thickness: 1,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  );
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 6.0),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(
                    Size(MediaQuery.of(context).size.width, 60),
                  ),
                  shape: MaterialStateProperty.all(LinearBorder.none),
                ),
                onPressed: () {
                  _showMyDialog(
                      "$email",
                      "Hesabıyla giriş yaptın.Çıkış yapmak istediğine emin misiniz?",
                      "Çıkış");
                },
                child: Text(
                  'Çıkış Yap',
                  style: TextStyle(color: Colors.red[800], fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showMyDialog(
      String mailText, String normalText, String sifreText) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(sifreText),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(mailText),
                Text(normalText),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('TAMAM'),
              onPressed: () {
                Provider.of<Auth>(context, listen: false).signOut();
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
            TextButton(
              child: const Text('İPTAL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
