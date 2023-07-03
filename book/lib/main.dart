import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(BookApp());
}

class BookApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();
  var titulo = "";
  var itemCount = 0;
  List<String> resultados = [];

  void _buscarLivros() async {
    titulo = _controller.text;
    final url = Uri.https(
      'www.googleapis.com',
      '/books/v1/volumes',
      {'q': titulo},
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      itemCount = jsonResponse['totalItems'];
      print('Number of books about $titulo: $itemCount.');

      // Limpa a lista de resultados antes de atualizar com os novos resultados
      resultados.clear();
      final items = jsonResponse['items'];
      for (var item in items) {
        final volumeInfo = item['volumeInfo'];
        final title = volumeInfo['title'];
        resultados.add(title);
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

    _controller.clear(); // Limpa o campo de texto
    setState(() {}); // Atualiza a interface para exibir os resultados
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(controller: _controller),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _buscarLivros,
              icon: const Icon(Icons.search),
              label: const Text('Pesquisar'),
            ),
            const SizedBox(height: 16),
            Text(
              'Foram encontrados $itemCount livros sobre "$titulo": ',
              style: Theme.of(context).textTheme.headline4,
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: resultados
                  .map((resultado) => Text(
                        resultado,
                        style: const TextStyle(fontSize: 16),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
