import 'package:flutter/material.dart';

class ServiceCard extends StatelessWidget {
  final String name;
  final String type; // 'veterinaria', 'refugio', 'tienda', etc.
  final String distance;
  final VoidCallback onTap;

  const ServiceCard({
    Key? key,
    required this.name,
    required this.type,
    required this.distance,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determinar icono según el tipo de servicio
    IconData serviceIcon;
    Color serviceColor;
    
    switch (type.toLowerCase()) {
      case 'veterinaria':
        serviceIcon = Icons.local_hospital;
        serviceColor = Colors.blue;
        break;
      case 'refugio':
        serviceIcon = Icons.home;
        serviceColor = Colors.orange;
        break;
      case 'tienda':
        serviceIcon = Icons.shopping_cart;
        serviceColor = Colors.green;
        break;
      case 'peluquería':
        serviceIcon = Icons.content_cut;
        serviceColor = Colors.purple;
        break;
      default:
        serviceIcon = Icons.pets;
        serviceColor = Colors.teal;
        break;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[800]
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icono del servicio
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: serviceColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                serviceIcon,
                color: serviceColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            
            // Información del servicio
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    type.substring(0, 1).toUpperCase() + type.substring(1),
                    style: TextStyle(
                      color: serviceColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 12,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        distance,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
