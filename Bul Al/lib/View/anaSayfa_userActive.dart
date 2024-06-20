import 'package:bitirme_tezi/View/products/SepetSayfasi.dart';
import 'package:bitirme_tezi/View/products/kumanda.dart';
import 'package:bitirme_tezi/View/products/leds.dart';
import 'package:bitirme_tezi/ViewModel/AnaSayfaViewModel.dart';
import 'package:bitirme_tezi/ViewModel/KumandaViewModel.dart';
import 'package:bitirme_tezi/ViewModel/LedViewModel.dart';

import 'package:bitirme_tezi/ViewModel/urunOzellikleriViewModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth.dart';

import 'components/IconPerson.dart';
import 'components/shoppingCard.dart';
import 'components/side_menu.dart';
import 'UserInformationPages/loggedInBilgiler.dart';

class anaSayfaUserActive extends StatefulWidget {
  const anaSayfaUserActive({super.key, required this.title});

  final String title;

  @override
  State<anaSayfaUserActive> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<anaSayfaUserActive> {

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<Auth>(context);
    String? _name = _auth.NameSurname();
    final _viewModel = Provider.of<UrunOzellikleriViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title),
        foregroundColor: Theme.of(context).colorScheme.secondary,
        centerTitle: true,
        actions: [
          IconPerson(
              name: _name,
              widget: LoggedInBilgiler(
                title: _name,
              )),
          FutureBuilder<int>(
            future: _viewModel.getSepettekiUrun(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Hata: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data == 0) {
                return ShoppingCartButton(
                  itemCount: 0,
                  onPressed: () {
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
                  },
                );
              } else {
                int itemCount = snapshot.data ?? 0;
                return ShoppingCartButton(
                  itemCount: itemCount,
                  onPressed: () {
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
                  },
                );
              }
            },
          ),
        ],
      ),
      drawer: SideMenu(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                color: Theme.of(context).colorScheme.secondary,
                padding: const EdgeInsets.all(15),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  width: MediaQuery.of(context).size.width * 0.93,
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.mic,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: () {},
                      ),
                      hintText: "asddsa",
                    ),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 17,
              ),
              FutureBuilder<List<DocumentSnapshot>>(
                future: _auth.getDocuments('activeHomePage'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else {
                    if (snapshot.hasError) {
                      return Text('Hata: ${snapshot.error}');
                    } else {
                      List<DocumentSnapshot> documents = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: documents.length,
                        itemBuilder: (context, index) {
                          var document = documents[index];
                          // Her belge için belge kimliğini ve verileri alın
                          var data = document.data();

                          if (data is Map<String, dynamic>) {
                            String title = data['title'] ?? "";
                            String subTitle = data['subTitle'] ?? "";
                            Icon icon = Provider.of<AnaSayfaViewModel>(context,
                                    listen: false)
                                .buildIconFromFirestoreData(data);

                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: ListTile(
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
                                            create: (context) =>
                                                LedViewModel(),
                                            builder: (context, child) => const Led(),
                                          ),
                                        ),
                                      );
                                  }
                                  setState(() {});
                                },
                                leading: icon,
                                title: Text(title),
                                subtitle: Text(subTitle),
                                trailing: const Icon(Icons.navigate_next),
                              ),
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
        ),
      ),
    );
  }
}
