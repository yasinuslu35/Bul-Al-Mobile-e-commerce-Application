import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../ViewModel/nameSurnameViewModel.dart';
import '../../services/auth.dart';
import '../../services/on_board.dart';

class NameSurnamePage extends StatefulWidget {
  const NameSurnamePage({super.key, required this.email});

  final String? email;

  @override
  State<NameSurnamePage> createState() => _NameSurnamePageState();
}

class _NameSurnamePageState extends State<NameSurnamePage> {
  final _nameSurnameFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<NameSurnameViewModel>(context);
    final textFields = viewModel.textFieldNameSurname;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () async {
                  await Provider.of<Auth>(context, listen: false).deleteUser();
                  await Provider.of<Auth>(context, listen: false).signOut();

                  //Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.cancel),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hesap Aç',
                    style: TextStyle(
                      fontSize: 25,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Form(
                    key: _nameSurnameFormKey,
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: TextFormField(
                            style: const TextStyle(
                              decorationThickness: 0,
                              fontSize: 19,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                            controller: textFields[0].controller,
                            validator: textFields[0].validator,
                            obscureText: textFields[0].isPassword,
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.fromLTRB(20, 3, 0, 3),
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
                              hintText: textFields[0].yazi,
                              errorMaxLines: 8,
                              errorStyle: const TextStyle(
                                fontSize: 14,
                              ),
                              hintStyle: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: TextFormField(
                            style: const TextStyle(
                              decorationThickness: 0,
                              fontSize: 19,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                            controller: textFields[1].controller,
                            validator: textFields[1].validator,
                            obscureText: textFields[1].isPassword,
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.fromLTRB(20, 3, 0, 3),
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
                              hintText: textFields[1].yazi,
                              errorMaxLines: 8,
                              errorStyle: const TextStyle(
                                fontSize: 14,
                              ),
                              hintStyle: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.secondary),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blue[800]),
                      minimumSize: MaterialStateProperty.all(
                        Size(MediaQuery.of(context).size.width * 0.9, 60),
                      ),
                      shape: MaterialStateProperty.all(LinearBorder.none),
                    ),
                    onPressed: () async {
                      if (_nameSurnameFormKey.currentState!.validate()) {
                        await Provider.of<NameSurnameViewModel>(context,
                                listen: false)
                            .btn_Click(widget.email);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OnBoardWidget(),
                            ));
                      }
                    },
                    child: const Text(
                      'Hesap Aç',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
