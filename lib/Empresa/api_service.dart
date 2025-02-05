import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http; // Importar el paquete http
import 'dart:convert'; // Para trabajar con JSON

class Empresa {
  String idEmpresa;
  String idPropietario;
  String nombre;
  String email;
  String telefono;
  String direccion;
  double latitud;
  double longitud;
  bool menusPersonalizado;
  bool mobiliario;
  bool blancos;
  bool personal;
  bool cristaleria;
  bool chef;
  bool meseros;
  bool vyl;
  int minPersonas;
  int maxPersonas;
  String informacion;
  String horario;
  String linkFacebook;
  String linkInstagram;
  String linkLogo;

  Empresa({
    required this.idEmpresa,
    required this.idPropietario,
    required this.nombre,
    required this.email,
    required this.telefono,
    required this.direccion,
    required this.latitud,
    required this.longitud,
    required this.menusPersonalizado,
    required this.mobiliario,
    required this.blancos,
    required this.personal,
    required this.cristaleria,
    required this.chef,
    required this.meseros,
    required this.vyl,
    required this.minPersonas,
    required this.maxPersonas,
    required this.informacion,
    required this.horario,
    required this.linkFacebook,
    required this.linkInstagram,
    required this.linkLogo,
  });

  factory Empresa.fromJson(Map<String, dynamic> json) {
    return Empresa(
      idEmpresa: json['id_empresa'],
      idPropietario: json['id_propietario'],
      nombre: json['nombre'],
      email: json['email'],
      telefono: json['telefono'],
      direccion: json['direccion'],
      latitud: json['latitud'].toDouble(),
      longitud: json['longitud'].toDouble(),
      menusPersonalizado: json['menus_personalizado'],
      mobiliario: json['mobiliario'],
      blancos: json['blancos'],
      personal: json['personal'],
      cristaleria: json['cristaleria'],
      chef: json['chef'],
      meseros: json['meseros'],
      vyl: json['vyl'],
      minPersonas: json['min_personas'],
      maxPersonas: json['max_personas'],
      informacion: json['informacion'],
      horario: json['horario'],
      linkFacebook: json['link_facebook'],
      linkInstagram: json['link_instagram'],
      linkLogo: json['link_logo'],
    );
  }

  @override
  String toString() {
    return 'Empresa(nombre: $nombre, direccion: $direccion, telefono: $telefono, max_personas: $maxPersonas, min_personas: $minPersonas, id_empresa: $idEmpresa)';
  }
}



class Apiempresaclass {
  List<Empresa> empresas = [];  // Lista de empresas
  int pageNumber = 1;
  bool isLoading = false;
  bool hasMore = true;

  Future<void> fetchEmpresaIDData(String id_empresa) async {
  if (isLoading || !hasMore) return;

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  if (token == null || token.isEmpty) {
    print('El token no está configurado o es inválido');
    return;
  }

  final headers = {
    'Authorization': 'Bearer $token',
  };

  try {
    isLoading = true;
    final response = await http.get(
      Uri.parse(
        'https://cateringmid.azurewebsites.net/api/Empresa/${id_empresa}',
      ),
      headers: headers,
    );

    print('Response status code: ${response.statusCode}');
    if (response.statusCode == 200) {

      final jsonResponse = json.decode(response.body);

empresas.clear();
empresas.add(Empresa.fromJson(jsonResponse)); // Solo una empresa

      print(empresas);
    } else if (response.statusCode == 401) {
      print('Token expirado, intentando renovar...');
      await _refreshToken(); // Intenta renovar el token
     
    } else {
      throw Exception('Error al cargar datos: ${response.statusCode}');
    }
  } catch (e) {
    print('Error al obtener datos: $e');
  } finally {
    isLoading = false;
  }
}


Future<void> _refreshToken() async {
  final prefs = await SharedPreferences.getInstance();
  final refreshToken = prefs.getString('refresh_token'); // Almacena el refresh token

  if (refreshToken == null) {
    print('No se encontró el refresh token');
    return;
  }

  final response = await http.post(
    Uri.parse('https://cateringmid.azurewebsites.net/api/auth/refresh'),
    body: {'refresh_token': refreshToken},
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final newToken = data['access_token'];

    await prefs.setString('token', newToken);
    print('Token renovado con éxito');
  } else {
    print('Error al renovar token: ${response.statusCode}');
  }
}


 
 

}


