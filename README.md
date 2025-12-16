# Switch

Una aplicación de productividad todo-en-uno que combina notas, tareas, bases de datos y herramientas de colaboración en un espacio de trabajo unificado.

## 🚀 Características

- **Bloques de contenido modulares**: Texto, listas, tablas, medios y más
- **Sistema de plantillas**: Plantillas predefinidas para diferentes casos de uso
- **Sincronización multiplataforma**: Web y móvil
- **Markdown support**: Formateo rápido con atajos de Markdown
- **Sistema de permisos**: Control granular de acceso a páginas y espacios de trabajo
- **OPCIONALES**
    - **Colaboración en tiempo real**: Trabaja simultáneamente con otros usuarios
    - **Sincronizacion cno google**: las tareas del usuario se añadiran en su calendatoo de google


## 🏗️ Arquitectura

### Backend (Spring Boot)
- **Framework**: Spring Boot 3.x
- **Base de datos**: MongoDB con documentos para almacenamiento flexible
- **Autenticación**: Spring Security con JWT
- **API REST**: endpoints para gestión de bloques, páginas y usuarios
- **Real-time**: WebSockets para colaboración en tiempo real

### Frontend (React)
- **Framework**: React 18+ con TypeScript
- **Estilos**: Tailwind CSS para diseño utilitario y responsive
- **Estado**: Redux Toolkit para gestión de estado
- **Enrutamiento**: React Router
- **Iconos**: Lucide React
- **Editor de texto**: TipTap para edición de bloques ricos

## 📦 Estructura del Proyecto

```
switch/
├── backend/                 # Spring Boot API
│   ├── src/main/java/com/switch/
│   │   ├── controller/     # Controladores REST
│   │   ├── service/        # Lógica de negocio
│   │   ├── repository/     # Acceso a MongoDB
│   │   ├── model/          # Entidades y DTOs
│   │   └── config/         # Configuraciones
│   └── src/main/resources/
│       └── application.yml # Configuración
├── frontend/                # React Application
│   ├── src/
│   │   ├── components/     # Componentes reutilizables
│   │   ├── pages/          # Componentes de página
│   │   ├── store/          # Estado con Redux
│   │   ├── hooks/          # Custom hooks
│   │   ├── services/       # Servicios de API
│   │   └── styles/         # Estilos globales
│   ├── public/             # Archivos estáticos
│   └── tailwind.config.js  # Configuración de Tailwind
└── README.md
```

## 🛠️ Tecnologías utilizadas

### Backend
- Java 21
- Spring Boot
- Spring Data MongoDB
- Spring Security
- JSON Web Tokens (JWT)
- WebSocket (STOMP)
- Maven

### Frontend
- React 18+
- TypeScript
- Tailwind CSS
- Redux Toolkit
- React Router
- Axios para peticiones HTTP
- TipTap para editor de texto
- Lucide React para iconos

### Base de Datos
- MongoDB con documentos para almacenamiento flexible

### Despliegue
- Docker
- Docker Compose

## 📡 API Endpoints

### Autenticación
- `POST /api/auth/login` - Iniciar sesión
- `POST /api/auth/register` - Registrar usuario
- `POST /api/auth/refresh` - Refrescar token
 
### Páginas y Bloques
- `GET /api/pages` - Obtener todas las páginas
- `POST /api/pages` - Crear nueva página
- `GET /api/pages/{id}` - Obtener página específica
- `PUT /api/pages/{id}` - Actualizar página
- `DELETE /api/pages/{id}` - Eliminar página
**Solo seran recividas las paginas creadas por el usuario**

### Documentos (MongoDB)
La aplicación utiliza documentos MongoDB con la siguiente estructura aproximada:

```json
{
  "_id": "ObjectId",
  "title": "Título de la página",
  "blocks": [
    {
      "type": "paragraph|heading|list|table|etc",
      "content": "Contenido del bloque",
      "properties": {}
    }
  ],
  "ownerId": "ID del usuario",
  "collaborators": ["userId1", "userId2"],
  "createdAt": "Fecha de creación",
  "updatedAt": "Fecha de actualización"
}
```

## 🎯 Uso

### Crear una nueva página
1. Haz clic en "+ Nueva página" en la barra lateral
2. Selecciona una plantilla o comienza en blanco
3. Escribe `/` para ver los bloques disponibles

### Trabajar con bloques
- Usa `Ctrl+B` para negrita (Cmd+B en Mac)
- Usa `Ctrl+I` para cursiva (Cmd+I en Mac)
- Arrastra bloques para reorganizarlos

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Consulta el archivo `LICENSE` para más detalles.
