import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/routes.dart';
import '../../../core/services/theme_service.dart';
import '../../widgets/pet_card.dart';
import '../../widgets/report_card.dart';
import '../../widgets/service_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  
  // Lista de pantallas para el bottom navigation bar
  final List<Widget> _screens = [
    const _HomeContent(),
    const _SearchContent(),
    const _ReportContent(),
    const _ForumContent(),
    const _ProfileContent(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Buscar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Reportar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum),
            label: 'Foro',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

// Contenido de la pantalla de inicio
class _HomeContent extends StatelessWidget {
  const _HomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            floating: true,
            title: const Text('MascotaSOS - Ica'),
            actions: [
              // Botón para cambiar tema
              IconButton(
                icon: Icon(
                  Provider.of<ThemeService>(context).isDarkMode
                      ? Icons.light_mode
                      : Icons.dark_mode,
                ),
                onPressed: () {
                  Provider.of<ThemeService>(context, listen: false).toggleTheme();
                },
              ),
              // Botón de notificaciones
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  // Implementar pantalla de notificaciones
                },
              ),
            ],
          ),
          
          // Contenido principal
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Banner principal
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '¡Bienvenido a MascotaSOS!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Ayudando a las mascotas de Ica',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, AppRoutes.reportForm, arguments: 'perdido');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Theme.of(context).colorScheme.primary,
                            ),
                            child: const Text('Reportar mascota perdida'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Sección de mascotas perdidas recientes
                  _buildSectionHeader(
                    context,
                    'Mascotas perdidas recientes',
                    () => Navigator.pushNamed(context, AppRoutes.reportsList),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 220,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5, // Simulación de datos
                      itemBuilder: (context, index) {
                        // Aquí se cargarán los datos reales desde Firebase
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: ReportCard(
                            imageUrl: 'https://via.placeholder.com/150',
                            title: 'Mascota perdida ${index + 1}',
                            location: 'Ica, Perú',
                            date: DateTime.now().subtract(Duration(days: index)),
                            type: 'perdido',
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.reportDetail,
                                arguments: 'report_id_$index',
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Sección de adopciones
                  _buildSectionHeader(
                    context,
                    'Adopciones disponibles',
                    () => Navigator.pushNamed(context, AppRoutes.adoptionsList),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 220,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5, // Simulación de datos
                      itemBuilder: (context, index) {
                        // Aquí se cargarán los datos reales desde Firebase
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: PetCard(
                            imageUrl: 'https://via.placeholder.com/150',
                            name: 'Mascota ${index + 1}',
                            age: '${index + 1} años',
                            gender: index % 2 == 0 ? 'Macho' : 'Hembra',
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.adoptionDetail,
                                arguments: 'adoption_id_$index',
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Sección de servicios cercanos
                  _buildSectionHeader(
                    context,
                    'Servicios cercanos',
                    () => Navigator.pushNamed(context, AppRoutes.servicesMap),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5, // Simulación de datos
                      itemBuilder: (context, index) {
                        // Tipos de servicios alternados
                        final types = ['veterinaria', 'refugio', 'tienda'];
                        final type = types[index % 3];
                        
                        // Aquí se cargarán los datos reales desde Firebase
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: ServiceCard(
                            name: 'Servicio ${index + 1}',
                            type: type,
                            distance: '${(index + 1) * 0.5} km',
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.serviceDetail,
                                arguments: 'service_id_$index',
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: onTap,
          child: const Text('Ver todos'),
        ),
      ],
    );
  }
}

// Contenido de la pantalla de búsqueda
class _SearchContent extends StatelessWidget {
  const _SearchContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barra de búsqueda
            TextField(
              decoration: InputDecoration(
                hintText: 'Buscar mascotas, servicios, etc.',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
              ),
            ),
            const SizedBox(height: 24),
            
            // Categorías de búsqueda
            const Text(
              'Categorías',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Grid de categorías
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildCategoryCard(
                    context,
                    'Mascotas perdidas',
                    Icons.search,
                    Colors.red,
                    () => Navigator.pushNamed(
                      context,
                      AppRoutes.reportsList,
                    ),
                  ),
                  _buildCategoryCard(
                    context,
                    'Mascotas encontradas',
                    Icons.pets,
                    Colors.green,
                    () => Navigator.pushNamed(
                      context,
                      AppRoutes.reportsList,
                    ),
                  ),
                  _buildCategoryCard(
                    context,
                    'Adopciones',
                    Icons.favorite,
                    Colors.purple,
                    () => Navigator.pushNamed(
                      context,
                      AppRoutes.adoptionsList,
                    ),
                  ),
                  _buildCategoryCard(
                    context,
                    'Servicios',
                    Icons.local_hospital,
                    Colors.blue,
                    () => Navigator.pushNamed(
                      context,
                      AppRoutes.servicesMap,
                    ),
                  ),
                  _buildCategoryCard(
                    context,
                    'Guías de cuidado',
                    Icons.book,
                    Colors.orange,
                    () => Navigator.pushNamed(
                      context,
                      AppRoutes.guides,
                    ),
                  ),
                  _buildCategoryCard(
                    context,
                    'Foro comunitario',
                    Icons.forum,
                    Colors.teal,
                    () => Navigator.pushNamed(
                      context,
                      AppRoutes.forum,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[800]
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 40,
                color: color,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Contenido de la pantalla de reporte
class _ReportContent extends StatelessWidget {
  const _ReportContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
            const Text(
              '¿Qué quieres reportar?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Selecciona una opción para continuar',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            
            // Opciones de reporte
            _buildReportOption(
              context,
              'Mascota perdida',
              'Reporta una mascota que se ha perdido',
              Icons.search,
              Colors.red,
              () => Navigator.pushNamed(
                context,
                AppRoutes.reportForm,
                arguments: 'perdido',
              ),
            ),
            const SizedBox(height: 16),
            _buildReportOption(
              context,
              'Mascota encontrada',
              'Reporta una mascota que has encontrado',
              Icons.pets,
              Colors.green,
              () => Navigator.pushNamed(
                context,
                AppRoutes.reportForm,
                arguments: 'encontrado',
              ),
            ),
            const SizedBox(height: 16),
            _buildReportOption(
              context,
              'Mascota en adopción',
              'Publica una mascota para darla en adopción',
              Icons.favorite,
              Colors.purple,
              () => Navigator.pushNamed(
                context,
                AppRoutes.adoptionForm,
              ),
            ),
            const SizedBox(height: 32),
            
            // Mis reportes
            OutlinedButton.icon(
              onPressed: () {
                // Implementar pantalla de mis reportes
              },
              icon: const Icon(Icons.history),
              label: const Text('Ver mis reportes anteriores'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportOption(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[800]
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 30,
                color: color,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}

// Contenido de la pantalla de foro
class _ForumContent extends StatelessWidget {
  const _ForumContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // App Bar
          const SliverAppBar(
            title: Text('Foro comunitario'),
            floating: true,
            actions: [
              IconButton(
                icon: Icon(Icons.filter_list),
                onPressed: null, // Implementar filtros
              ),
            ],
          ),
          
          // Botón para crear publicación
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.createPost);
                },
                icon: const Icon(Icons.add),
                label: const Text('Crear publicación'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ),
          ),
          
          // Lista de publicaciones
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                // Aquí se cargarán los datos reales desde Firebase
                return _buildPostCard(
                  context,
                  'Usuario $index',
                  'https://via.placeholder.com/50',
                  'Título de la publicación $index',
                  'Contenido de la publicación $index. Este es un ejemplo de cómo se vería una publicación en el foro comunitario.',
                  DateTime.now().subtract(Duration(hours: index)),
                  index % 3 == 0, // Simulación de imagen en algunas publicaciones
                  10 + index, // Simulación de likes
                  5 + index, // Simulación de comentarios
                  () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.postDetail,
                      arguments: 'post_id_$index',
                    );
                  },
                );
              },
              childCount: 10, // Simulación de datos
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(
    BuildContext context,
    String userName,
    String userImageUrl,
    String title,
    String content,
    DateTime date,
    bool hasImage,
    int likes,
    int comments,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Información del usuario
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(userImageUrl),
                    radius: 20,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Título
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              
              // Contenido
              Text(content),
              const SizedBox(height: 12),
              
              // Imagen (si tiene)
              if (hasImage)
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: const DecorationImage(
                      image: NetworkImage('https://via.placeholder.com/400x200'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              if (hasImage) const SizedBox(height: 12),
              
              // Likes y comentarios
              Row(
                children: [
                  Icon(
                    Icons.favorite,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 4),
                  Text('$likes'),
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.comment,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text('$comments'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Contenido de la pantalla de perfil
class _ProfileContent extends StatelessWidget {
  const _ProfileContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Información del perfil
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Foto de perfil
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                      child: const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Nombre de usuario
                    const Text(
                      'Nombre de Usuario',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    
                    // Correo electrónico
                    Text(
                      'usuario@example.com',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Botón de editar perfil
                    OutlinedButton.icon(
                      onPressed: () {
                        // Implementar pantalla de editar perfil
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Editar perfil'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 40),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Opciones del perfil
            Card(
              child: Column(
                children: [
                  _buildProfileOption(
                    context,
                    'Mis mascotas',
                    Icons.pets,
                    () => Navigator.pushNamed(context, AppRoutes.myPets),
                  ),
                  const Divider(height: 1),
                  _buildProfileOption(
                    context,
                    'Mis reportes',
                    Icons.search,
                    () {
                      // Implementar pantalla de mis reportes
                    },
                  ),
                  const Divider(height: 1),
                  _buildProfileOption(
                    context,
                    'Mis publicaciones',
                    Icons.forum,
                    () {
                      // Implementar pantalla de mis publicaciones
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Configuración
            Card(
              child: Column(
                children: [
                  _buildProfileOption(
                    context,
                    'Configuración',
                    Icons.settings,
                    () => Navigator.pushNamed(context, AppRoutes.settings),
                  ),
                  const Divider(height: 1),
                  _buildProfileOption(
                    context,
                    'Notificaciones',
                    Icons.notifications,
                    () {
                      // Implementar pantalla de notificaciones
                    },
                  ),
                  const Divider(height: 1),
                  _buildProfileOption(
                    context,
                    'Tema',
                    Provider.of<ThemeService>(context).isDarkMode
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    () {
                      Provider.of<ThemeService>(context, listen: false).toggleTheme();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Ayuda y soporte
            Card(
              child: Column(
                children: [
                  _buildProfileOption(
                    context,
                    'Ayuda y soporte',
                    Icons.help,
                    () {
                      // Implementar pantalla de ayuda
                    },
                  ),
                  const Divider(height: 1),
                  _buildProfileOption(
                    context,
                    'Acerca de',
                    Icons.info,
                    () {
                      // Implementar pantalla de acerca de
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Cerrar sesión
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Mostrar diálogo de confirmación
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Cerrar sesión'),
                      content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Cerrar sesión e ir a la pantalla de login
                            Navigator.pop(context);
                            Navigator.pushReplacementNamed(context, AppRoutes.login);
                          },
                          child: const Text('Cerrar sesión'),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text('Cerrar sesión'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
