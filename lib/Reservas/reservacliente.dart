
import 'package:cateringmid/Reservas/reservaubicacion.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; // Para trabajar con JSON
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cateringmid/Reservas/reservamodelo.dart';


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
      home: Reserva(id_empresa: '',),
      debugShowCheckedModeBanner: false,
        locale: const Locale('es', ''), 
    );
  }
}


class Reserva extends StatefulWidget  {
  const Reserva({super.key, required this.id_empresa});
  final String id_empresa;
  @override
  _ReservaState createState() => _ReservaState();


  
}


class _ReservaState extends State<Reserva> {
  final _formKey = GlobalKey<FormState>(); // Clave para el formulario
  final _usernameController = TextEditingController();
  final _userphoneController = TextEditingController();
  final _username2Controller =TextEditingController();
  final _userphone2Controller =TextEditingController();
  final _timeController = TextEditingController();
  ReservasProvider reserva =ReservasProvider();
  TextEditingController _userdateController = TextEditingController();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool isLoading = false;


  void _login() async {
    if (_formKey.currentState?.validate() ?? false) {
    print(widget.id_empresa);
    Provider.of<ReservasProvider>(context, listen: false)
    .actualizardatosclienter(
      _usernameController.text, 
      _userphoneController.text, 
      _username2Controller.text,
      _userphone2Controller.text,
      _userdateController.text,
      _timeController.text,
      
    );

    
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Reservaubicacion(id_empresa:widget.id_empresa ))); // Reemplaza `YourPage` con la página actual
    
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

  Future<void> _showCalendarDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog( // Usa un AlertDialog para el diálogo
        content: SizedBox( // Ajusta el tamaño del calendario
          width: 300,
          height: 400,
          child: TableCalendar(
            calendarFormat: _calendarFormat,
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2010, 1, 1),
            lastDay: DateTime.utc(2030, 12, 30),
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                _userdateController.text = DateFormat('yyyy-MM-dd').format(selectedDay); // Formatea la fecha
              });
              Navigator.pop(context); // Cierra el diálogo al seleccionar una fecha
            }, 
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          
        ),
      );
    },
  );
}
  
  Future<void> _selectTime(BuildContext context) async {
  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
    builder: (BuildContext context, Widget? child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
        child: child!,
      );
    },
  );

  if (picked != null) {
    setState(() {
        _timeController.text = picked.format(context); // Se actualiza la UI
      });
    print('Hora seleccionada: ${picked.format(context)}');
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
                const SizedBox(height: 50),
                _datoshora(),
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
              'Datos de Cliente', // Usamos la variable que corresponde a la empresa
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
        controller: _usernameController,
        decoration: const InputDecoration(
          labelText: 'Nombre del destinatario',
          border: UnderlineInputBorder(),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey), // Cambia el color de la línea inferior al enfocar
          ),
            suffixIcon: Icon(
            Icons.person,
            color :Color.fromARGB(255, 112, 110, 110), // Cambia el color si está enfocado
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor ingrese un nombre ';
          }
          return null;
        },
      ),
      const SizedBox(height: 20),
      TextFormField(
        controller: _userphoneController,
        keyboardType: TextInputType.phone,
        decoration: const InputDecoration(
          labelText: 'Teléfono del destinatario',
          border: UnderlineInputBorder(),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey), // Cambia el color de la línea inferior al enfocar
          ),
            suffixIcon: Icon(
            Icons.phone,
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
        controller: _username2Controller,
        decoration: const InputDecoration(
          labelText: 'Nombre del contacto adicional',
          border: UnderlineInputBorder(),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey), // Cambia el color de la línea inferior al enfocar
          ),
            suffixIcon: Icon(
            Icons.person,
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
        controller:  _userphone2Controller,
        keyboardType: TextInputType.phone,
        decoration: const InputDecoration(
          labelText: 'Teléfono alternativo',
          border: UnderlineInputBorder(),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey), // Cambia el color de la línea inferior al enfocar
          ),
            suffixIcon: Icon(
            Icons.phone,
            color :Color.fromARGB(255, 112, 110, 110), // Cambia el color si está enfocado
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor ingrese un telefono';
          }
          return null;
        },
      )
    ]
    );
  }
    Widget _datoshora()
  {
    return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
        Container(
          alignment: Alignment.center,
          child: Column(
            children: [
            Text(
              'Fecha y hora', // Usamos la variable que corresponde a la empresa
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF670A0A),
                  ),
            ), 
            
          ]),
        ), 
      const SizedBox(height: 20),
      InkWell( // Widget interactivo para mostrar la fecha
      onTap: () => _selectTime(context),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border(
          bottom: BorderSide(color: Colors.grey), // Solo borde inferior
        ),
        
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _timeController.text.isEmpty // Muestra un texto si no hay fecha seleccionada
                    ? 'Seleccionar hora'
                    : _timeController.text,
              ),
              
            ),
            const Icon(Icons.access_time_outlined,color :Color.fromARGB(255, 112, 110, 110)), // Cambia el color si está enfocado),
          ],
        ),
      ),
      ),
      const SizedBox(height: 20),
      InkWell( // Widget interactivo para mostrar la fecha
            onTap: () => _showCalendarDialog(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border(
          bottom: BorderSide(color: Colors.grey), // Solo borde inferior
        ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _userdateController.text.isEmpty // Muestra un texto si no hay fecha seleccionada
                    ? 'Seleccionar fecha'
                    : _userdateController.text,
              ),
            ),
            const Icon(Icons.calendar_today,color :Color.fromARGB(255, 112, 110, 110)), // Cambia el color si está enfocado),
          ],
        ),
      ),
      ),
    ]
    );
  }

}


