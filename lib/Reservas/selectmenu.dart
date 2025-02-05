import 'dart:async';
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cateringmid/Reservas/reservacliente.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import '../Empresa/api_imagenes.dart';
import '../Empresa/api_menus.dart';
import '../Empresa/api_service.dart';
import '../home/afertas.dart';
import '../home/api_service.dart';

import 'reservamenu.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data with Infinite Scroll',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 255, 255, 255)),
      ),
      home: MenuSelectPage(
        id_empresa: '1',
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MenuSelectPage extends StatefulWidget {
  final String id_empresa;
  // Constructor con ambos parámetros
  const MenuSelectPage({
    Key? key,
    required this.id_empresa,
  }) : super(key: key);

  @override
  _selectmenu createState() => _selectmenu();
}

class _selectmenu extends State<MenuSelectPage> {
  int _backPressedCount = 0; // Contador para el número de intentos de retroceso
  final Apiempresaclass apiempresaclass =Apiempresaclass(); // Instancia de Apiclass
  final Apiclassdesucuentos apides = Apiclassdesucuentos();
  final ScrollController _scrollController = ScrollController();
  final Apiimagenes_Empresasclass apiimagen = Apiimagenes_Empresasclass();
  final ValueNotifier<int> _currentIndexNotifier = ValueNotifier<int>(0);
  final Apimenuclass apimenu = Apimenuclass();
  final ReservaMenu reservamenu = ReservaMenu();
 final Apiclass api = Apiclass(); // Instancia de Apiclass
  bool isLoading = false;
  bool hasMore = true;
  int pageNumber = 1;
  
  bool personalizar = false;

  @override
  void initState() {
    super.initState();
    checkAndReload();
  }

  void checkAndReload() async {
      Future.delayed(Duration.zero, () {
        if (mounted) {
          setState(
              () {}); // Esto actualiza la UI sin romper la fase de construcción
        }
      });

      print('Recargando página porque no hay datos');
    }
  

  @override
  void dispose() {
    _currentIndexNotifier.dispose(); // Libera el recurso
    _scrollController.dispose(); // Libera el controlador de scroll
    super.dispose();
  }

  Future<void> _onRefresh() async {
    setState(() {
      print('Actualizando datos...');
      pageNumber++;
      hasMore = true;
    });
  }

  // Función para cargar más datos de forma asíncrona
  void fetchMoreData() async {
    if (isLoading) return; // Si ya estamos cargando, no hacer nada más

    setState(() {
      isLoading = true;
    });

    try {} catch (e) {
      print("Error al cargar más datos: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: FutureBuilder(
          future: Future.wait([

          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF670A0A),
                  backgroundColor: Color.fromARGB(255, 255, 255, 255),
                ),
              );
            }
            return Scaffold(
              appBar: AppBar(
            title: const Text('Reservacion'),
            backgroundColor: const Color(0xFF670A0A),
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            toolbarHeight: 90,),
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              body: RefreshIndicator(
                onRefresh: _onRefresh,
                child: SingleChildScrollView(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Menuinfo(),
                        const SizedBox(height: 10),//MENU
                         
                        ListView.builder(
                          itemCount: reservamenu.menu.length +(isLoading ? 1 : 0),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            if (index < reservamenu.menu.length) {
                              final menu = reservamenu.menu[index];
                               return CustomerCart(
                                idEmpresa:  menu.idEmpresa,
                                idMenuEmpresa: menu.idMenuEmpresa,
                                link_imagen: menu.linkImagen,
                                nombre : menu.nombre,
                                min : menu.minPersonas,
                                max : menu.maxPersonas,
                                precio: menu.precio,
                                
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
                        ),

                        const SizedBox(height: 30),
                         ElevatedButton(
                
                  onPressed: () {
                    print(widget.id_empresa);
                    Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Reserva(id_empresa:widget.id_empresa ))); // Reemplaza `YourPage` con la página actual
                    },
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(300, 50), // Ancho fijo de 250 y alto de 50
                    backgroundColor:  const Color(0xFF670A0A),
                    foregroundColor: const Color.fromARGB(255, 240, 239, 239),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Continuar'),
                    ],
                  ),
                  
              ),
              const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class CustomerCart extends StatelessWidget {
    CustomerCart({
      required this.idEmpresa,
      required this.idMenuEmpresa,
      required this.link_imagen,
      required this.nombre,
      required this.min,
      required this.max,
      required this.precio
    });
  final String idEmpresa;
  final String idMenuEmpresa;
  final String link_imagen;
  final String nombre;
  final int min;
  final int max;
  final double precio;
    final ReservaMenu reservamenu = ReservaMenu();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical:0 ),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1),
          ),
          color: const Color.fromARGB(255, 255, 255, 255),
          margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 0),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      width: 110,
                      height: 100,
                      child: Image.network(
                        link_imagen,
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, object, stackTrace) {
                          return const Icon(
                              Icons.error); // O una imagen de error
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 200,
                              child:
                                Text(
                                  nombre,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                  maxLines: 2, 
                              ),
                            ),
                            const Spacer(),

                            IconButton(
                            onPressed: () {
                              print('calendar');
                              reservamenu.eliminarPorId(context,idMenuEmpresa);
                               Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => MenuSelectPage(id_empresa: idEmpresa,)), // Reemplaza `YourPage` con la página actual
                              );
                            },
                            icon: const Icon(Icons.remove ), // Usa un icono de calendario
                            color: const Color(0xFF670A0A),
                            iconSize: 35, // Usa iconSize en lugar de size
                          ),
                          ]
                        ),
                        Row
                        (children: [
                          Icon(
                            Icons.groups_sharp ,
                           color: Color.fromARGB(197, 112, 103, 103),
                            size:25,
                          ),
                          SizedBox(width: 10),
                          Text(
                            '$min a $max personas',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color.fromARGB(197, 112, 103, 103),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ]),
                        SizedBox(height: 2),
                         Row
                        (children: [
                          Icon(
                            Icons.room_service ,
                           color: Color.fromARGB(197, 112, 103, 103),
                            size:25,
                          ),
                          SizedBox(width: 10),
                          Text(
                           'Precio: \$${precio}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color.fromARGB(197, 112, 103, 103),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ]),
                        SizedBox(height: 5),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}


class Menuinfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                    Text(
                      'Menus', // Usamos la variable que corresponde a la empresa
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF670A0A),
                          ),
                    ), 
                    const SizedBox(width: 10),
                  ]),
                ),
              ],
            ),
          );
  }
}
