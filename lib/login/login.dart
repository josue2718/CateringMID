
import 'package:cateringmid/login/Createaccount.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Importar el paquete http
import 'dart:convert'; // Para trabajar con JSON
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../cache.dart';
import '../home/home.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';

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
        useMaterial3: false,


      ),
      home: Login(),
      debugShowCheckedModeBanner: false,
    );
  }
}


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}
class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>(); // Clave para el formulario
  final _usernameController = TextEditingController(); // Controlador para el nombre de usuario
  final _passwordController = TextEditingController(); // Controlador para la contraseña
  bool _isObscured = true; // Estado para alternar visibilidad de contraseña
  final PreferencesService _preferencesService = PreferencesService(); // Instancia del servicio
  String? _token;
  bool? _inicio;
  String? _id;

  Future<void> _saveToken(String token, bool inicio, String id) async {
      await _preferencesService.savePreferences(token, inicio, id);
      setState(() {
        _token = token;
        _inicio = inicio;
        _id = id;
      });
    }

  // Método para verificar los campos y hacer login
  void _login() async {
  if (_formKey.currentState?.validate() ?? false) {
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

    int attempts = 0;
    const int maxAttempts = 6;
    http.Response? response;

    while (attempts < maxAttempts) {
      try {
        response = await http
            .post(
              Uri.parse('https://cateringmid.azurewebsites.net/api/AuthClient/login'),
              headers: {'Content-Type': 'application/json'},
              body: json.encode({
                'email': _usernameController.text,
                'password': _passwordController.text,
              }),
            )
            .timeout(Duration(seconds: 1)); // Aumentar tiempo de espera

        if (response.statusCode == 200) {
          break; // Éxito, salir del bucle
        }
         if (response.statusCode == 400) {
          ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Credenciales incorrectas'),backgroundColor: Color(0xFF670A0A)),
        );
          break; // Éxito, salir del bucle
        }
      } catch (e) {
        print('Error en intento ${attempts + 1}: $e');
      }
      
      attempts++;
      if (attempts < maxAttempts) {
        await Future.delayed(Duration(seconds: 3)); // Espera antes de reintentar
      }
    }

    Navigator.pop(context); // Cerrar el indicador de carga

    if (response != null && response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data != null && data['token'] != null) {
        await _saveToken(data['token'], true, data['idCliente']);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Credenciales incorrectas'),backgroundColor: Color(0xFF670A0A)),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error de red'),backgroundColor: Color(0xFF670A0A)),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: Scaffold(
      appBar: AppBar(
       title: const Text(
      'Iniciar sesión',textAlign: TextAlign.center,
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      centerTitle: true,
      toolbarHeight: 70,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade300, // Color de la sombra
              width: 3.0, // Grosor de la línea
            ),
          ),
        ),
      ),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
     resizeToAvoidBottomInset: true, 
      body:  SingleChildScrollView(
        child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Image.asset(
                'assets/LOGOROJO.png',
                height: 250, // Ajusta la altura de la imagen
                width: 410, // Ajusta el ancho de la imagen
                ),
              // Campo de texto para el nombre de usuario
              const SizedBox(height: 20),
              TextFormField(
                controller: _usernameController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Correo',
                  border: UnderlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey), // Cambia el color de la línea inferior al enfocar
                  ),
                    suffixIcon: Icon(
                    Icons.email,
                    color :Color.fromARGB(255, 112, 110, 110), // Cambia el color si está enfocado
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre de usuario';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Campo de texto para la contraseña
              TextFormField(
                controller: _passwordController,
                obscureText: _isObscured, // Usa el estado para alternar visibilidad
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey), // Cambia el color de la línea inferior al enfocar
                  ),
                  labelText: 'Contraseña',
                  border: const UnderlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscured ? Icons.visibility : Icons.visibility_off,
                      color :Color.fromARGB(255, 83, 81, 81),
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscured = !_isObscured; // Cambia el estado al presionar el ícono
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una contraseña';
                  }
                  return null;
                },
              ),
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
                      const Text('Iniciar sesión '),
                    ],
                  ),
              ),
              const SizedBox(height: 20),
              // Botón de registro
              TextButton(
                onPressed: () {
                  // Acción para navegar a la pantalla de registro
                 Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Createaccount()),);
                },
                style: ElevatedButton.styleFrom(
                    
                    foregroundColor: const Color(0xFF670A0A),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('¿No tienes cuenta? Regístrate'),
                    ],
                  ),
                
              ),
            ],
          ),
        ),
      ),
      ),
      ),
    );
  }
}
