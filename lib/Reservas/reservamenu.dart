
import 'package:flutter/material.dart';
import 'dart:convert';

class Menus {
  String idMenuEmpresa;
  String idEmpresa;
  String nombre;
  String linkImagen;
  double precio;
  int minPersonas;
  int maxPersonas;

  Menus({
    required this.idMenuEmpresa,
    required this.idEmpresa,
    required this.nombre,
    required this.linkImagen,
    required this.precio,
    required this.minPersonas,
    required this.maxPersonas,
  });

  @override
  String toString() {
    return 'Menus(idMenuEmpresa: $idMenuEmpresa, idEmpresa: $idEmpresa, nombre: $nombre, precio: $precio, minPersonas: $minPersonas, maxPersonas: $maxPersonas)';
  }
}

class Menusreservas {
  String idMenuEmpresa;

  Menusreservas({
    required this.idMenuEmpresa,
  });
   Map<String, dynamic> toJson() => {"id_menu_empresa": idMenuEmpresa}; 
  @override
  String toString() {
    return 'Menusreserva(idMenuEmpresa: $idMenuEmpresa)';
  }
}

class ReservaMenu {
  static final ReservaMenu _instance = ReservaMenu._internal();
  factory ReservaMenu() {
    return _instance;
  }
  ReservaMenu._internal();
  final List<Menus> _menu = [];
  List<Menus> get menu => _menu;
  final List<Menusreservas> _menureserva = [];
  List<Menusreservas> get menureserva => _menureserva;



  // Agregar menú, ahora recibe el contexto para mostrar el SnackBar
  void add({
    required BuildContext context, // Agregar parámetro de contexto
    required String idMenuEmpresa,
    required String idEmpresa,
    required String nombre,
    required String linkImagen,
    required double precio,
    required int minPersonas,
    required int maxPersonas,
  }) {
    if (_menu.any((m) => m.idMenuEmpresa == idMenuEmpresa)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ya está añadido'),
          duration: const Duration(seconds: 1), 
          backgroundColor: Color(0xFF670A0A),
        ),
      );
      return;
    }

    final newMenu = Menus(
      idMenuEmpresa: idMenuEmpresa,
      idEmpresa: idEmpresa,
      nombre: nombre,
      linkImagen: linkImagen,
      precio: precio,
      minPersonas: minPersonas,
      maxPersonas: maxPersonas,
    );

final newMenureserva = Menusreservas(
      idMenuEmpresa: idMenuEmpresa,

    );
    _menureserva.add(newMenureserva);
    _menu.add(newMenu);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Menú agregado'),
        backgroundColor: Color(0xFF670A0A),
        duration: const Duration(seconds: 1), 
      ),
    );

    print('✅ Nuevo menú agregado: $newMenureserva');
  }

  // Eliminar menú por ID, también recibe el contexto para mostrar el SnackBar
  void eliminarPorId(BuildContext context, String idMenuEmpresa) {
    int index = _menu.indexWhere((menu) => menu.idMenuEmpresa == idMenuEmpresa);
     int index1 = _menureserva.indexWhere((menureserva) => menureserva.idMenuEmpresa == idMenuEmpresa);

    if (index != -1) {
      _menu.removeAt(index);
      _menureserva.removeAt(index1);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Menú eliminado'),
          backgroundColor: Color(0xFF670A0A),
          duration: const Duration(seconds: 1), 
        ),
      );
       
    
      print('✅ Menú con ID $idMenuEmpresa eliminado correctamente.');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Menú no encontrado'),
          backgroundColor: Color(0xFF670A0A),
        ),
      );
      print('⚠️ No se encontró un menú con ID $idMenuEmpresa');
    }
  }
}
