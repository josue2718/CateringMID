
import 'package:flutter/material.dart';

import '../Ubicaciones/ubicacion.dart';
import '../home/home.dart';
import '../main.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF670A0A),
            ),
            child: Text(
              'Hola',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: Text(
              'Home',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black,
                  ),
            ),
            onTap: () {
                          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MyHomePage()),
              (Route<dynamic> route) => false, // Elimina todas las pantallas anteriores de la pila
            );
            
            },
          ),
          ListTile(
            title: Text(
              'Añadir Ubicacion',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black,
                  ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Createdireccion(),
                ),
              );
            },
          ),
          ListTile(
            title: Text(
              'Cerrar Sesión',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black,
                  ),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MyHomePage1(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
