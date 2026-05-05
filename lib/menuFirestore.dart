import 'package:flutter/material.dart';
import 'mensagens/messagesFirestore.dart';
import 'mensagens/messageList.dart';
import 'nossowidget/widget_input.dart';
import 'nossowidget/widget_button_custom.dart';

class MenuFirestore extends StatefulWidget {
  const MenuFirestore({Key? key}) : super(key: key);

  @override
  State<MenuFirestore> createState() => _MenuFirestoreState();
}

class _MenuFirestoreState extends State<MenuFirestore> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _friendController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escolha a opção'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            WidgetInput(
              controller: _userController,
              hintText: 'Digite seu usuário',
              labelText: 'Seu usuário',
              icon: Icons.person,
            ),
            WidgetInput(
              controller: _friendController,
              hintText: 'Digite com quem quer conversar',
              labelText: 'Com quem você quer conversar?',
              icon: Icons.people,
            ),
            const SizedBox(height: 20),
            WidgetButtonCustom(
              text: 'Conversar',
              onPressed: () {
                if (_userController.text.isNotEmpty && _friendController.text.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MessagesFirestore(
                        user: _userController.text.trim(),
                        friend: _friendController.text.trim(),
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Preencha os dois campos!')),
                  );
                }
              },
            ),
            WidgetButtonCustom(
              text: 'Histórico de mensagens',
              color: Colors.green,
              onPressed: () {
                if (_userController.text.isNotEmpty && _friendController.text.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MessageList(
                        user: _userController.text.trim(),
                        friend: _friendController.text.trim(),
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Preencha os dois campos!')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
