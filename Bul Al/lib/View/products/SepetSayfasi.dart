import 'package:bitirme_tezi/ViewModel/urunOzellikleriViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../ViewModel/LoggedInViewModel.dart';
import '../../services/auth.dart';
import '../UserInformationPages/loggedInBilgiler.dart';

class SepetSayfasi extends StatefulWidget {
  final VoidCallback onReturn;

  const SepetSayfasi({
    super.key,
    required this.onReturn,
  });

  @override
  State<SepetSayfasi> createState() => _SepetSayfasi();
}

class _SepetSayfasi extends State<SepetSayfasi> {
  @override
  Widget build(BuildContext context) {
    void _showSuccessDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Başarılı'),
            content: const Text('Siparişiniz başarıyla alınmıştır'),
            actions: <Widget>[
              TextButton(
                child: const Text('Tamam'),
                onPressed: () {
                  setState(() {
                    Navigator.of(context).pop();
                  });
                },
              ),
            ],
          );
        },
      );
    }

    final _auth = Provider.of<Auth>(context);
    String? _name = _auth.NameSurname();
    final _viewModel = Provider.of<UrunOzellikleriViewModel>(context);
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
      body: _viewModel.getToplamSiparis() == 0
          ? Center(
              child: Column(
                children: [
                  const Text("Sepetiniz şu an boş görünüyor"),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    child: const Text('Ana Sayfaya dön'),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
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
                    return const Center(
                        child: Text('Sepetiniz şu an boş görünüyor'));
                  }
                  List<String> urunadlari = [];
                  List<int> siparisAdedleri = [];
                  List<double> fiyatlar = [];
                  List<String> photoUrl = [];

                  for (int i = 0; i < snapshot.data!.length; i++) {
                    urunadlari.add(snapshot.data![i]['ürünadi']);
                    siparisAdedleri
                        .add(snapshot.data![i]['sepettekiurunadedi']);
                    fiyatlar.add(snapshot.data![i]['Price'].toDouble());
                    photoUrl.add(snapshot.data![i]['photoUrl']);
                  }
                  print("snapshot verisi = ${snapshot.data![0]}");
                  return Column(
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
                                        horizontal: 5,
                                        vertical: 30,
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        border: Border.all(
                                          color: Colors.black,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            width: 55,
                                            height: 40,
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .primary),
                                                shape:
                                                    const MaterialStatePropertyAll(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(10),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              onPressed: () async {
                                                setState(() {
                                                  print(
                                                      "--siparis adedleri = ${--siparisAdedleri[index]}");
                                                  print(
                                                      "siparis adetleri = ${siparisAdedleri[index]}");
                                                  _viewModel
                                                      .toplamSiparisAzalt();
                                                });
                                                if (siparisAdedleri[index] <
                                                    1) {
                                                  await _viewModel
                                                      .deleteDocument(
                                                          urunadlari[index]);
                                                }
                                                if (siparisAdedleri[index] >=
                                                    1) {
                                                  await _viewModel.setUrunAdedi(
                                                    siparisAdedleri[index],
                                                    urunadlari[index],
                                                    fiyatlar[index] /
                                                        (siparisAdedleri[
                                                                index] +
                                                            1),
                                                    photoUrl[index],
                                                  );
                                                }
                                              },
                                              child: Text(
                                                '-',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ), // - işareti
                                            ),
                                          ),
                                          SizedBox(
                                            width: 35,
                                            height: 40,
                                            child: Center(
                                              child: Text(
                                                "${siparisAdedleri[index]}",
                                                style: const TextStyle(
                                                  fontSize: 30,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 55,
                                            height: 40,
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .primary),
                                                shape:
                                                    const MaterialStatePropertyAll(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(10),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              onPressed: () async {
                                                setState(() {
                                                  print(
                                                      "++siparisAdedleri = ${++siparisAdedleri[index]}");
                                                  print(
                                                      'ürünlerin toplamı sepet sayfasi = ${_viewModel.getToplamSiparis()}');
                                                  _viewModel
                                                      .toplamSiparisArttir();
                                                });
                                                await _viewModel.setUrunAdedi(
                                                  siparisAdedleri[index],
                                                  urunadlari[index],
                                                  fiyatlar[index] /
                                                      (siparisAdedleri[index] -
                                                          1),
                                                  photoUrl[index],
                                                );
                                              },
                                              child: Text(
                                                '+',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 30,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: urunadlari[index]
                                                    .startsWith('RLT')
                                                ? 100
                                                : 40,
                                            height: 100,
                                            child: Image.network(
                                              photoUrl[index],
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5),
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
                                                urunadlari[index]
                                                        .startsWith('RLT')
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
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : Container();
                        },
                      ),
                      const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10)),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(300, 50),
                          backgroundColor: const Color(0xFFff7f00),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0)),
                        ),
                        onPressed: () async {
                          await _viewModel.siparisiTamamla(
                              siparisAdedleri,
                              urunadlari,
                              fiyatlar,
                              snapshot.data!.length,
                              photoUrl);
                          _showSuccessDialog();
                          await _viewModel.deleteAllDocuments();
                        },
                        child: Text(
                          'Satın Al',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.normal,
                              fontSize: 25),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
    );
  }
}
