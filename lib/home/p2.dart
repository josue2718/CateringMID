
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cateringmid/home/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import '../Empresa/empresa.dart';
import '../menu despegable/CustomDrawer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data with Infinite Scroll',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 255, 255, 255)),
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

Container(
          width: 190,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 185, 33, 33),
                borderRadius: BorderRadius.circular(10)),
            alignment: Alignment.topCenter,
            child: TextButton(
              onPressed: () {print('calendar');},
              child:
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                const Icon(
                  Icons.calendar_month,
                  color: Color.fromARGB(255, 255, 252, 252),
                  size: 30,
                ),
                Container(width: 10),
                Text(
                  'Fechas disponibles',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color.fromARGB(246, 255, 255, 255),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
              ]),
            )),




final Set<DateTime> _specialDays = {
    DateTime.now().add(const Duration(days: 2)), // Día especial en 2 días
    DateTime.now().add(const Duration(days: 5)), // Otro día especial en 5 días
    DateTime(2025, 1 , 23), // Un día especial específico
  };

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
          
           calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  // Color por defecto
                  return Center(child: Text(day.day.toString()));
                },
                selectedBuilder: (context, day, focusedDay) {
                  // Color para el día seleccionado
                  return Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 243, 33, 33), // Color de selección
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        day.day.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
                todayBuilder: (context, day, focusedDay) {
                  // Color para el día actual
                  return Center(
                    child: Container(
                      width: 500,
                      decoration: const BoxDecoration(
                        color: Colors.green, // Color de hoy
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        day.day.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
                outsideBuilder: (context, day, focusedDay) {
                  // Color para los días fuera del mes actual
                  return Center(
                    child: Text(
                      day.day.toString(),
                      style: const TextStyle(color: Color.fromARGB(255, 204, 14, 14)),
                    ),
                  );
                },

                // Color para los días especiales
                markerBuilder: (context, day, events) {

                  if (_specialDays.contains(day)) {
                    return Center(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.red, // Color de días especiales
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          day.day.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }
                  return null; // Devolver null para usar el builder por defecto
                },
              ),
          )
        ),
      );
    },
  );
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageScreenState createState() => _MyHomePageScreenState();
}

class _MyHomePageScreenState extends State<MyHomePage> {

  int _backPressedCount = 0; // Contador para el número de intentos de retroceso
  final Apiclass api = Apiclass(); // Instancia de Apiclass
  final ScrollController _scrollController = ScrollController();
   final ValueNotifier<int> _currentIndexNotifier = ValueNotifier<int>(0);
  bool isLoading = false;
  int _currentIndex = 0;
bool hasMore = true;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent && !isLoading) {
        fetchMoreData();
      }
    });
  }
  @override
  void dispose() {
    _currentIndexNotifier.dispose(); // Asegúrate de liberar el recurso
  _scrollController.dispose();
  super.dispose();
    
  }
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!isLoading && hasMore) {
        print('hola');
      }
    }
  }

  Future<void> _onRefresh() async {
    setState(() {
      print('actualizando');
      api.refreshData();
      hasMore = true;
    });

  }



  // Función para cargar más datos de forma asíncrona
  void fetchMoreData() async {
    if (isLoading) return; // Si ya estamos cargando, no hacer nada más

    setState(() {
      isLoading = true;
    });

    try {
      await api. refreshData(); // Llama a la API para obtener más datos
    } catch (e) {
      print("Error al cargar más datos: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
Widget build(BuildContext context) {
  return WillPopScope(
    onWillPop: () async {
      // Manejo del botón de retroceso
      _backPressedCount++;
      if (_backPressedCount == 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Presione nuevamente para salir')),
        );
        
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            _backPressedCount = 0; // Restablecer contador
          });
        });
        return Future.value(false); // No cerrar la app aún
      } else {
        SystemNavigator.pop(); // Cerrar la app
        return Future.value(true);
      }
    },
    child: KeyboardDismisser(
      child: Scaffold(
        drawer: const CustomDrawer(),
        appBar: AppBar(
          title: const Text('HOME'),
          backgroundColor: const Color(0xFF670A0A),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          toolbarHeight: 90,
          actions: [
            TextButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notificaciones')),
                );
              },
              icon: const Icon(
                Icons.notifications,
                color: Colors.white,
                size: 30,
              ),
              label: Text(''),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  FutureBuilder(
                    future: api.Data(), // Llama a la API
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: const Color.fromARGB(255, 167, 127, 46),
                            backgroundColor: Color.fromARGB(255, 255, 255, 255),
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      if (api.empresas.isEmpty) {
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                        });
                      }
                      return Column(
                        children: [
                          // Título de Ofertas de Hoy
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Ofertas de Hoy',
                              style: TextStyle(
                                fontSize: 25,
                                color: const Color(0xFF670A0A),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                          width: 400, // Ajusta el ancho del carrusel
                          child: Column(
                            children: [
                              if (api.empresas.isNotEmpty)
                              
                               CarouselSlider.builder(
                                itemCount: api.empresas.length,
                                itemBuilder: (context, index, realIndex) {
                                  final empresa = api.empresas[index];
                                  return Container(
                                    width: 260,
                                    child:  cardsofertas(link_imagen: empresa.link_logo)
                                  );
                                },
                                options: CarouselOptions(
                                  height: 150,
                                  enlargeCenterPage: true,
                                  enableInfiniteScroll: true,
                                  autoPlay: true,
                                  autoPlayInterval: Duration(seconds: 4),
                                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                                  scrollDirection: Axis.horizontal,
                                  onPageChanged: (index, reason) {
                                    _currentIndexNotifier.value = index; // Actualiza el índice en el ValueNotifier
                                  },
                                ),
                              ),
                               const SizedBox(height: 30),
                              // ValueListenableBuilder para escuchar cambios en _currentIndexNotifier
                              ValueListenableBuilder<int>(
                                valueListenable: _currentIndexNotifier,
                                builder: (context, currentIndex, child) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                      api.empresas.length,
                                      (index) => AnimatedContainer(
                                        duration: Duration(milliseconds: 300),
                                        margin: EdgeInsets.symmetric(horizontal: 2),
                                        width: currentIndex == index ? 16 : 8,
                                        height: currentIndex == index ? 16 : 8,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: currentIndex == index ? Color(0xFF670A0A) : Colors.grey,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              
                              if (api.empresas.isEmpty)
                                    Center(
                                      child: Text('No hay empresas disponibles.'),
                                    ),
                             
                              
                        ])
                          ),
                           
                          const SizedBox(height: 30),

                          // Título de Especialidades
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              'Especialidades',
                              style: TextStyle(
                                fontSize: 25,
                                color: const Color(0xFF670A0A),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 0),
                          options(),
                          const SizedBox(height: 0),

                          // Título de Caterings
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Caterings',
                              style: TextStyle(
                                fontSize: 25,
                                color: const Color(0xFF670A0A),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 0),

                          // Lista de Caterings
                          ListView.builder(
                            controller: _scrollController,
                            itemCount: api.empresas.length + (isLoading ? 1 : 0),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              if (index < api.empresas.length) {
                                final empresa = api.empresas[index];
                                return CardsEmpresa(
                                  link_logo: empresa.link_logo,
                                  nombre: empresa.nombre,
                                  min: empresa.min_personas,
                                  max: empresa.max_personas,
                                  id_emp: empresa.id_empresa,
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
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
}


class CardsEmpresa extends StatelessWidget {
  CardsEmpresa({required this.link_logo,required this.nombre,required this.min,required this.max,required this.id_emp});
  final String link_logo;
  final String nombre;
  final int min;
  final int max;
  final String id_emp;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: const Color.fromARGB(255, 255, 255, 255),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
       child: InkWell(
        onTap: () {
          Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CompanyPage(id_empresa : id_emp),
                ),
              );
        },
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 120,
              height: 120,
              child: Image.network(
                link_logo ,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 30),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nombre, // Usamos la variable que corresponde a la empresa
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        
                      ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Especialidades: ', // Mostramos el teléfono de la empresa
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 13,
                      ),
                ),
                  const SizedBox(height: 1),
                Text(
                  'Minimimo: ${min} y Maximo ${max}', // Mostramos el teléfono de la empresa
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 13,
                      ),
                ),
              ],
            ),
          ),
          ],
        ),
      ),
       )
    );
  }
}

class cardsofertas extends StatelessWidget
{
  cardsofertas({required this.link_imagen});
  final String link_imagen;

  @override
  Widget build(BuildContext context) {
   return 
     ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
          
              child: Image.network(
                link_imagen ,
                 fit: BoxFit.cover,
              ),
            ),
          
    );

  }
}

class options extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      width: 330,
      height: 120,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
        shape: BoxShape.circle,
      ),
      child: ListView(
      scrollDirection: Axis.horizontal,
      children: <Widget>[
          Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Column(
            children: [
              
              ClipOval(
                child: Image.network(
                  'https://docs.flutter.dev/cookbook/img-files/effects/split-check/Avatar1.jpg',
                  fit: BoxFit.cover,
                  width: 70, // Ajusta el ancho según tus necesidades
                  height: 70, //
                ),
              ),
              const SizedBox(height: 20), // Espacio entre la imagen y el texto
              Text('Tu texto aquí'),
            ],
          ),
        ),
          Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Column(
            children: [
              
              ClipOval(
                child: Image.network(
                  'https://docs.flutter.dev/cookbook/img-files/effects/split-check/Avatar1.jpg',
                  fit: BoxFit.cover,
                  width: 70, // Ajusta el ancho según tus necesidades
                  height: 70, //
                ),
              ),
              const SizedBox(height: 20), // Espacio entre la imagen y el texto
              Text('Tu texto aquí'),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Column(
            children: [
              
              ClipOval(
                child: Image.network(
                  'https://docs.flutter.dev/cookbook/img-files/effects/split-check/Avatar1.jpg',
                  fit: BoxFit.cover,
                  width: 70, // Ajusta el ancho según tus necesidades
                  height: 70, //
                ),
              ),
              const SizedBox(height: 20), // Espacio entre la imagen y el texto
              Text('Tu texto aquí'),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Column(
            children: [
              ClipOval(
                child: Image.network(
                  'https://docs.flutter.dev/cookbook/img-files/effects/split-check/Avatar1.jpg',
                  fit: BoxFit.cover,
                  width: 70, // Ajusta el ancho según tus necesidades
                  height: 70, //
                ),
              ),
              const SizedBox(height: 20), // Espacio entre la imagen y el texto
              Text('Tu texto aquí'),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Column(
            children: [
              ClipOval(
                child: Image.network(
                  'https://docs.flutter.dev/cookbook/img-files/effects/split-check/Avatar1.jpg',
                  fit: BoxFit.cover,
                  width: 70, // Ajusta el ancho según tus necesidades
                  height: 70, //
                ),
              ),
              const SizedBox(height: 20), // Espacio entre la imagen y el texto
              Text('Tu texto aquí'),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Column(
            children: [
              ClipOval(
                child: Image.network(
                  'https://docs.flutter.dev/cookbook/img-files/effects/split-check/Avatar1.jpg',
                  fit: BoxFit.cover,
                  width: 70, // Ajusta el ancho según tus necesidades
                  height: 70, //
                ),
              ),
              const SizedBox(height: 20), // Espacio entre la imagen y el texto
              Text('Tu texto aquí'),
            ],
          ),
        ),
      ]
    ),
    );
  }
}