import 'package:bitirme_tezi/View/components/shoppingCard.dart';

import 'package:bitirme_tezi/ViewModel/urunOzellikleriViewModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../ViewModel/LoggedInViewModel.dart';

import '../../services/auth.dart';
import '../UserInformationPages/loggedInBilgiler.dart';
import 'SepetSayfasi.dart';

class UrunOzellikleri extends StatefulWidget {
  final String urunAdi;
  final double price;
  final String photo;

  const UrunOzellikleri(
      {super.key,
      required this.urunAdi,
      required this.price,
      required this.photo});

  @override
  State<UrunOzellikleri> createState() => _UrunOzellikleriState();
}

class _UrunOzellikleriState extends State<UrunOzellikleri> {
  int sepettekiUrunler = 0;

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
                    Navigator.of(context).popUntil((route) => route.isFirst);
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
    int sepet = 0;

    setState(() {
      print("denemeeee");
      print(_viewModel.getSepettekiUrun());
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.secondary,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Navigator.pop(context, sepet);
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
                    print('itemCount = ${itemCount}');
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
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: SizedBox(
                  width: 300,
                  height: 300,
                  child: Image.network(
                    widget.photo,
                  ),
                ),
              ),
              Text(
                widget.urunAdi,
                style: const TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.urunAdi.toString().startsWith('RLT')
                    ? "${widget.price} \$"
                    : "${widget.price} TL",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.orange[900],
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(
                    color: Colors.black,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 60,
                      height: 50,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.primary),
                          shape: const MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _viewModel.siparisAzalt();
                          });
                        },
                        child: Text(
                          '-',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: Center(
                        child: Text(
                          "${_viewModel.getSiparisAdedi()}",
                          style: const TextStyle(
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      height: 50,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.primary),
                          shape: const MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          setState(() {
                            _viewModel.siparisArttir();
                            print("Ürün adedi = ${_viewModel.getUrunAdedi()}");
                          });
                          int? zort;
                          zort = await _viewModel.getUrunAdedi();
                          print("zort = $zort");
                        },
                        child: Text(
                          '+',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(padding: EdgeInsets.all(10)),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(300, 50),
                  backgroundColor: const Color(0xFFff7f00),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)),
                ),
                onPressed: () async {
                  await _viewModel.setUrunAdedi(_viewModel.getSiparisAdedi(),
                      widget.urunAdi, widget.price, widget.photo);
                  setState(() {
                    sepettekiUrunler = _viewModel.getToplamSiparis();
                    print('sepetteki ürünler = $sepettekiUrunler');
                  });
                },
                child: Text(
                  'Sepete Ekle',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.normal,
                      fontSize: 25),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(20),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(300, 50),
                  backgroundColor: const Color(0xFF00a500),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)),
                ),
                onPressed: () async {
                  await _viewModel.hemenAlBtn(
                    _viewModel.getSiparisAdedi(),
                    widget.urunAdi,
                    widget.price,
                    widget.photo,
                  );
                  _showSuccessDialog();
                },
                child: Text(
                  'Hemen Al',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.normal,
                      fontSize: 25),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(20),
              ),
              TextButton.icon(
                icon: const Icon(
                  Icons.favorite_border,
                  color: Colors.red,
                ),
                label: Text(
                  'Favori Ürün',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                      fontSize: 25),
                ),
                style: ElevatedButton.styleFrom(
                  side: BorderSide(
                      color: Theme.of(context).colorScheme.primary, width: 2),
                  minimumSize: const Size(300, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
                onPressed: () {},
              ),
              const Padding(
                padding: EdgeInsets.all(20),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    GestureDetector(
                      child: Container(
                        width: 130,
                        height: 50,
                        color: _viewModel.getisPressed()
                            ? Colors.transparent
                            : const Color(0xFFff7f00),
                        child: const Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            "Ürün Bilgisi",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _viewModel.btnUrun();
                        });
                      },
                    ),
                    GestureDetector(
                      child: Container(
                        width: 130,
                        height: 50,
                        color: _viewModel.getisPressedYorumlar()
                            ? Colors.transparent
                            : const Color(0xFFff7f00),
                        child: const Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            "Yorumlar",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _viewModel.btnYorumlar();
                        });
                      },
                    ),
                  ],
                ),
              ),
              !_viewModel.getisPressed()
                  ? Container(
                      width: MediaQuery.of(context).size.width * 0.93,
                      height: 700,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            widget.urunAdi.startsWith('RLT')
                                ? Column(
                                    children: [
                                      FutureBuilder(
                                        future: _auth.getDocuments('ledler'),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                          } else {
                                            if (snapshot.hasError) {
                                              return Text(
                                                  'Hata: ${snapshot.error}');
                                            } else {
                                              List<DocumentSnapshot> documents =
                                                  snapshot.data!;
                                              return ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemCount: documents.length,
                                                itemBuilder: (context, index) {
                                                  var data = documents[index]
                                                          .data()
                                                      as Map<String, dynamic>;
                                                  String title =
                                                      data['Title'] ?? "";

                                                  if (title == widget.urunAdi) {
                                                    return Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          widget.urunAdi,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 30,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          "Led Sayısı = ${data['LedSayisi']}",
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 30,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          "Takım Bilgisi = ${data['TakimBilgisi']}",
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 30,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  }
                                                  else {
                                                    index++;
                                                    return const SizedBox();
                                                  }
                                                },
                                              );
                                            }
                                          }
                                        },
                                      ),
                                    ],
                                  )
                                : Text(
                                    widget.urunAdi,
                                    style: const TextStyle(
                                      fontSize: 30,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width * 0.93,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 15),
                        child: Center(
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                              ),
                              const Text("Bu ürüne ilk yorumu siz yapın!"),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 15),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFff7f00),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0)),
                                ),
                                onPressed: () {},
                                child: Text(
                                  'Yorum Yaz',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
              const Padding(
                padding: EdgeInsets.all(20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
