import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

  FirebaseFirestore.instance.collection('cardapio').doc('comidas').set({
    'Nome': 'Veggie tomato mix',
    'Preco': 'N1,900',
    'id': '1',
    'Imagem':
        'https://cdn.discordapp.com/attachments/1144320039579816068/1155649798079262821/images-removebg-preview.png',
    'Descricao':
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed vestibulum justo eu fermentum.consectetur adipiscing elit. Sed vestibulum justo eu fermentum.Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const MyHomePage(),
      routes: {
        '/home': (context) => const SecondPage(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              color: const Color(0xFFD44E36),
            ),
            Positioned(
              left: 20.0,
              top: 50.0,
              child: Container(
                width: 100.0,
                height: 100.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
            const Positioned(
              left: 20,
              top: 170.0,
              right: 0,
              child: Center(
                child: Text(
                  'Food for Everyone',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 60.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 300.0,
              right: 0,
              child: Image.network(
                'https://cdn.discordapp.com/attachments/1144320039579816068/1155621555615825950/Captura_de_tela_2023-09-24_183237-removebg-preview.png',
                width: 200,
                height: 400,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              left: 20.0,
              bottom: 20.0,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.12,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/home');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            40.0),
                      ),
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(color: Color(0xFFD44E36), fontSize: 19),
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
}

class QuintaPagina extends StatefulWidget {
  const QuintaPagina({super.key});

  @override
  _QuintaPaginaState createState() => _QuintaPaginaState();
}

class _QuintaPaginaState extends State<QuintaPagina> {
  Future<List<Widget>> listCarrinho() async {
    try {
      CollectionReference cardapioCollection =
          FirebaseFirestore.instance.collection('carrinho');
      QuerySnapshot querySnapshot = await cardapioCollection.get();

      List<Widget> items = [];

      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot doc in querySnapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          if (data.containsKey('Nome') && data.containsKey('Preco')) {
            String produto = data['Nome'];
            String preco = data['Preco'];

            items.add(
              Column(
                children: <Widget>[
                  Card(
                    clipBehavior: Clip.antiAlias,
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0),
                      side: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1.0,
                      ),
                    ),
                    child: SizedBox(
                      width: 300,
                      height: 150,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: AspectRatio(
                              aspectRatio: 1.0 / 1.0,
                              child: Image.network(
                                'https://cdn.discordapp.com/attachments/1144320039579816068/1155649798079262821/images-removebg-preview.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  10, 50.0, 16.0, 0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    produto,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    preco,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFD44E36),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        }
      } else {
        items.add(const Text('Carrinho vazio'));
      }

      return items;
    } catch (e) {
      return [Text('Erro ao buscar dados: $e')];
    }
  }

  // Função para limpar a coleção cardapio
  void clearCardapioCollection() {
    CollectionReference cardapioCollection =
        FirebaseFirestore.instance.collection('carrinho');

    // Obtém todos os documentos da coleção
    cardapioCollection.get().then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        // Deleta cada documento individualmente
        doc.reference.delete();
      }
    }).catchError((error) {
      print('Erro ao limpar a coleção cardapio: $error');
    });
  }

  // Função para completar o pedido
  void completeOrder() {
    // Implemente a ação que desejar quando o botão for pressionado
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Positioned(
              left: 16.0,
              top: 40.0,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  size: 30,
                  color: Colors.grey,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed('/home');
                },
              ),
            ),
            const Positioned(
              top: 80.0,
              left: 16.0,
              right: 16.0,
              child: Text(
                'Cart',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              left: 20.0,
              top: 150.0,
              right: 10.0,
              child: SizedBox(
                child: FutureBuilder<List<Widget>>(
                  future: listCarrinho(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else {
                      return Column(
                        children: snapshot.data ?? [],
                      );
                    }
                  },
                ),
              ),
            ),
            Positioned(
              left: 20.0,
              bottom: 80.0,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.08,
                child: ElevatedButton(
                  onPressed: () {
                    // Limpar a coleção cardapio
                    clearCardapioCollection();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const QuintaPagina()));
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Limpar Cardapio',
                    style: TextStyle(
                      fontSize: 19,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 20.0,
              bottom: 20.0,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.08,
                child: ElevatedButton(
                  onPressed: () {
                    completeOrder();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD44E36),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                  ),
                  child: const Text(
                    'Complete Order',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
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
}

class QuartaPagina extends StatefulWidget {
  const QuartaPagina({Key? key}) : super(key: key);

  @override
  _QuartaPaginaState createState() => _QuartaPaginaState();
}

class _QuartaPaginaState extends State<QuartaPagina> {
  String searchText = '';
  Widget resultWidget = Container();

  Future<void> readData() async {
    // Referência para a coleção 'cardapio'
    CollectionReference cardapioCollection =
        FirebaseFirestore.instance.collection('cardapio');

    // Referência para o documento 'comidas' dentro da coleção 'cardapio'
    DocumentReference comidasDocument = cardapioCollection.doc('comidas');

    // Obtém os dados do documento 'comidas'
    DocumentSnapshot documentSnapshot = await comidasDocument.get();

    if (documentSnapshot.exists) {
      // O documento existe, você pode acessar os dados
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;

      if (searchText.isEmpty ||
          data['Nome'].toLowerCase() == searchText.toLowerCase()) {
        String nome = data['Nome'];
        String Preco = data['Preco'];

        // Atualiza o widget de resultado com um botão
        setState(() {
          resultWidget = Center(
            child: Container(
              width: 250.0,
              height: 250.0,
              margin: const EdgeInsets.only(top: 50, right: 50),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40.0),
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1.0,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    'https://cdn.discordapp.com/attachments/1144320039579816068/1155649798079262821/images-removebg-preview.png',
                    fit: BoxFit.contain,
                    height: 150,
                    width: 150,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ThirdPage(),
                      ));
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      elevation: MaterialStateProperty.all<double>(0),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                      textStyle: MaterialStateProperty.all<TextStyle>(
                        const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    child: Text(nome, textAlign: TextAlign.center),
                  ),
                  Text(
                    Preco,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD44E36),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      } else {
        // Texto de pesquisa não corresponde ao documento
        setState(() {
          resultWidget = Center(
            child: Container(
              width: 350.0,
              height: 350.0,
              margin: const EdgeInsets.only(top: 50.0),
              child: ElevatedButton(
                onPressed: () {
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.transparent),
                  elevation: MaterialStateProperty.all<double>(0),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                  textStyle: MaterialStateProperty.all<TextStyle>(
                    const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                child: const Text('Produto não encontrado'),
              ),
            ),
          );
        });
      }
    } else {
      setState(() {
        resultWidget = Center(
          child: Container(
            width: 350.0,
            height: 350.0,
            margin: const EdgeInsets.only(top: 50.0),
            child: ElevatedButton(
              onPressed: () {
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.transparent),
                elevation: MaterialStateProperty.all<double>(0),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                textStyle: MaterialStateProperty.all<TextStyle>(
                  const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              child: const Text('Produto não encontrado'),
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Positioned(
              left: 5.0,
              top: 40.0,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  size: 30,
                  color: Colors.grey,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed('/home');
                },
              ),
            ),
            Positioned(
              right: 16.0,
              top: 35.0,
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: '   Search',
                            ),
                            onChanged: (value) {
                              setState(() {
                                searchText = value;
                              });
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.search,
                            size: 30,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            readData();
                          },
                        ),
                      ],
                    ),
                  ),
                  Center(child: resultWidget),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ThirdPage extends StatefulWidget {
  const ThirdPage({Key? key}) : super(key: key);

  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  double _rating = 0;

  Future<void> addToCardapio(double rating) async {
    final itemData = {
      'Nome': 'Veggie tomato mix',
      'Preco': 'N1,900',
      'id': '1',
      'rating': rating,
    };

    try {
      await FirebaseFirestore.instance
          .collection('carrinho')
          .doc('prato')
          .set(itemData);
      print('Item adicionado ao cardápio com sucesso!');
    } catch (e) {
      print('Erro ao adicionar item ao cardápio: $e');
    }
  }

  Future<void> addComment(String comment) async {
    try {
      await FirebaseFirestore.instance
          .collection('cardapio')
          .doc('comidas')
          .collection('comentarios')
          .add({
        'comment': comment,
        'timestamp': FieldValue.serverTimestamp(),
      }).then((value) {
        setState(() {
        });
      });
      print('Comentário adicionado com sucesso!');
    } catch (e) {
      print('Erro ao adicionar comentário: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 30,
            color: Colors.grey,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const SecondPage()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('cardapio')
              .doc('comidas')
              .get(),
          builder: (context, snapshot) {
            String nomeDoPrato = '';
            String valorDoPrato = '';
            String descricao = '';

            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData && snapshot.data!.exists) {
                final data = snapshot.data!.data() as Map<String, dynamic>?;

                if (data != null && data.containsKey('Nome')) {
                  nomeDoPrato = data['Nome'] as String;
                  valorDoPrato = data['Preco'] as String;
                  descricao = data['Descricao'] as String;
                } else {
                  nomeDoPrato = 'Nome do prato não disponível';
                  valorDoPrato = 'Nome do prato não disponível';
                }
              }
            }

            return Column(
              children: [
                Center(
                  child: Image.network(
                    'https://cdn.discordapp.com/attachments/1144320039579816068/1155649798079262821/images-removebg-preview.png',
                    fit: BoxFit.contain,
                    height: 300,
                    width: 300,
                  ),
                ),
                Center(
                  child: Container(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      nomeDoPrato,
                      style: const TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    padding: const EdgeInsets.only(top: 3.0),
                    child: Text(
                      valorDoPrato,
                      style: const TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFD44E36),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Delivery info',
                      style: TextStyle(
                        fontSize: 19.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      descricao,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.12,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: ElevatedButton(
                        onPressed: () {
                          addToCardapio(0);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const QuintaPagina()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD44E36),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                        ),
                        child: const Text(
                          'Add to cart',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('cardapio')
                        .doc('comidas')
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData && snapshot.data!.exists) {
                          final data =
                              snapshot.data!.data() as Map<String, dynamic>?;

                          if (data != null && data.containsKey('rating')) {
                            final ratingFromFirebase =
                                data['rating'] as double? ?? 0.0;
                            _rating = ratingFromFirebase.toDouble();
                          }
                        }
                      }
                      return RatingBar.builder(
                        initialRating: _rating,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 30.0,
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) async {
                          setState(() {
                            _rating = rating;
                          });
                          await FirebaseFirestore.instance
                              .collection('cardapio')
                              .doc('comidas')
                              .update({'rating': rating});
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey[200],
                    ),
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Deixe seu comentário',
                        border: InputBorder.none,
                      ),
                      onSubmitted: (comment) {
                        addComment(comment);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 0),
                FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('cardapio')
                      .doc('comidas')
                      .collection('comentarios')
                      .orderBy('timestamp', descending: true)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        final comments = snapshot.data!.docs;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 16.0, top: 20.0),
                              child: Text(
                                'Comentários:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: comments.length,
                              itemBuilder: (context, index) {
                                final comment =
                                    comments[index].get('comment') as String;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.grey[200],
                                    ),
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      ' $comment',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      } else {
                        return const Padding(
                          padding: EdgeInsets.only(left: 16.0, top: 20.0),
                          child: Text(
                            'Sem comentários ainda.',
                            style: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        );
                      }
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class Login {
  Future<void> signUp(String email, String password) async {
    Uri uri = Uri.parse(Routes.signUp);
    Map<String, dynamic> body = {
      "email": email,
      "password": password,
      "returnSecureToken": true,
    };

    http.Response response = await http.post(
      uri,
      body: json.encode(body),
    );
    print(response.body);
  }
}

class Routes {
  static const signUp =
      "https://identitytoolkit.googleapis.com/v1/accounts:signInWithCustomToken?key=AIzaSyB-nDti492DhvIbuxLCt7HIbfEuQM6Koos";
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> signUp(String email, String password) async {
    String uri =
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyB-nDti492DhvIbuxLCt7HIbfEuQM6Koos";
    Map<String, dynamic> body = {
      "email": email,
      "password": password,
      "returnSecureToken": true,
    };

    http.Response response = await http.post(
      Uri.parse(uri),
      body: json.encode(body),
    );

    print(response.body);
    if (response.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ProfilePage(email: email)),
      );
    } else {
    }
  }

  Future<void> signIn(String email, String password) async {
    String uri =
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyB-nDti492DhvIbuxLCt7HIbfEuQM6Koos";
    Map<String, dynamic> body = {
      "email": email,
      "password": password,
      "returnSecureToken": true,
    };

    http.Response response = await http.post(
      Uri.parse(uri),
      body: json.encode(body),
    );

    print(response.body);
    if (response.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ProfilePage(email: email)),
      );
    } else {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Entrar'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  padding: EdgeInsets.all(20),
                  // Define o tamanho desejado do ícone
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey
                        .withOpacity(0.3), // Cor de fundo do container
                  ),
                  child: Icon(
                    Icons.account_circle,
                    size: 90, // Tamanho icone
                    color: Colors.grey, // Cor ícone
                  ),
                ),
              ),
              SizedBox(height: 40),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'E-mail',
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      String email = emailController.text;
                      String password = passwordController.text;
                      signIn(email, password);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD44E36),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(40.0),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 60,
                          vertical:
                              15),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      String email = emailController.text;
                      String password = passwordController.text;
                      signUp(email, password);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD44E36),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(40.0),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 60,
                          vertical:
                              15),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  final String email;

  const ProfilePage({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Perfil do Usuario'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    Colors.grey.withOpacity(0.3),
              ),
              child: Icon(
                Icons.account_circle,
                size: 90,
                color: Colors.grey,
              ),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              '$email',
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ],
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        resizeToAvoidBottomInset: false,
        body: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('cardapio')
                .doc('comidas')
                .get(),
            builder: (context, snapshot) {
              String nomeDoPrato = '';
              String valorDoPrato =
                  '';

              if (snapshot.connectionState == ConnectionState.done) {

                if (snapshot.hasData) {
                  nomeDoPrato = snapshot.data!.get('Nome');
                  valorDoPrato = snapshot.data!.get('Preco');
                } else {
                  nomeDoPrato = 'Nome do prato não disponível';
                  valorDoPrato = 'Nome do prato não disponível';
                }
              }

              return Stack(children: [
                Container(
                  color: Colors.white,
                ),
                const Positioned(
                  left: 16.0,
                  top: 110.0,

                  right: 80,
                  child: Text(
                    'Delicious food for you',
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Positioned(
                  left: 16.0,
                  top: 40.0,

                  child: IconButton(
                    icon: const Icon(
                      Icons.search,
                      size: 30,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const QuartaPagina()),
                      );
                    },
                  ),
                ),
                Positioned(
                  right: 35.0,
                  top: 250.0,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const QuartaPagina()),
                              );
                            },
                            decoration: const InputDecoration(
                              hintText: 'Search',
                              prefixIcon: Icon(
                                Icons.search,
                                size: 30,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 16.0,
                  top: 40.0,
                  child: IconButton(
                    icon: const Icon(
                      Icons.shopping_cart,
                      size: 30,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const QuintaPagina()),
                      );
                    },
                  ),
                ),
                Positioned(
                  left: 100.0,
                  bottom: 25.0,
                  child: IconButton(
                    icon: const Icon(
                      Icons.home,
                      size: 30,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const MyHomePage(),
                      ));
                    },
                  ),
                ),
                Positioned(
                  left: 150.0,
                  bottom: 25.0,
                  child: IconButton(
                    icon: const Icon(
                      Icons.favorite,
                      size: 30,
                      color: Colors.grey,
                    ),
                    onPressed: () {

                    },
                  ),
                ),
                Positioned(
                  left: 200.0,
                  bottom: 25.0,
                  child: IconButton(
                    icon: const Icon(
                      Icons.account_circle,
                      size: 30,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    },
                  ),
                ),
                Positioned(
                  left: 250,
                  bottom: 25.0,
                  child: IconButton(
                    icon: const Icon(
                      Icons.history,
                      size: 30,
                      color: Colors.grey,
                    ),
                    onPressed: () {

                    },
                  ),
                ),
                Positioned(
                  top: 310,
                  left: 50,
                  child: ElevatedButton(
                    onPressed: () {

                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      elevation: MaterialStateProperty.all<double>(0),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                      textStyle: MaterialStateProperty.all<TextStyle>(
                        const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    child: const Text(
                      'Foods',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFD44E36),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 310,
                  left: 150,
                  child: ElevatedButton(
                    onPressed: () {

                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      elevation: MaterialStateProperty.all<double>(0),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                      textStyle: MaterialStateProperty.all<TextStyle>(
                        const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    child: const Text(
                      'Drinks',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 310,
                  left: 250,
                  child: ElevatedButton(
                    onPressed: () {

                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      elevation: MaterialStateProperty.all<double>(0),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                      textStyle: MaterialStateProperty.all<TextStyle>(
                        const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    child: const Text(
                      'Snacks',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  bottom: 120.0,
                  right: 16.0,
                  child: CarouselSlider(
                    items: [
                      Container(
                        width: 350.0,
                        height: 350.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40.0),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1.0,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                              'https://cdn.discordapp.com/attachments/1144320039579816068/1155649798079262821/images-removebg-preview.png',
                              fit: BoxFit.contain,
                              height: 150,
                              width: 150,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const ThirdPage(),
                                ));
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                elevation: MaterialStateProperty.all<double>(0),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.black),
                                textStyle: MaterialStateProperty.all<TextStyle>(
                                  const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              child: Text(nomeDoPrato,
                                  textAlign: TextAlign.center),
                            ),
                            Text(
                              valorDoPrato,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFD44E36),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 350.0,
                        height: 350.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40.0),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1.0,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                              'https://cdn.discordapp.com/attachments/1144320039579816068/1155649798079262821/images-removebg-preview.png',
                              fit: BoxFit.contain,
                              height: 150,
                              width: 150,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const ThirdPage(),
                                ));
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                elevation: MaterialStateProperty.all<double>(0),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.black),
                                textStyle: MaterialStateProperty.all<TextStyle>(
                                  const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              child: Text(nomeDoPrato,
                                  textAlign: TextAlign.center),
                            ),
                            Text(
                              valorDoPrato,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFD44E36),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 350.0,
                        height: 350.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40.0),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1.0,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                              'https://cdn.discordapp.com/attachments/1144320039579816068/1155649798079262821/images-removebg-preview.png',
                              fit: BoxFit.contain,
                              height: 150,
                              width: 150,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const ThirdPage(),
                                ));
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                elevation: MaterialStateProperty.all<double>(0),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.black),
                                textStyle: MaterialStateProperty.all<TextStyle>(
                                  const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ), // tamanho da fonte como 20 pixels
                                ),
                              ),
                              child: Text(nomeDoPrato,
                                  textAlign: TextAlign.center),
                            ),
                            Text(
                              valorDoPrato,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFD44E36),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    options: CarouselOptions(
                      height: 280.0,
                      // Altura do carousel
                      aspectRatio: 16 / 9,
                      // Proporção de aspecto dos itens
                      viewportFraction: 0.5,
                      // Fração de visualização dos itens
                      initialPage: 0,
                      // Página inicial
                      enableInfiniteScroll: true,
                      // Rolagem infinita
                      reverse: false,
                      // Rolagem reversa
                      autoPlay: true,
                      // Reprodução automática
                      autoPlayInterval: const Duration(seconds: 3),
                      // Intervalo de reprodução automática
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      // Duração da animação de reprodução automática
                      autoPlayCurve: Curves.fastOutSlowIn,
                      // Curva de animação de reprodução automática
                      enlargeCenterPage: true,
                      // Ampliar a página central
                      scrollDirection:
                          Axis.horizontal, // Direção de rolagem (horizontal)
                    ),
                  ),
                ),
              ]);
            }));
  }
}
