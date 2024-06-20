import 'package:bitirme_tezi/View/UserInformationPages/loggedInBilgiler.dart';
import 'package:bitirme_tezi/View/loginPages/loginPage.dart';
import 'package:bitirme_tezi/ViewModel/KumandaViewModel.dart';
import 'package:bitirme_tezi/ViewModel/LedViewModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../ViewModel/AnaSayfaViewModel.dart';
import '../../ViewModel/LoggedInViewModel.dart';
import '../../ViewModel/LoginPageViewModel.dart';

import '../../services/auth.dart';
import '../../services/on_board.dart';
import '../products/kumanda.dart';
import '../products/leds.dart';

class SideMenu extends StatelessWidget {
  late String? yazi;

  SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final authStatus = Provider.of<Auth>(context).authStatus();
    Auth _auth = Auth();

    return StreamBuilder(
      stream: authStatus,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data == null) {
            yazi = '';
          } else {
            yazi = "(${snapshot.data?.displayName})";
          }
          return Drawer(
            width: MediaQuery.of(context).size.width * 0.87,
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Card(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero),
                            color: Theme.of(context).colorScheme.primary,
                            child: ListTile(
                              leading: const FlutterLogo(
                                size: 30.0,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const OnBoardWidget(),
                                  ),
                                );
                              },
                              title: Text(
                                'Ana Sayfa',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              trailing: Icon(
                                Icons.navigate_next,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),
                          Card(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero),
                            color: Theme.of(context).colorScheme.primary,
                            child: ListTile(
                              onTap: () {
                                if (snapshot.data != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ChangeNotifierProvider(
                                        create: (context) =>
                                            LoggedInViewModel(),
                                        child: LoggedInBilgiler(
                                          title: snapshot.data?.displayName,
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ChangeNotifierProvider(
                                        create: (context) =>
                                            LoginPageViewModel(),
                                        child: const LoginPage(),
                                      ),
                                    ),
                                  );
                                }
                              },
                              leading: const FlutterLogo(
                                size: 30.0,
                              ),
                              title: Text(
                                'Bana Özel $yazi',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              trailing: Icon(
                                Icons.navigate_next,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                FutureBuilder<List<DocumentSnapshot>>(
                  future: _auth.getDocuments('activeHomePage'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else {
                      if (snapshot.hasError) {
                        return Column(
                          children: [
                            Text(
                              'Henüz Giriş Yapmamışsınız.',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 25),
                            ),
                            Text(
                              'Lütfen Giriş Yapınız.',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 25),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(300, 50),
                                backgroundColor: const Color(0xFFff7f00),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0)),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ChangeNotifierProvider(
                                      create: (context) => LoginPageViewModel(),
                                      child: const LoginPage(),
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                'Giriş Yap/Kayıt ol',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 25),
                              ),
                            ),
                          ],
                        );
                      } else {
                        List<DocumentSnapshot> documents = snapshot.data!;
                        return ListView.separated(
                          separatorBuilder: (context, index) {
                            return Divider(
                              color: Theme.of(context).colorScheme.primary,
                              thickness: 0.5,
                            );
                          },
                          shrinkWrap: true,
                          itemCount: documents.length,
                          itemBuilder: (context, index) {
                            var document = documents[index];
                            // Her belge için belge kimliğini ve verileri alın
                            var data = document.data();
                            if (data is Map<String, dynamic>) {
                              String title = data['title'] ?? "";
                              String subTitle = data['subTitle'] ?? "";
                              Icon icon = Provider.of<AnaSayfaViewModel>(
                                      context,
                                      listen: false)
                                  .buildIconFromFirestoreData(data);

                              return ListTile(
                                onTap: () async {
                                  switch (index) {
                                    case 0:
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ChangeNotifierProvider(
                                            create: (context) =>
                                                KumandaViewModel(),
                                            builder: (context, child) =>
                                                const Kumanda(),
                                          ),
                                        ),
                                      );
                                    case 1:
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ChangeNotifierProvider(
                                            create: (context) => LedViewModel(),
                                            builder: (context, child) =>
                                                const Led(),
                                          ),
                                        ),
                                      );
                                  }
                                },
                                leading: icon,
                                title: Text(title),
                                subtitle: Text(subTitle),
                                trailing: const Icon(Icons.navigate_next),
                              );
                            } else {
                              return const Text('Veri yok');
                            }
                          },
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          );
        } else {
          return const SizedBox(
            height: 300,
            width: 300,
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
