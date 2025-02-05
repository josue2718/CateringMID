import 'dart:convert';
import 'package:cateringmid/Reservas/reservamenu.dart';
import 'package:cateringmid/home/home.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class ReservasProvider with ChangeNotifier {
  String? fecha;
  String? hora;
  String horas = '';
  String? contrato;
  String? primerNombre;
  String? segundoNombre;
  String? primerTelefono;
  String? segundoTelefono;
  bool enviado = true;
  bool aceptado = false;
  bool pago = false;
  bool preparando = false;
  bool enviando = false;
  bool completado = false;
  double? latitud;
  double? longitud;
  String? calle;
  String? nombreLugar;
  String? numCasa;
  String? referencias;

  // Método para actualizar los datos del cliente
  void actualizardatosclienter(String nombre1, String nombre2, String telefono1, String telefono2, String nuevaFecha, String nuevaHora) {
    fecha = nuevaFecha;
    hora = nuevaHora;
    primerNombre = nombre1;
    segundoNombre = nombre2;
    primerTelefono = telefono1;
    segundoTelefono = telefono2;
    notifyListeners();
  }

  // Método para actualizar la dirección
  void actualizarDireccion(String calleNueva, String nombreLugarNuevo, String numCasaNuevo, String referenciasNueva) {
    calle = calleNueva;
    nombreLugar = nombreLugarNuevo;
    numCasa = numCasaNuevo;
    referencias = referenciasNueva;
    notifyListeners();
  }

  // Método para imprimir los datos
  void printdato() {
    print('nombreLugar: $nombreLugar');
    print('primerNombre: $primerNombre');
    print('segundoNombre: $segundoNombre');
    print('primerTelefono: $primerTelefono');
    print('segundoTelefono: $segundoTelefono');
    print('calle: $calle');
    print('numCasa: $numCasa');
    print('referencias: $referencias');
    print('HORA: $hora');
  }

  // Método para enviar la reserva
  Future<void> enviarReserva({required String empresa, required BuildContext context}) async {
    // Obtén los datos del proveedor antes de realizar la solicitud
    final reservasProvider = Provider.of<ReservasProvider>(context, listen: false);
    ReservaMenu reserva = ReservaMenu();
    final prefs = await SharedPreferences.getInstance();
    final id_cliente = prefs.getString('id');

    // Verifica que id_cliente no sea nulo antes de usarlo
    if (id_cliente == null) {
      print("El ID del cliente es nulo"); 
      return; // Evita enviar la solicitud si el id_cliente es nulo
    }

   

    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF670A0A),
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
          ),
        );
      },
    );
  

    reservasProvider.printdato(); // Asegúrate de que se impriman los datos correctos

    final url = Uri.parse('https://cateringmid.azurewebsites.net/api/Reservas');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "id_cliente": id_cliente,
        "id_empresa": empresa,
        "fecha":'2025-02-03T16:00:32.515Z',
        "hora": '${reservasProvider.hora}:00',
        "costo": 0,
        "horas":'20:00:00',
        "contrato": reservasProvider.contrato ?? "string",
        "menu_Reservas":  reserva.menureserva.map((menu) => menu.toJson()).toList(),

        "reserva_Info_Clientes": [
          {
            "primer_nombre": reservasProvider.primerNombre ?? "",
            "segundo_nombre": reservasProvider.segundoNombre ?? "",
            "primer_telefono": reservasProvider.primerTelefono ?? "",
            "segundo_telefono": reservasProvider.segundoTelefono ?? ""
          }
        ],
        "estatus_Reservas": [
          {
            "enviado": reservasProvider.enviado,
            "aceptado": reservasProvider.aceptado,
            "pago": reservasProvider.pago,
            "preparando": reservasProvider.preparando,
            "enviando": reservasProvider.enviando,
            "completado": reservasProvider.completado
          }
        ],
        "reserva_direccions": [
          {
            "latitud": reservasProvider.latitud ?? 0,
            "longitud": reservasProvider.longitud ?? 0,
            "calle": reservasProvider.calle ?? "",
            "nombre_lugar": reservasProvider.nombreLugar ?? "",
            "num_casa": reservasProvider.numCasa ?? "",
            "referencias": reservasProvider.referencias ?? ""
          }
        ]
      }),
    );

    // Verifica la respuesta
    if (response.statusCode == 201) {
      print('Reserva enviada correctamente');
      Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) {
        return  Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical:200 ),
              child : Card(
                color: const Color.fromARGB(255, 255, 255, 255),
            child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Image.asset(
                  'assets/LOGOROJO.png',
                    errorBuilder: (context, object, stackTrace) {
                      return const Icon(Icons.error);
                    },
                  ),
                ),
              ),
              SizedBox(height: 50),
                    Text(
                      'RESERVA ENVIADA',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF670A0A),
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                     SizedBox(height: 10),
                    Text(
                      'Espera tu confirmación',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 50),
                  TextButton(
                onPressed: () {

                 Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage()),);
                },
               style: ElevatedButton.styleFrom(
                    fixedSize: const Size(250, 50), // Ancho fijo de 250 y alto de 50
                    backgroundColor:  const Color(0xFF670A0A),
                    foregroundColor: const Color.fromARGB(255, 240, 239, 239),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Regresar'),
                    ],
                  ),
                
              ),                
                
            ]
            )
            )
            
              
        );
 }
 );
  

    } else {
      print('Error al enviar la reserva: ${response.body}');
    }
  }
}
