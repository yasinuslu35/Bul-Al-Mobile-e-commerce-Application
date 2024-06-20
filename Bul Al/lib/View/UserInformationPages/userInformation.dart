import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../ViewModel/UserInformationViewModel.dart';

class UserInformation extends StatefulWidget {
  const UserInformation({super.key});

  @override
  State<UserInformation> createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final _ViewModel = Provider.of<UserInformationViewModel>(context);

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(padding: EdgeInsets.all(5)),
            Form(
              key: _formKey,
              child: Center(
                child: Column(
                  children: [
                    const Image(
                      image: AssetImage('assets/images/Atmosphere.jpg'),
                      width: 200,
                      height: 150,
                      fit: BoxFit.contain,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Profil Fotoğrafı Ekle'),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                ),
                Text(
                  'Ad*',
                  style: TextStyle(
                    fontSize: 19,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.20),
                ),
                Text(
                  'Soyad*',
                  style: TextStyle(
                    fontSize: 19,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            Row(
              children: _ViewModel.model.map((textField) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: TextFormField(
                      controller: textField.controller,
                      validator: textField.validator,
                      style: const TextStyle(
                        decorationThickness: 0,
                        fontSize: 19,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(20, 3, 0, 3),
                        errorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue.shade900,
                            width: 2,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 0.5,
                          ),
                        ),
                        hintText: textField.yazi,
                        errorMaxLines: 8,
                        errorStyle: const TextStyle(
                          fontSize: 14,
                        ),
                        hintStyle: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Telefon',
                style: TextStyle(
                  fontSize: 19,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 9,
                child: TextFormField(
                  onChanged: (value) {},
                  controller: _ViewModel.phoneModel.controller,
                  validator: _ViewModel.phoneModel.validator,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                    // Sadece rakamları kabul eder
                  ],
                  style: const TextStyle(
                    decorationThickness: 0,
                    fontSize: 19,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    prefixText: _ViewModel.phoneModel.yazi,
                    contentPadding: const EdgeInsets.fromLTRB(20, 3, 0, 3),
                    errorBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue.shade900,
                        width: 2,
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 0.5,
                      ),
                    ),
                    errorMaxLines: 8,
                    errorStyle: const TextStyle(
                      fontSize: 14,
                    ),
                    hintStyle: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.blue[800]),
                    minimumSize: MaterialStateProperty.all(
                      Size(MediaQuery.of(context).size.width, 60),
                    ),
                    shape: MaterialStateProperty.all(LinearBorder.none),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      Provider.of<UserInformationViewModel>(context,listen: false).Btn_Click(showToast);
                    }
                  },
                  child: Text(
                    'Kaydet',
                    style: TextStyle(
                      fontSize: 23,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
    );
  }
}
