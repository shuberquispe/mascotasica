# MascotaSOS – Ica

Aplicación móvil solidaria y social enfocada en ayudar a animales perdidos, promover la adopción, y brindar cuidados básicos a mascotas, especialmente en la región de Ica, Perú.

## Características Principales

- Reportar mascotas perdidas o encontradas
- Adopción de mascotas
- Agenda de vacunas y cuidados
- Mapa de veterinarias y refugios en Ica
- Comunidad / Foro
- Modo offline básico
- Modo oscuro y claro

## Tecnologías Utilizadas

- Flutter para desarrollo multiplataforma (Android e iOS)
- Firebase (Authentication, Firestore, Storage, Cloud Functions, Cloud Messaging)
- Google Maps API para mapas interactivos
- Provider para gestión de estado

## Instalación

1. Clona este repositorio
2. Ejecuta `flutter pub get` para instalar las dependencias
3. Configura Firebase siguiendo las instrucciones en la [documentación oficial](https://firebase.google.com/docs/flutter/setup)
4. Ejecuta la aplicación con `flutter run`

## Estructura del Proyecto

El proyecto sigue una arquitectura basada en capas:

- `lib/config`: Configuración de rutas, temas y constantes
- `lib/core`: Utilidades, servicios y modelos base
- `lib/data`: Repositorios, proveedores y modelos de datos
- `lib/presentation`: Pantallas, widgets y gestión de estado
- `lib/localization`: Archivos de internacionalización

## Contribución

Las contribuciones son bienvenidas. Por favor, abre un issue o envía un pull request para cualquier mejora o corrección.

## Licencia

Este proyecto está bajo la Licencia MIT.
