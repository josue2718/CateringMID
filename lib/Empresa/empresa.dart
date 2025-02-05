import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cateringmid/Empresa/api_imagenes.dart';
import 'package:cateringmid/Empresa/api_menus.dart';
import 'package:cateringmid/Empresa/api_service.dart';
import 'package:cateringmid/Empresa/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import '../Reservas/selectmenu.dart';
import '../home/api_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data with Infinite Scroll',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 255, 255, 255)),
      ),
      home: CompanyPage(
        id_empresa: '1',
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CompanyPage extends StatefulWidget {
  final String id_empresa;

  // Constructor con ambos parámetros
  const CompanyPage({
    Key? key,
    required this.id_empresa,
  }) : super(key: key);

  @override
  _CompanyState createState() => _CompanyState();
}

class _CompanyState extends State<CompanyPage> {
  int _backPressedCount = 0; // Contador para el número de intentos de retroceso
  final Apiempresaclass apiempresaclass = Apiempresaclass(); // Instancia de Apiclass
  final Apiimagenes_Empresasclass apiimagen = Apiimagenes_Empresasclass();
   final Apimenuclass apimenu = Apimenuclass();
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<int> _currentIndexNotifier = ValueNotifier<int>(0);
 final Apiclass api = Apiclass(); // Instancia de Apiclass
  bool isLoading = false;
  bool hasMore = true;
  int pageNumber = 1;

  @override
  void initState() {
    super.initState();
    checkAndReload();
  }

  void checkAndReload() async {
    if (apiempresaclass.empresas.isEmpty) {
      pageNumber = 1;
      await apiempresaclass.fetchEmpresaIDData(widget.id_empresa);
      Future.delayed(Duration.zero, () {
        if (mounted) {
          setState(
              () {}); // Esto actualiza la UI sin romper la fase de construcción
        }
      });
      print('Recargando página porque no hay datos');
    }
  }

  @override
  void dispose() {
    _currentIndexNotifier.dispose(); // Libera el recurso
    _scrollController.dispose(); // Libera el controlador de scroll
    super.dispose();
  }

  Future<void> _onRefresh() async {
    setState(() {
      print('Actualizando datos...');
      pageNumber++;
      hasMore = true;
    });
  }

  // Función para cargar más datos de forma asíncrona
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

  String selectedDate = "Seleccione una fecha";

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(2000);
    DateTime lastDate = DateTime(2101);

    // Muestra el calendario flotante
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
     
    );

    if (picked != null && picked != initialDate) {
      setState(() {
        selectedDate = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: FutureBuilder(
          future: Future.wait([
            apiempresaclass.fetchEmpresaIDData(widget.id_empresa),
            apiimagen.fetchImagenEmpresaData(widget.id_empresa),
            apimenu.fetchMenusEmpresaData(widget.id_empresa)
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF670A0A),
                  backgroundColor: Color.fromARGB(255, 255, 255, 255),
                ),
              );
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: \${snapshot.error}'));
            }
            if (apiempresaclass.empresas.isEmpty) {
              
            }
            return Scaffold(
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              body: RefreshIndicator(
                onRefresh: _onRefresh,
                child: SingleChildScrollView(
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildCarouselempresa(),
                        _buildeempresa()
                      ],
                    ),
                  ),
                ),
              ),
               floatingActionButton: _button(),
            );
          },
        ),
        
      ),
    );
  }

Widget _buildCarouselempresa() {
    if (apiimagen.imagenes_Empresas.isNotEmpty);
    return CarouselSlider.builder(
      itemCount: apiimagen.imagenes_Empresas.length,
      itemBuilder: (context, index, realIndex) {
        final imagen = apiimagen.imagenes_Empresas[index];
        return imagenesempresa(
              link_imagen: imagen.link_imagen);
      },
      options: CarouselOptions(
        height: 350,
        viewportFraction: 1.0,
        enlargeCenterPage: false,
        enableInfiniteScroll: true,
        autoPlay: true,
        autoPlayInterval:
            const Duration(seconds: 2),
        autoPlayAnimationDuration:
            const Duration(milliseconds: 800),
        scrollDirection: Axis.horizontal,
        onPageChanged: (index, reason) {
          _currentIndexNotifier.value = index;
        },
      ),
    );
  }

Widget _buildeempresa()
{
  return ListView.builder(
  controller: _scrollController,
  itemCount: apiempresaclass.empresas.length +(isLoading ? 1 : 0),
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  itemBuilder: (context, index) {
    if (index < apiempresaclass.empresas.length) {
      final empresa = apiempresaclass.empresas[index];
      return Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          // Usamos un Column para mostrar las tarjetas verticalmente
          children: [
            nombreempresa(
              nombre: empresa.nombre,
              min: empresa.minPersonas,
              max: empresa.maxPersonas,
            ),
            propetario(
              link_logo: empresa.linkLogo,
              nombre: empresa.nombre,
            ),
            informacionempresa(
              link_logo: empresa.linkLogo,
              nombre: empresa.nombre,
              informacion: empresa.informacion,
              max: empresa.maxPersonas,
              id_emp: empresa.idEmpresa,
              mobiliario: empresa.mobiliario,
              blancos: empresa.blancos,
              personal: empresa.chef,
              cristaleria: empresa.cristaleria,
              meseros: empresa.meseros,
              vyl: empresa.vyl,
              ubicacion: empresa.direccion,
              horario: empresa.horario,
            ),
            Menuinfo( id_emp: empresa.idEmpresa,),
            Container(
              constraints: const BoxConstraints(
              maxWidth: 3300,
              maxHeight: 150, 
            ),
              margin: const EdgeInsets.symmetric(vertical: 5),
              decoration: const BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              shape: BoxShape.circle,
            ),
            child: //menu
              ListView.builder(
              scrollDirection: Axis.horizontal, // <-- Esta línea es la clave
              shrinkWrap: true, // Solo si es necesario
              itemCount: min(10, apimenu.menu.length),
              //physics: const NeverScrollableScrollPhysics(), // Descomentar para permitir scroll
              itemBuilder: (context, index) {
                if (index <  apimenu.menu.length) {
                  final menu =  apimenu.menu[index];
                  return  imagenesmenu(
                    link_imagen: menu.linkImagen,
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            )
            ),
            SizedBox(height: 30),
            
          ],
        ),
      );
    } else {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  },
);
}

Widget _button()
{
  return FloatingActionButton(
    //onPressed: () => _selectDate(context),
    onPressed: () {
          Navigator.push(
          context,
          MaterialPageRoute(
          builder: (context) => MenuSelectPage(id_empresa: widget.id_empresa),
          ));
        },
    
    backgroundColor:Color(0xFF670A0A) ,
    child: Icon(
      Icons.add_circle_outline_sharp ,
      color: Color.fromARGB(255, 255, 255, 255),
    ),
   );
}

}



class propetario extends StatelessWidget {
  propetario(
  {required this.link_logo,
  required this.nombre,});
  final String link_logo;
  final String nombre;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children : [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(120),
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: Image.network(
                    link_logo,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, object, stackTrace) {
                      return const Icon(Icons.error); // O una imagen de error
                    },
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'nombre', // Usamos la variable que corresponde a la empresa
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF670A0A),
                          ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Dueño del Catering',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 13,
                          ),
                    ),
                    const SizedBox(height: 1),
                  ],
                ),
              ),
            ],
          ),
          
        ]
      )
    );
  }
}

class informacionempresa extends StatelessWidget {
  informacionempresa(
      {required this.link_logo,
      required this.nombre,
      required this.informacion,
      required this.max,
      required this.id_emp,
      required this.ubicacion,
      required this.horario,
      this.mobiliario = false,
      this.blancos = false,
      this.personal = false,
      this.cristaleria = false,
      this.meseros = false,
      this.vyl = false});
  
  final String link_logo;
  final String nombre;
  final String informacion;
  final String ubicacion;
  final String horario;
  final int max;
  final String id_emp;
  final bool mobiliario;
  final bool blancos;
  final bool personal;
  final bool cristaleria;
  final bool meseros;
  final bool vyl;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 const SizedBox(height: 15),
                Container(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                    Icon(
                      Icons.access_time_outlined,
                      color: Color.fromARGB(246, 134, 129, 120),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      horario,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color.fromARGB(246, 134, 129, 120),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]),
                ),
                 const SizedBox(height: 10),
                Container(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: Color.fromARGB(246, 134, 129, 120),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      ubicacion,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color.fromARGB(246, 134, 129, 120),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]),
                ),
                
                const SizedBox(height: 15),
                Text(
                  'Informacion', // Usamos la variable que corresponde a la empresa
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF670A0A),
                      ),
                ),
                const SizedBox(height: 5),
                Text(
                  informacion,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 13,
                      ),
                ),
                const SizedBox(height: 15),
                Text(
                  '¿Que servicios ofrecemos?', // Usamos la variable que corresponde a la empresa
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF670A0A),
                      ),
                ),
                const SizedBox(height: 5),
                Text(
                  informacion,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 15,
                      ),
                ),
                const SizedBox(height: 5),
                Container(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                    Icon(
                      Icons.table_bar,
                      color: Color.fromARGB(246, 134, 129, 120),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Mobiliario',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color.fromARGB(246, 134, 129, 120),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                    Icon(
                      Icons.person,
                      color: Color.fromARGB(246, 134, 129, 120),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Blancos',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color.fromARGB(246, 134, 129, 120),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                    Icon(
                      Icons.person,
                      color: Color.fromARGB(246, 134, 129, 120),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Personal',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color.fromARGB(246, 134, 129, 120),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                    Icon(
                      Icons.wine_bar,
                      color: Color.fromARGB(246, 134, 129, 120),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Cristaleria',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color.fromARGB(246, 134, 129, 120),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                    Icon(
                      Icons.person,
                      color: Color.fromARGB(246, 134, 129, 120),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Negros',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color.fromARGB(246, 134, 129, 120),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height: 1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class nombreempresa extends StatelessWidget {
  nombreempresa(
      {
      required this.nombre,
      required this.min,
      required this.max,
      });


  final String nombre;
  final int min;
  final int max;


  @override
  Widget build(BuildContext context) {
    return Padding(
      
      padding: const EdgeInsets.all(10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            nombre,
            style: const TextStyle(
              fontSize: 30,
              color: Color(0xFF6A77E2E),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Container(
          alignment: Alignment.topLeft,
          child: Row(
            children: [
            Icon(
              Icons.groups_sharp,
              color: Color.fromARGB(246, 134, 129, 120),
            ),
            SizedBox(width: 10),
            Text(
              '$min a $max Personas',
              style: const TextStyle(
                fontSize: 13,
                color: Color.fromARGB(246, 134, 129, 120),
                fontWeight: FontWeight.bold,
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}

class imagenesempresa extends StatelessWidget {
  imagenesempresa({required this.link_imagen});
  final String link_imagen;

  @override
  Widget build(BuildContext context) {

  return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(30.0),
        bottomRight: Radius.circular(30.0),
      ), child: SizedBox(
      child: Image.network(
        link_imagen,
        fit: BoxFit.cover,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) return child;
          return Center();
        },
        errorBuilder: (context, object, stackTrace) {
          return const Icon(Icons.error); // O una imagen de error
        },
      ),
    )
  );
  }
}

class Menuinfo extends StatelessWidget {
  Menuinfo(
      { required this.id_emp});
  final String id_emp;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children:[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                    Text(
                      'Menus y Cartas', // Usamos la variable que corresponde a la empresa
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF670A0A),
                          ),
                    ), 
                    const SizedBox(width: 10),
                    Container(
                    width: 100,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(10)),
                    alignment: Alignment.topCenter,
                    child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MenuPage(id_empresa: id_emp),
                        ),
                      );
                    },
                    child:
                      Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                      
                      Container(width: 10),
                      Text(
                        'Ver mas',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color.fromARGB(246, 105, 96, 96),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                    ]),
                  )),
                  ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class imagenesmenu extends StatelessWidget {
    imagenesmenu({required this.link_imagen});
  final String link_imagen;

  @override
  Widget build(BuildContext context) {
    return Padding(
      
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical:0 ),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: const Color.fromARGB(255, 255, 255, 255),
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
          child: InkWell(
            onTap: () {
              /*Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CompanyPage(id_empresa: id_emp),
                ),
              );*/
            },
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      width: 120,
                      height: 200,
                      child: Image.network(
                        link_imagen,
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, object, stackTrace) {
                          return const Icon(
                              Icons.error); // O una imagen de error
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}