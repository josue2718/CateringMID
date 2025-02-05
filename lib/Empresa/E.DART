import 'package:cateringmid/home/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import '../menu despegable/menudespegable.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data with Infinite Scroll',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 255, 255, 255)),
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (_) => MyHomePage(),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ScrollController _scrollController = ScrollController();
  int _backPressedCount = 0; // Contador para el número de intentos de retroceso

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Incrementar el contador cada vez que se presiona el botón de retroceso
        _backPressedCount++;

        if (_backPressedCount == 1) {
          // Si es el primer intento, mostrar un mensaje indicando que deben presionar nuevamente
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Presione nuevamente para salir')),
          );

          // Esperar 2 segundos antes de restablecer el contador
          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              _backPressedCount = 0; // Restablecer contador
            });
          });

          // Evitar que la app se cierre de inmediato
          return Future.value(false);
        } else {
          // Si ya fue presionado dos veces, cerrar la aplicación
          SystemNavigator.pop(); // Cierra la aplicación
          return Future.value(true); // Permite que se cierre la aplicación
        }
      },
      child: KeyboardDismisser(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Home'),
            backgroundColor: const Color(0xFF670A0A),
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            toolbarHeight: 70,
            actions: [
              TextButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Notificaciones')),
                  );
                },
                icon: const Icon(
                  Icons.notifications,
                  color: Colors.white,
                  size: 30,
                ),
                label: Text(''),
              ),
            ],
          ),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          drawer: const CustomDrawer(),
          body: const bodyhome(),
        ),
      ),
    );
  }
}


class bodyhome extends StatelessWidget {
  const bodyhome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Column(  // Usa Column para poner los widgets uno debajo del otro
          mainAxisAlignment: MainAxisAlignment.center,  // Opcional, para centrar los elementos
          children: [
            CircleListItem(),
            SizedBox(height: 20),  // Espacio entre los dos widgets
            EmpresaScreen(),
          ],
        ),
      )
    );
  }
}

class CircleListItem extends StatelessWidget {
  const CircleListItem({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Container(
        width: 500,
        height: 54,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          shape: BoxShape.circle,
        ),
        
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Padding(
            padding: const EdgeInsets.only(right: 25),
            child: ClipOval(
              child: Image.network(
                'https://docs.flutter.dev/cookbook'
                '/img-files/effects/split-check/Avatar1.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          
        ],
        ),
      ),
    );
  }
}


class EmpresaScreen extends StatefulWidget {
  @override
  _EmpresaScreenState createState() => _EmpresaScreenState();
}

class _EmpresaScreenState extends State<EmpresaScreen> {
  final Apiclass api = Apiclass(); // Instancia de Apiclass
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent && !isLoading) {
        fetchMoreData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Función para cargar más datos de forma asíncrona
  void fetchMoreData() async {
    if (isLoading) return; // Si ya estamos cargando, no hacer nada más

    setState(() {
      isLoading = true;
    });

    try {
      await api. refreshData(); // Llama a la API para obtener más datos
    } catch (e) {
      print("Error al cargar más datos: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: RefreshIndicator(
        backgroundColor: const Color.fromARGB(255, 201, 58, 58),
        onRefresh: () async {
          await api.refreshData(); // Llama a la API y reinicia los datos al refrescar
        },
        child: FutureBuilder(
          future: api.fetchEmpresaData(), // Llama a la API inicialmente
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting && api.empresas.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (api.empresas.isEmpty) {
              return const Center(child: Text('No hay empresas disponibles.'));
            }

            return ListView.builder(
              controller: _scrollController, // Controlador para manejar el scroll infinito
              itemCount: api.empresas.length + (isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < api.empresas.length) {
                  final empresa = api.empresas[index];
                  return Card(
                    elevation: 18,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: const Color.fromARGB(255, 201, 58, 58),
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            empresa.nombre,
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}

