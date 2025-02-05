import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http; // Importar el paquete http
import 'dart:convert'; // Para trabajar con JSON

class Empresas {
  String nombre;
  String direccion;
  String telefono;
  String link_logo;
  int max_personas;
  int min_personas;
  String id_empresa;

  Empresas({
    required this.nombre,
    required this.direccion,
    required this.telefono,
    required this.link_logo,
    required this.max_personas,
    required this.min_personas,
    required this.id_empresa,
  });

  factory Empresas.fromJson(Map<String, dynamic> json) {
    return Empresas(
      nombre: json['nombre'],
      direccion: json['direccion'],
      telefono: json['telefono'],
      link_logo: json['link_logo'],
      max_personas: json['max_personas'],
      min_personas: json['min_personas'],
      id_empresa: json['id_empresa'],
    );
  }

  @override
  String toString() {
    return 'Empresa(nombre: $nombre, direccion: $direccion, telefono: $telefono, max_personas: $max_personas, min_personas: $min_personas, id_empresa: $id_empresa)';
  }
}

class Apiclass {
  List<Empresas> empresas = []; // Lista de empresas
  int pageNumber = 1;
  bool isLoading = false;
  bool hasMore = true;

  Future<void> fetchEmpresaData(int Number) async {
    if (isLoading || !hasMore) return;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      print('El token no está configurado o es inválido');
      return;
    }

    final headers = {'Authorization': 'Bearer $token'};

    try {
      isLoading = true;
      empresas.clear();

      final response = await http.get(
        Uri.parse(
          'https://cateringmid.azurewebsites.net/api/Empresa?pageNumber=$Number&pageSize=10&timestamp=${DateTime.now().millisecondsSinceEpoch}',
        ),
        headers: headers,
      );

      print('Response status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> data = jsonResponse['data'];
        empresas.clear();
        empresas.addAll(data.map((item) => Empresas.fromJson(item)).toList());
        print(empresas);
      } else if (response.statusCode == 401) {
        print('Token expirado, intentando renovar...');
        await _refreshToken();
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
    final refreshToken =
        prefs.getString('refresh_token'); // Almacena el refresh token

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
