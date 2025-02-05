
import 'package:cateringmid/Reservas/confirmacion.dart';
import 'package:cateringmid/Reservas/reservacliente.dart';
import 'package:cateringmid/Reservas/reservamodelo.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; // Para trabajar con JSON
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CateringMID',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 255, 255, 255)),
        useMaterial3: true,
      ),
      home: Reservaubicacion(id_empresa: '',),
      debugShowCheckedModeBanner: false,
        locale: const Locale('es', ''), 
    );
  }
}


class Reservaubicacion extends StatefulWidget  {
  const Reservaubicacion({super.key, required this.id_empresa});
  final String id_empresa;
  @override
  _ReservaubicacionState createState() =>_ReservaubicacionState();


  
}


class _ReservaubicacionState  extends State<Reservaubicacion> {
  final _formKey = GlobalKey<FormState>(); // Clave para el formulario
  final _usercalleController = TextEditingController();
  final _usernamelocalController = TextEditingController();
  final _usernumberController =TextEditingController();
  final _userreferensController =TextEditingController();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool isLoading = false;
 
  
  void _login() async {
 if (_formKey.currentState?.validate() ?? false) {
Provider.of<ReservasProvider>(context, listen: false)
    .actualizarDireccion(
      _usercalleController.text,
      _usernamelocalController.text,
     _usernumberController.text,
     _userreferensController.text

    );
  
  Navigator.push(
      context,
     MaterialPageRoute(builder: (context) => confrimacionreserva(id_empresa:widget.id_empresa ))); // Reemplaza `YourPage` con la página actual
  }
  }
  
  
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
      appBar: AppBar(
            title: const Text('Reservacion'),
            backgroundColor: const Color(0xFF670A0A),
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            toolbarHeight: 90,
            
          ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
     resizeToAvoidBottomInset: true, 
      body:  SingleChildScrollView(
        child: Padding(
        padding: const EdgeInsets.all(30),
        child: Form(
          key: _formKey,
          child: Column(
              children: [
                _datosentrega(),

              const SizedBox(height: 70),
              // Botón de login
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(300, 50), // Ancho fijo de 250 y alto de 50
                    backgroundColor:  const Color(0xFF670A0A),
                    foregroundColor: const Color.fromARGB(255, 240, 239, 239),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Siguiente'),
                    ],
                  ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      )
    )
  ); 
  }


  Widget _datosentrega()
  {
    return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
        Container(
          alignment: Alignment.center,
          child: Column(
            children: [
            Text(
              'Datos de entrega', // Usamos la variable que corresponde a la empresa
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF670A0A),
                  ),
            ), 
            
          ]),
        ), 
      const SizedBox(height: 20),
      TextFormField(
        controller: _usercalleController,
        decoration: const InputDecoration(
          labelText: 'Calle/colonia',
          border: UnderlineInputBorder(),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey), // Cambia el color de la línea inferior al enfocar
          ),
            suffixIcon: Icon(
            Icons.home,
            color :Color.fromARGB(255, 112, 110, 110), // Cambia el color si está enfocado
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor ingrese un telefono';
          }
          return null;
        },
      ),
      const SizedBox(height: 20),
      TextFormField(
        controller: _usernamelocalController,
        decoration: const InputDecoration(
          labelText: 'Nombre del lugar',
          border: UnderlineInputBorder(),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey), // Cambia el color de la línea inferior al enfocar
          ),
            suffixIcon: Icon(
            Icons.home,
            color :Color.fromARGB(255, 112, 110, 110), // Cambia el color si está enfocado
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor ingrese un nombre';
          }
          return null;
        },
      ),
      const SizedBox(height: 20),
      TextFormField(
        controller:  _usernumberController,
        decoration: const InputDecoration(
          labelText: 'Numero de casa/local',
          border: UnderlineInputBorder(),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey), // Cambia el color de la línea inferior al enfocar
          ),
            suffixIcon: Icon(
            Icons.home,
            color :Color.fromARGB(255, 112, 110, 110), // Cambia el color si está enfocado
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor ingrese un telefono';
          }
          return null;
        },
      ),
      const SizedBox(height: 20),
      TextFormField(
        controller:  _userreferensController,
        decoration: const InputDecoration(
          labelText: 'Referencias',
          border: UnderlineInputBorder(),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey), // Cambia el color de la línea inferior al enfocar
          ),
            suffixIcon: Icon(
            Icons.home,
            color :Color.fromARGB(255, 112, 110, 110), // Cambia el color si está enfocado
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor ingrese una referencia';
          }
          return null;
        },
      )
    ]
    );
  }


}


