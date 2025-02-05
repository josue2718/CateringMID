import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Importar el paquete http
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'dart:convert'; // Para trabajar con JSON
import '../cache.dart';
import '../home/home.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget  {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CateringMID',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: Createaccount(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Createaccount extends StatefulWidget {
  const Createaccount({super.key});

  @override
  _AcocountState createState() => _AcocountState();
}

class _AcocountState extends State<Createaccount> {
  final _formKey = GlobalKey<FormState>(); // Clave para el formulario
  final _usernameController = TextEditingController(); // Controlador para el nombre de usuario
  final _userfirtsnameController = TextEditingController(); // Controlador para el nombre de usuario
  final _passwordController = TextEditingController(); // Controlador para la contraseña
  final _confirmPasswordControlle = TextEditingController();
  final _usercelphoneController = TextEditingController();
  final _useremailController= TextEditingController();
  final _userRFCController = TextEditingController();

  bool _isObscured = true; // Estado para alternar visibilidad de contraseña
  bool _isObscured2 = true; // Estado para alternar visibilidad de contraseña
  // Método para verificar los campos y hacer login

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

  void _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Mostrar un indicador de carga mientras se hace la solicitud
      showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator(color:  const Color(0xFF670A0A), backgroundColor: Color.fromARGB(255, 255, 255, 255)));
        },
      );

      try {
        // Realizar la solicitud POST
        final response = await http.post(
          Uri.parse('https://cateringmid.azurewebsites.net/api/Cliente'), // Cambia esta URL por la de tu API
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
              "email": _useremailController.text,
              "password": _passwordController.text,
              "nombre": _usernameController.text,
              "apellido": _userfirtsnameController.text,
              "telefono": _usercelphoneController.text,
              "latitud": 0,
              "longitud": 0,
              "link_imagen": "string",
              "rfc": _userRFCController.text,
          }),
        );
        print(response.statusCode);

        // Cerrar el indicador de carga
        Navigator.pop(context);

        // Verificar la respuesta de la API
        if (response.statusCode == 201) {
          final data = json.decode(response.body);

          // Suposición de que la API devuelve un 'token' en caso de éxito
          if (data != null && data['id_cliente'] != null) {
            // Si recibimos un token, el login fue exitoso
            await _saveToken(data['token'],true,data['id_cliente']);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyHomePage(), // Asegúrate de importar la clase HomePage
              ),
            );
          } else {
            // Credenciales incorrectas
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Credenciales incorrectas')),
            );
          }
        } else {
          // Error en la respuesta de la API
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al intentar crear cuenta')),
          );
        }
      } catch (e) {
        // Captura cualquier excepción que ocurra durante la solicitud
        Navigator.pop(context); // Cerrar el indicador de carga
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error de conexión')),
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
          'Registrarse',
          textAlign: TextAlign.center, // Asegura que el texto esté centrado
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
              // Campo de texto para el nombre de usuario
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: UnderlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre de usuario';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller:  _userfirtsnameController,
                decoration: const InputDecoration(
                  labelText: 'Apellido',
                  border: UnderlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un Apellido de usuario';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _usercelphoneController,
                decoration: const InputDecoration(
                  labelText: 'Telefono',
                  border: UnderlineInputBorder(),
                ),
                 keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un Telefono de usuario';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _useremailController,
                decoration: const InputDecoration(
                  labelText: 'Correo',
                  border: UnderlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un Correo de usuario';
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
                  labelText: 'Contraseña',
                  border: const UnderlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscured ? Icons.visibility : Icons.visibility_off,
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
              const SizedBox(height: 20),
              TextFormField(
                controller: _confirmPasswordControlle,
                obscureText: _isObscured2, // Usa el estado para alternar visibilidad
                decoration: InputDecoration(
                  labelText: 'Confirmar contraseña',
                  border: const UnderlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscured2 ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscured2 = !_isObscured2; // Cambia el estado al presionar el ícono
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor confirme su contraseña';
                  } else if (value != _passwordController.text) {
                    return 'Las contraseñas no coinciden';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _userRFCController,
                decoration: const InputDecoration(
                  labelText: 'RFC',
                  border: UnderlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su RFC';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
             TextButton.icon(
              onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyHomePage(), // Usa id_cliente aquí si es necesario
                    ),
                  );
                },
              icon: Icon(
                 Icons.location_on ,
                 size: 20,
                color: const Color(0xFF670A0A), // Color del ícono
              ),
              label: const Text(
                'Ubicacion',
                style: TextStyle(
                  fontSize: 17,
                  color: const Color(0xFF670A0A), // Color del texto
                ),
              ),
            ),

              const SizedBox(height: 30),
              // Botón de login
              ElevatedButton(
                onPressed:  _login, // Usa id_cliente aquí si es necesari
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(300, 50), // Ancho fijo de 250 y alto de 50
                    backgroundColor:  const Color(0xFF670A0A),
                    foregroundColor: const Color.fromARGB(255, 240, 239, 239),
                  
                ),
                child: const Text('Registrarme'),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      ),
      ),
    );
  }
}
