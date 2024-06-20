import 'package:bitirme_tezi/View/products/urunozellikleri.dart';
import 'package:bitirme_tezi/ViewModel/KumandaViewModel.dart';
import 'package:bitirme_tezi/ViewModel/urunOzellikleriViewModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../ViewModel/LoggedInViewModel.dart';
import '../../services/auth.dart';
import '../UserInformationPages/loggedInBilgiler.dart';
import '../components/shoppingCard.dart';
import 'SepetSayfasi.dart';

class Kumanda extends StatefulWidget {
  const Kumanda({super.key});

  @override
  State<Kumanda> createState() => _KumandaState();
}

class _KumandaState extends State<Kumanda> {
  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<Auth>(context);
    String? _name = _auth.NameSurname();
    final _viewModel = Provider.of<UrunOzellikleriViewModel>(context);
    final _kumandaviewModel = Provider.of<KumandaViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.secondary,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider(
                    create: (context) => LoggedInViewModel(),
                    child: LoggedInBilgiler(title: _name),
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.person,
              size: 30,
            ),
          ),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                  onChanged: (value) {},
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
            Center(
              child: FutureBuilder<List<DocumentSnapshot>>(
                future: _auth.getDocuments('kumandalar'),
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
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: (documents.length / 2).ceil(),
                        itemBuilder: (context, index) {
                          int startIndex = index *
                              2; // Her iki Container'ın başlangıç indeksi
                          int endIndex = startIndex +
                              1; // Her iki Container'ın bitiş indeksi
                          // Her iki Container için verileri al

                          var data1 = documents[startIndex].data()
                              as Map<String, dynamic>;
                          String title1 = data1['Title'] ?? "";
                          double price1 = data1['Price'].toDouble();
                          String photo1 = data1['photo'] ?? "";

                          if (endIndex >= documents.length) {
                            return Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UrunOzellikleri(
                                          urunAdi: title1,
                                          price: price1,
                                          photo: photo1,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            width: 2,
                                          ),
                                        ),
                                        width: 180,
                                        height: 300,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 15,
                                                horizontal: 30,
                                              ),
                                              child:
                                                  FutureBuilder<List<String>>(
                                                future: _kumandaviewModel
                                                    .getFilesFromStorage(),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const Center(
                                                        child:
                                                            CircularProgressIndicator());
                                                  } else if (snapshot
                                                      .hasError) {
                                                    return Center(
                                                      child: Text(
                                                          'Error: ${snapshot.error}'),
                                                    );
                                                  } else {
                                                    return Image.network(
                                                      snapshot
                                                          .data![startIndex],
                                                      height: 160,
                                                      fit: BoxFit.fill,
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                            Text(
                                              title1,
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              '$price1 TL',
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.orange[900],
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            //Image.network(_kumandaviewModel.imageUrls[index]),
                                          ],
                                        ),
                                      )),
                                ),
                              ],
                            );
                          } else {
                            var data2 = documents[endIndex].data()
                                as Map<String, dynamic>;
                            String title2 = data2['Title'] ?? "";
                            double price2 = data2['Price'].toDouble();
                            String photo2 = data2['photo'] ?? "";
                            return Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UrunOzellikleri(
                                          urunAdi: title1,
                                          price: price1,
                                          photo: photo1,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          width: 2,
                                        ),
                                      ),
                                      width: 180,
                                      height: 300,
                                      child: Column(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10),
                                          ),
                                          FutureBuilder<List<String>>(
                                            future: _kumandaviewModel
                                                .getFilesFromStorage(),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              } else if (snapshot.hasError) {
                                                return Center(
                                                  child: Text(
                                                      'Error: ${snapshot.error}'),
                                                );
                                              } else {
                                                return Image.network(
                                                  snapshot.data![startIndex],
                                                  height: 160,
                                                  fit: BoxFit.fill,
                                                );
                                              }
                                            },
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10),
                                          ),
                                          Text(
                                            title1,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '$price1 TL',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.orange[900],
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UrunOzellikleri(
                                          urunAdi: title2,
                                          price: price2,
                                          photo: photo2,
                                        ),
                                      ),
                                    );
                                    setState(() {});
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          width: 2,
                                        ),
                                      ),
                                      width: 180,
                                      height: 300,
                                      child: Column(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10),
                                          ),
                                          FutureBuilder<List<String>>(
                                            future: _kumandaviewModel
                                                .getFilesFromStorage(),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              } else if (snapshot.hasError) {
                                                return Center(
                                                  child: Text(
                                                    'Error: ${snapshot.error}',
                                                  ),
                                                );
                                              } else {
                                                return Image.network(
                                                  snapshot.data![endIndex],
                                                  height: 160,
                                                  fit: BoxFit.fill,
                                                );
                                              }
                                            },
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10),
                                          ),
                                          Text(
                                            title2,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '$price2 TL',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.orange[900],
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
