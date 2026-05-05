import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/mensagens.dart';

class MessageList extends StatefulWidget {
  final String user;
  final String friend;

  const MessageList({Key? key, required this.user, required this.friend}) : super(key: key);

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  List<DocumentSnapshot> _resultsList = [];

  @override
  void initState() {
    super.initState();
    _buscaRegistro();
  }

  Future<void> _buscaRegistro() async {
    var banco = FirebaseFirestore.instance.collection("msg");
    var consulta = await banco
        .where("user", isEqualTo: widget.user)
        .where("friend", isEqualTo: widget.friend)
        .limit(100)
        .get();

    setState(() {
      _resultsList = consulta.docs;
    });
  }

  Widget buildMessageCard(DocumentSnapshot document) {
    final mensagem = Mensagens.fromSnapshot(document);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        title: Text(mensagem.msg),
        subtitle: Text(mensagem.dt.toString()),
        leading: const Icon(Icons.message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista conversas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _buscaRegistro();
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: _resultsList.length,
        itemBuilder: (context, index) {
          return buildMessageCard(_resultsList[index]);
        },
      ),
    );
  }
}
