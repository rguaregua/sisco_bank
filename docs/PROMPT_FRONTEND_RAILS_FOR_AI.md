# Prompt Para IA - Frontend Rails Responsive

Eres un Senior Ruby on Rails Engineer.
Necesito que construyas una aplicacion web responsive en Ruby on Rails (no Next.js), usando vistas Rails (.html.erb), con arquitectura MVC limpia, validaciones de formulario y UX clara.

## Objetivo
Implementar el frontend web para gestionar el CRUD completo de clientes de Sisco Bank, consumiendo o reutilizando el backend existente.

## Restricciones clave
- La app web principal debe ser en Ruby on Rails.
- Debe ser responsive (mobile-first).
- Puedes usar Bootstrap o Tailwind.
- No usar SPA externa ni framework JS separado para la app principal.

## Recurso de negocio: Client
Campos:
- type_of_person: Natural | Juridica
- type_of_document: Cedula | Pasaporte | RIF
- document_number: obligatorio, unico
- document_issued_at: obligatorio
- document_expires_at: obligatorio
- full_name: obligatorio, solo letras y espacios
- email: obligatorio, formato valido, unico
- primary_phone: obligatorio, numerico e iniciando con 0
- secondary_phone: opcional, si viene debe iniciar con 0

Reglas de negocio:
- Si type_of_person = Natural, type_of_document solo puede ser Cedula o Pasaporte.
- Si type_of_person = Juridica, type_of_document debe ser RIF.
- document_expires_at debe ser mayor a document_issued_at.

Formato de fechas:
- Entrada aceptada: DD-MM-AAAA o DD/MM/AAAA (compatibilidad con YYYY-MM-DD).
- Salida esperada: DD-MM-AAAA.

## Endpoints API disponibles
Base path: /api/v1
- GET /clients
- GET /clients/:id
- POST /clients
- PUT /clients/:id
- DELETE /clients/:id

Filtros en listado:
- page
- per_page
- name
- document
- type_of_person

Orden por defecto:
- created_at DESC

## Contrato JSON actual
### Index (200)
- Responde con root clients y meta de paginacion.

### Show (200)
- Responde con root client.

### Create (201)
- Request body anidado en client.
- Respuesta con root client.

### Update (200)
- Request body anidado en client.
- Respuesta con root client.

### Destroy (200)
- Respuesta: { "message": "Cliente eliminado correctamente" }

### Errores
- Formato estandar: { "errors": ["..."] }
- 404: recurso no encontrado
- 422: errores de validacion

## Lo que debes construir
1. Vistas Rails responsive para:
- Listado de clientes con filtros y paginacion.
- Formulario de crear cliente.
- Formulario de editar cliente.
- Vista detalle de cliente.
- Accion eliminar con confirmacion.

2. UX de formularios:
- Mensajes de error por campo y resumen general.
- Preservar datos del formulario cuando hay error.
- Selects dependientes para tipo de documento segun tipo de persona.
- Inputs de fecha aceptando DD-MM-AAAA o DD/MM/AAAA.

3. Estructura tecnica:
- Controllers MVC para HTML.
- Reuso de logica de validacion existente.
- Componentizacion parcial de vistas (partials) para formulario y tabla.
- Rutas limpias REST.

4. Calidad esperada Mid-Senior:
- Codigo claro y mantenible.
- Convenciones Rails.
- Manejo consistente de errores.
- Responsive real (mobile/tablet/desktop).
- Tests basicos de request o system para flujo CRUD.

## Entregables solicitados
- Codigo completo de vistas, rutas y controladores HTML.
- Estilos y layout responsive.
- Breve README con instrucciones de ejecucion.
- Lista de decisiones tecnicas tomadas.

Usa este contrato como fuente de verdad del frontend:
- docs/CLIENTS_CRUD_CONTEXT.md
