import 'dart:async';
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cateringmid/Reservas/reservacliente.dart';
import 'package:cateringmid/Reservas/reservamodelo.dart';
import 'package:cateringmid/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:provider/provider.dart';
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
      home: confrimacionreserva(
        id_empresa: '1',
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class confrimacionreserva extends StatefulWidget {
  final String id_empresa;
  // Constructor con ambos parámetros
  const confrimacionreserva({
    Key? key,
    required this.id_empresa,
  }) : super(key: key);

  @override
  _confrimacionreserva createState() => _confrimacionreserva();
}

class _confrimacionreserva extends State<confrimacionreserva> {
  int _backPressedCount = 0; // Contador para el número de intentos de retroceso
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<int> _currentIndexNotifier = ValueNotifier<int>(0);
  final ReservaMenu reservamenu = ReservaMenu();

  ReservasProvider reserva =ReservasProvider();
  bool isLoading = false;
  bool hasMore = true;
  int pageNumber = 1;
  
  bool personalizar = false;

  @override
  void initState() {
    super.initState();
  }

void _login() async {
    reserva.enviarReserva(empresa :widget.id_empresa ,context: context); 

 
 
  }


  

  @override
  void dispose() {
    _currentIndexNotifier.dispose(); // Libera el recurso
    _scrollController.dispose(); // Libera el controlador de scroll
    super.dispose();
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
              body: SingleChildScrollView(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    child: Column(

                      children: [
                        const SizedBox(height: 10),
                        _title(),
                        const SizedBox(height: 10),
                        
                        infoentrega(),
                        infocliente(),
                        _title2(),
                        const SizedBox(height: 10),
                        _menus(),
                        const SizedBox(height: 30),
                        _button(),
                         const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              );
          },
        ),
      ),
    );
  }

Widget _menus()
{
  return ListView.builder(
    itemCount: reservamenu.menu.length +(isLoading ? 1 : 0),
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemBuilder: (context, index) {
      if (index < reservamenu.menu.length) {
        final menu = reservamenu.menu[index];
          return CustomerCart(
          link_imagen: menu.linkImagen,
          nombre : menu.nombre,
          
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

}

Widget _button()
{
return ElevatedButton(
                
  onPressed: () {
    _login();
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
      const Text('Reservar'),
    ],
  ),
  );
}

Widget _title()
{
  return Text(
    'Confirmar datos', // Usamos la variable que corresponde a la empresa
    style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Color(0xFF670A0A),
        ),
  );
}

Widget _title2()
{
  return Text(
    'Menus seleccionados', // Usamos la variable que corresponde a la empresa
    style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF670A0A),
        ),
  );
}

}
class infoentrega extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final reservasProvider = Provider.of<ReservasProvider>(context, listen: false);
  return Padding(
    padding: const EdgeInsets.all(10),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(
                'Datos de entrega', // Usamos la variable que corresponde a la empresa
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF670A0A),
                    ),
              ),
                const SizedBox(height: 15),
              Container(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                  Icon(
                    Icons.access_time_outlined,
                    color: Color.fromARGB(246, 134, 129, 120),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Hora del evento: ${reservasProvider.hora!}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color.fromARGB(246, 134, 129, 120),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 10),
              Container(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                  Icon(
                    Icons.calendar_today,
                    color: Color.fromARGB(246, 134, 129, 120),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Fecha del evento: ${reservasProvider.fecha!}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color.fromARGB(246, 134, 129, 120),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 10),
              Container(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: Color.fromARGB(246, 134, 129, 120),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Direccion: ${reservasProvider.calle!}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color.fromARGB(246, 134, 129, 120),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                ]),
              ),
              const SizedBox(height: 10),
              Container(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                  Icon(
                    Icons.home,
                    color: Color.fromARGB(246, 134, 129, 120),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Nombre del lugar: ${reservasProvider.nombreLugar!}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color.fromARGB(246, 134, 129, 120),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                ]),
              ),
              const SizedBox(height: 5)
            ],
          ),
        ),
      ],
    ),
  );
}
}


class infocliente extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final reservasProvider = Provider.of<ReservasProvider>(context, listen: false);
  return Padding(
    padding: const EdgeInsets.all(10),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(
                'Datos de cliente', // Usamos la variable que corresponde a la empresa
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF670A0A),
                    ),
              ),
                const SizedBox(height: 15),
              Container(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                  Icon(
                    Icons.person,
                    color: Color.fromARGB(246, 134, 129, 120),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Nombre del destinatario: ${reservasProvider.primerNombre!}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color.fromARGB(246, 134, 129, 120),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 10),
              Container(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                  Icon(
                    Icons.phone,
                    color: Color.fromARGB(246, 134, 129, 120),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Teléfono del destinatario: ${reservasProvider.primerTelefono!}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color.fromARGB(246, 134, 129, 120),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 10),
              Container(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                  Icon(
                    Icons.person,
                    color: Color.fromARGB(246, 134, 129, 120),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Nombre del contacto adicional: ${reservasProvider.segundoNombre!}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color.fromARGB(246, 134, 129, 120),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                ]),
              ),
              const SizedBox(height: 10),
              Container(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                  Icon(
                    Icons.phone,
                    color: Color.fromARGB(246, 134, 129, 120),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Teléfono alternativo: ${reservasProvider.segundoTelefono!}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color.fromARGB(246, 134, 129, 120),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                ]),
              ),
              const SizedBox(height: 5)
            ],
          ),
        ),
      ],
    ),
  );
}
}


class CustomerCart extends StatelessWidget {
    CustomerCart({
      required this.link_imagen,
      required this.nombre,
    });

  final String link_imagen;
  final String nombre;


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
                      width: 80,
                      height: 80,
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
                                  maxLines: 2, // Ajusta el número de líneas según sea necesario
                              ),
                            ),
                          ]
                        ),
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

