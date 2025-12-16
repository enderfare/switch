@startuml
left to right direction
title Switch Application - Use Case Diagram

skinparam usecase {
  BackgroundColor<<Main>> LightBlue
  BackgroundColor<<Colaboracion>> LightGreen
  BackgroundColor<<Contenido>> LightYellow
  BackgroundColor<<Sistema>> LightGray
}

' ===== ACTORS =====
actor User as "Usuario"
actor Guest as "Invitado"
actor System as "Sistema"
actor "Usuario Externo" as ExternalUser
actor "Colaborador de Board" as Collaborator
actor "Dueño de Board" as Owner

User --|> Guest
Collaborator --|> User
Owner --|> Collaborator

' ===== AUTHENTICATION PACKAGE =====
rectangle "Autenticacion & Maaanajo de Usuarios" {
  usecase "Registrar Cuenta" as UC1 <<Main>>
  usecase "Login" as UC2 <<Main>>
  usecase "Logout" as UC3 <<Main>>
  usecase "Actualizar Perfil" as UC4 <<Main>>
  usecase "Canviar Contraseña" as UC5 <<Main>>
  usecase "Resetear Contraseña" as UC6 <<Main>>
  usecase "Desactivar Cuenta" as UC7 <<Main>>
  
  Guest --> UC1
  Guest --> UC2
  User --> UC3
  User --> UC4
  User --> UC5
  User --> UC6
  User --> UC7
}

' ===== FRIENDS & Colaboracion PACKAGE =====
rectangle "Social & Collaboracion" {
  usecase "Buscar Users" as UC8 <<Colaboracion>>
  usecase "Enviar Solicitud de Amistad" as UC9 <<Colaboracion>>
  usecase "Aceptar/Rechazar Solicitud de Amigo" as UC10 <<Colaboracion>>
  usecase "Quitar Amigo" as UC11 <<Colaboracion>>
  usecase "Ver Lista de Amigos" as UC12 <<Colaboracion>>
  usecase "Compartir Board via Link" as UC13 <<Colaboracion>>
  usecase "Enviar Invitacion a Board" as UC14 <<Colaboracion>>
  
  User --> UC8
  User --> UC9
  User --> UC10
  User --> UC11
  User --> UC12
  Owner --> UC13
  Owner --> UC14
  ExternalUser --> UC14
}

' ===== BOARD MANAGEMENT PACKAGE =====
rectangle "Manejo Board" {
  usecase "Crear Board" as UC15 <<Main>>
  usecase "Ver Board" as UC16 <<Main>>
  usecase "Editar Board Details" as UC17 <<Main>>
  usecase "Borrar Board" as UC18 <<Main>>
  usecase "Archivar/Restaurar Board" as UC19 <<Main>>
  usecase "Canviar Visivilidad de la Board" as UC20 <<Main>>
  usecase "Manejar Miembros de la Board" as UC21 <<Colaboracion>>
  usecase "Canviar permisos de la Board" as UC22 <<Colaboracion>>
  usecase "Reordenar Secciones" as UC23 <<Main>>
  
  Owner --> UC15
  Owner --> UC16
  Owner --> UC17
  Owner --> UC18
  Owner --> UC19
  Owner --> UC20
  Owner --> UC21
  Owner --> UC22
  Owner --> UC23
  
  Collaborator --> UC16
  Collaborator --> UC21
  Collaborator --> UC22
}

' ===== SECTION MANAGEMENT PACKAGE =====
rectangle "Manejo de Secciones" {
  usecase "Crear Seccion" as UC24 <<Main>>
  usecase "Editar Seccion" as UC25 <<Main>>
  usecase "Borrar Seccion" as UC26 <<Main>>
  usecase "Canviar Colapaso de Seccion" as UC27 <<Main>>
  usecase "Canviar Permisos de Seccion" as UC28 <<Colaboracion>>
  usecase "Crear Seccion de Notas" as UC29 <<Contenido>>
  usecase "Crear Seccion de Tareas" as UC30 <<Contenido>>
  
  Collaborator --> UC24
  Collaborator --> UC25
  Collaborator --> UC26
  Collaborator --> UC27
  Collaborator --> UC28
  Collaborator --> UC29
  Collaborator --> UC30
}

' ===== NOTES MANAGEMENT PACKAGE =====
rectangle "Manejo de Notas" {
  usecase "Crear Nota" as UC31 <<Contenido>>
  usecase "Editar Nota" as UC32 <<Contenido>>
  usecase "Borrar Nota" as UC33 <<Contenido>>
  usecase "Ver Nota" as UC34 <<Contenido>>
  usecase "Pin/Unpin Nota" as UC35 <<Contenido>>
  usecase "Archivar Nota" as UC36 <<Contenido>>
  usecase "Buscar Nota" as UC37 <<Contenido>>
  usecase "Filtrar Nota via Tags" as UC38 <<Contenido>>
  usecase "Compartir Nota" as UC39 <<Colaboracion>>
  usecase "Ver historial de Notas" as UC40 <<Contenido>>
  usecase "Revertir a Version previa" as UC41 <<Contenido>>
  
  Collaborator --> UC31
  Collaborator --> UC32
  Collaborator --> UC33
  Collaborator --> UC34
  Collaborator --> UC35
  Collaborator --> UC36
  Collaborator --> UC37
  Collaborator --> UC38
  Collaborator --> UC39
  Collaborator --> UC40
  Collaborator --> UC41
  ExternalUser --> UC39
}

' ===== TASKS MANAGEMENT PACKAGE =====
rectangle "Manejo de Tareas" {
  usecase "Crear Tarea" as UC42 <<Contenido>>
  usecase "Editar Tarea" as UC43 <<Contenido>>
  usecase "Borrar Tarea" as UC44 <<Contenido>>
  usecase "Ver Tarea" as UC45 <<Contenido>>
  usecase "Marcar Tarea Completa/Incompleta" as UC46 <<Contenido>>
  usecase "Asignar Tarea" as UC47 <<Colaboracion>>
  usecase "Ajustar Prioridad de la Tarea" as UC48 <<Contenido>>
  usecase "Asignar Fecha Fin" as UC49 <<Contenido>>
  usecase "Añadir SubTarea" as UC50 <<Contenido>>
  usecase "Loggear Tiempo" as UC51 <<Contenido>>
  usecase "Añadir Comentario" as UC52 <<Colaboracion>>
  usecase "Filtrar Tareas" as UC53 <<Contenido>>
  usecase "Ordenar Tareas" as UC54 <<Contenido>>
  usecase "Ver Estadisticas de Tareas" as UC55 <<Contenido>>
  
  Collaborator --> UC42
  Collaborator --> UC43
  Collaborator --> UC44
  Collaborator --> UC45
  Collaborator --> UC46
  Collaborator --> UC47
  Collaborator --> UC48
  Collaborator --> UC49
  Collaborator --> UC50
  Collaborator --> UC51
  Collaborator --> UC52
  Collaborator --> UC53
  Collaborator --> UC54
  Collaborator --> UC55
}

' ===== REAL-TIME Colaboracion PACKAGE =====
rectangle "Colaboracion en tiempo real" {
  usecase "Reciviarupdates" as UC56 <<Sistema>>
  usecase "Ver presencia de usuario" as UC57 <<Sistema>>
  usecase "Trackeo de Cursor en vivo" as UC58 <<Sistema>>
  usecase "Notificaciones" as UC59 <<Sistema>>
  
  Collaborator --> UC56
  Collaborator --> UC57
  Collaborator --> UC58
  Collaborator --> UC59
  System -- UC56
  System -- UC57
  System -- UC58
  System -- UC59
}

' ===== Sistema AUTOMATION PACKAGE =====
rectangle "Automatizacion de sistema" {
  usecase "Auto-archivar Tareas Completadas" as UC60 <<Sistema>>
  usecase "Enviar notificaciones por no hacer tareas" as UC61 <<Sistema>>
  usecase "Hacer Backup de los datos" as UC62 <<Sistema>>
  usecase "Limpiar links expirados" as UC63 <<Sistema>>
  
  System -- UC60
  System -- UC61
  System -- UC62
  System -- UC63
}

' ===== INCLUDE/EXTEND RELATIONSHIPS =====

' Authentication includes
UC2 ..> UC1 : extends <<optional>>
UC5 ..> UC2 : includes <<mandatory>>

' Board relationships
UC15 ..> UC2 : includes <<mandatory>>
UC21 ..> UC8 : includes <<mandatory>>
UC22 ..> UC21 : extends

' Section relationships
UC24 ..> UC29 : extends
UC24 ..> UC30 : extends
UC25 ..> UC24 : includes <<mandatory>>

' Notes relationships
UC31 ..> UC29 : includes <<mandatory>>
UC32 ..> UC34 : includes <<mandatory>>
UC40 ..> UC34 : extends

' Tasks relationships
UC42 ..> UC30 : includes <<mandatory>>
UC46 ..> UC45 : includes <<mandatory>>
UC47 ..> UC45 : extends
UC50 ..> UC42 : extends

' Sharing relationships
UC39 ..> UC13 : uses
UC14 ..> UC9 : similar to

' Sistema triggers
UC61 ..> UC49 : triggers
UC60 ..> UC46 : triggers

' ===== GENERALIZATION =====
' View operations generalization
UC16 <.[#red]. (Ver Contenido) : <<generalize>>
UC34 <.[#red]. (Ver Contenido) : <<generalize>>
UC45 <.[#red]. (Ver Contenido) : <<generalize>>

' Edit operations generalization
UC17 <.[#red]. (Editar Contenido) : <<generalize>>
UC25 <.[#red]. (Editar Contenido) : <<generalize>>
UC32 <.[#red]. (Editar Contenido) : <<generalize>>
UC43 <.[#red]. (Editar Contenido) : <<generalize>>

' Delete operations generalization
UC18 <.[#red]. (Borrar Contenido) : <<generalize>>
UC26 <.[#red]. (Borrar Contenido) : <<generalize>>
UC33 <.[#red]. (Borrar Contenido) : <<generalize>>
UC44 <.[#red]. (Borrar Contenido) : <<generalize>>

' ===== NOTES =====
note right of UC2
  Inicio de sesion Requerido para todas
  las funcionalidades principales
end note

note bottom of UC21
  Añadir|Quitar Usuarios
  Canviar Roles de usuario
  Ver Lista de Miembros
end note

note right of UC56
  Updates en timpo real para:
  - Canvios de Board
  - Edits Notas
  - Updates de Task
  - Presencia de Usuarios
end note

note top of UC60
  Archivado automatico Basado en 
  Ajusted de Seccion
  y Usuario
end note

' ===== PERMISSION CONSTRAINTS =====
note left of Owner
  Tiene todos los Permisos:
  - Borrar board
  - Manejar members
  - Ajustar Permisos
end note

note right of Collaborator
  Permisos canvian en base el Rol:
  - ADMIN: Acceso Completo
  - EDITOR: Editar Contenido
  - VIEWER: Solo Lectura
end note

@enduml