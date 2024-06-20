import 'package:bitirme_tezi/ViewModel/SiparislerimViewModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../ViewModel/LoggedInViewModel.dart';
import '../../services/auth.dart';
import '../UserInformationPages/loggedInBilgiler.dart';

class Siparislerim extends StatefulWidget {
  final VoidCallback onReturn;

  const Siparislerim({
    super.key,
    required this.onReturn,
  });

  @override
  State<Siparislerim> createState() => _Siparislerim();
}

class _Siparislerim extends State<Siparislerim> {
  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<Auth>(context);
    String? _name = _auth.NameSurname();
    final _viewModel = Provider.of<SiparislerimViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.secondary,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () {
            widget.onReturn();
            Navigator.pop(context);
          },
        ),
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
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: _viewModel.getSepetBilgileri(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Hata: ${snapshot.error}'));
            } else if (!snapshot.hasData ||
                snapshot.data == null ||
                snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  children: [
                    const Text("Herhangi bir siparişiniz bulunmamaktadır."),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      child: const Text('Ana Sayfaya dön'),
                    ),
                  ],
                ),
              );
            }
            List<String> urunadlari = [];
            List<int> siparisAdedleri = [];
            List<double> fiyatlar = [];
            List<String> photoUrl = [];

            List<Timestamp> siparisSaati = [];
            List<String> bolunmusSiparisSaati = [];

            for (int i = 0; i < snapshot.data!.length; i++) {
              urunadlari.add(snapshot.data![i]['ürünadi']);
              siparisAdedleri.add(snapshot.data![i]['siparisSayisi']);
              fiyatlar.add(snapshot.data![i]['Fiyat'].toDouble());
              photoUrl.add(snapshot.data![i]['photoUrl']);
              siparisSaati.add(snapshot.data![i]['Siparis Saati']);

              bolunmusSiparisSaati.add(siparisSaati[i]
                  .toDate()
                  .add(const Duration(hours: 3))
                  .toString()
                  .substring(0, 10));
              bolunmusSiparisSaati.add(siparisSaati[i]
                  .toDate()
                  .add(const Duration(hours: 3))
                  .toString()
                  .substring(10, 19));
            }
            print("snapshot verisi = ${snapshot.data![0]}");
            return SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    itemCount: snapshot.data!.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return siparisAdedleri[index] > 0
                          ? Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 60,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width:
                                            urunadlari[index].startsWith('RLT')
                                                ? 100
                                                : 40,
                                        height: 100,
                                        child: Image.network(
                                          photoUrl[index],
                                        ),
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 5),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            urunadlari[index],
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '${siparisAdedleri[index]} Adet',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            urunadlari[index].startsWith('RLT')
                                                ? '${fiyatlar[index]} \$'
                                                : '${fiyatlar[index]} TL',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.orange[900],
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 5),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Sipariş Saati',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                bolunmusSiparisSaati[index * 2],
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                bolunmusSiparisSaati[
                                                    index * 2 + 1],
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Container();
                    },
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
