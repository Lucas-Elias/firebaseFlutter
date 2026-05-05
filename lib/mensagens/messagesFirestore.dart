import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/mensagens.dart';
import '../nossowidget/widget_input_memo.dart';
import '../nossowidget/widget_button_custom.dart';
import '../nossowidget/widget_text_custom.dart';

class MessagesFirestore extends StatefulWidget {
  final String user;
  final String friend;

  const MessagesFirestore({Key? key, required this.user, required this.friend}) : super(key: key);

  @override
  State<MessagesFirestore> createState() => _MessagesFirestoreState();
}

class _MessagesFirestoreState extends State<MessagesFirestore> {
  final TextEditingController _msg = TextEditingController();
  List<DocumentSnapshot> _resultsList = [];

  @override
  void initState() {
    super.initState();
    _buscaRegistro();
  }

  void _clicksend(BuildContext ctx) {
    if (_msg.text.trim().isEmpty) return;

    Mensagens ms = Mensagens();
    ms.friend = widget.friend;
    ms.user = widget.user;
    ms.msg = _msg.text.toString().trim();
    ms.dt = DateTime.now();

    CollectionReference instanciaColecaoFirestore = FirebaseFirestore.instance.collection("msg");

    instanciaColecaoFirestore
        .doc(ms.dt.toString().trim())
        .set(ms.toJson())
        .then((value) {
      print("Mensagem adicionada");
      _msg.clear();
      _buscaRegistro(); // atualiza a lista após enviar
    }).catchError((onError) => print("Erro ao gravar no banco $onError"));
  }

  Future<void> _buscaRegistro() async {
    var banco = FirebaseFirestore.instance.collection("msg");
    var consulta = await banco
        .where("friend", isEqualTo: widget.friend)
        .where("user", isEqualTo: widget.user)
        .limit(100)
        .get();

    setState(() {
      _resultsList = consulta.docs;
    });
  }

  Widget buildMessageCard(BuildContext context, DocumentSnapshot document, String friend) {
    final mensagem = Mensagens.fromSnapshot(document);
    return Container(
      child: Card(
        child: InkWell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 1.0, bottom: 1.0),
                  child: Wrap(
                    runAlignment: WrapAlignment.start,
                    alignment: WrapAlignment.spaceAround,
                    children: [
                      Text(
                        mensagem.msg,
                        style: const TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 1.0, bottom: 1.0),
                  child: Wrap(
                    runAlignment: WrapAlignment.start,
                    alignment: WrapAlignment.spaceAround,
                    children: [
                      Text(
                        mensagem.dt.toString(),
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          onDoubleTap: () {
            print("Double tap");
          },
        ),
      ),
    );
  }

  Widget ContainerOldMessages() {
    return Container(
      color: Colors.transparent,
      height: 270,
      width: double.maxFinite,
      margin: const EdgeInsets.only(left: 3, right: 3, bottom: 0, top: 0),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _resultsList.length,
        itemBuilder: (BuildContext ctx, int index) =>
            buildMessageCard(ctx, _resultsList[index], widget.friend),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mensagens'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: WidgetTextCustom(
                text: "Conversas com seu amigo: ${widget.friend}",
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            ContainerOldMessages(),
            const Divider(),
            WidgetInputMemo(
              controller: _msg,
              hintText: 'Digite a mensagem:',
              labelText: 'Digite a mensagem:',
            ),
            Row(
              children: [
                Expanded(
                  child: WidgetButtonCustom(
                    text: 'Enviar',
                    onPressed: () => _clicksend(context),
                  ),
                ),
                Expanded(
                  child: WidgetButtonCustom(
                    text: 'Receber',
                    color: Colors.orange,
                    onPressed: _buscaRegistro,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
