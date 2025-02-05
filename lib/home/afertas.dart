import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http; // Importar el paquete http
import 'dart:convert'; // Para trabajar con JSON

class Descuentos {
  String idDescuento;
  String idEmpresa;
  String descripcion;
  String linkImagen;
  int cantidad;
  int porcentaje;
  DateTime fechaInicio;
  String horaInicio;
  DateTime fechaFin;
  String horaFin;
  DateTime fechaCreacion;

  Descuentos({
    required this.idDescuento,
    required this.idEmpresa,
    required this.descripcion,
    required this.linkImagen,
    required this.cantidad,
    required this.porcentaje,
    required this.fechaInicio,
    required this.horaInicio,
    required this.fechaFin,
    required this.horaFin,
    required this.fechaCreacion,
  });

  factory Descuentos.fromJson(Map<String, dynamic> json) {
    return Descuentos(
      idDescuento: json['id_descuento'],
      idEmpresa: json['id_empresa'],
      descripcion: json['descripcion'],
      linkImagen: json['link_imagen'],
      cantidad: json['cantidad'],
      porcentaje: json['porcentaje'],
      fechaInicio: DateTime.parse(json['fecha_inicio']),
      horaInicio: json['hora_inicio'],
      fechaFin: DateTime.parse(json['fecha_fin']),
      horaFin: json['hora_fin'],
      fechaCreacion: DateTime.parse(json['fecha_creacion']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_descuento': idDescuento,
      'id_empresa': idEmpresa,
      'descripcion': descripcion,
      'link_imagen': linkImagen,
      'cantidad': cantidad,
      'porcentaje': porcentaje,
      'fecha_inicio': fechaInicio.toIso8601String(),
      'hora_inicio': horaInicio,
      'fecha_fin': fechaFin.toIso8601String(),
      'hora_fin': horaFin,
      'fecha_creacion': fechaCreacion.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Descuentos(idDescuento: $idDescuento, idEmpresa: $idEmpresa, descripcion: $descripcion, cantidad: $cantidad, porcentaje: $porcentaje, fechaInicio: $fechaInicio, horaInicio: $horaInicio, fechaFin: $fechaFin, horaFin: $horaFin, fechaCreacion: $fechaCreacion)';
  }
}



class Apiclassdesucuentos {
  List<Descuentos> descuentos = [];  // Lista de empresas
  
  bool isLoading = false;
  bool hasMore = true;

  Future<void> fetchDescuentosData() async {
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
      descuentos.clear();
      
      final response = await http.get(
        Uri.parse(
          'https://cateringmid.azurewebsites.net/api/Descuentos',
        ),
        headers: headers,
      );

      print('Response status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body); // Decodifica como una lista
        descuentos.clear();
        descuentos.addAll(jsonResponse.map((item) => Descuentos.fromJson(item)).toList());
        print(descuentos);
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


