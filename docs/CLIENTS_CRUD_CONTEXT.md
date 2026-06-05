# Contexto API - CRUD de Clientes

Fecha de corte: 2026-06-04
Backend: Ruby on Rails API
Base path: /api/v1

## 1) Contexto de la prueba tecnica

- La aplicacion web responsive principal debe implementarse en Ruby on Rails (MVC con vistas Rails).
- La API REST de clientes se expone adicionalmente para consulta y administracion.
- Este documento describe el contrato actual para consumir esa API desde frontend o integraciones.

## 2) Resumen del recurso Client

Campos de negocio:
- type_of_person: string (Natural | Juridica)
- type_of_document: string (Cedula | Pasaporte | RIF)
- document_number: string (obligatorio y unico)
- document_issued_at: date
- document_expires_at: date
- full_name: string
- email: string (obligatorio, formato valido y unico)
- primary_phone: string (obligatorio, numerico e iniciando con 0)
- secondary_phone: string opcional (si viene, numerico e iniciando con 0)

Formato de fechas aceptado en entrada (create/update):
- DD-MM-AAAA
- DD/MM/AAAA
- YYYY-MM-DD (compatibilidad)

Formato de fechas en salida JSON:
- DD-MM-AAAA

Campos de sistema:
- id
- created_at
- deleted_at (soft delete)

Soft delete:
- DELETE no borra fisicamente. Marca deleted_at.
- Los listados y busquedas excluyen registros con deleted_at.

## 3) Endpoints CRUD

### 3.1 Listar clientes
GET /api/v1/clients

Query params soportados:
- page: numero de pagina
- per_page: tamano de pagina (default backend: 10)
- name: filtro por nombre (ILIKE parcial)
- document: filtro exacto por document_number
- type_of_person: filtro exacto (Natural o Juridica)

Ordenamiento aplicado:
- created_at DESC por defecto

HTTP success:
- 200 OK

Ejemplo response success:
```json
{
  "clients": [
    {
      "id": 1,
      "type_of_person": "Natural",
      "type_of_document": "Cedula",
      "document_number": "12345678",
      "document_issued_at": "15-01-2020",
      "document_expires_at": "15-01-2030",
      "full_name": "Juan Perez",
      "email": "juan@email.com",
      "primary_phone": "04121234567",
      "secondary_phone": "04145556677",
      "created_at": "2026-06-04T10:00:00.000Z"
    }
  ],
  "meta": {
    "current_page": 1,
    "next_page": null,
    "prev_page": null,
    "total_pages": 1,
    "total_count": 1
  }
}
```

### 3.2 Obtener cliente por ID
GET /api/v1/clients/:id

HTTP success:
- 200 OK

Ejemplo response success:
```json
{
  "client": {
    "id": 1,
    "type_of_person": "Natural",
    "type_of_document": "Cedula",
    "document_number": "12345678",
    "document_issued_at": "15-01-2020",
    "document_expires_at": "15-01-2030",
    "full_name": "Juan Perez",
    "email": "juan@email.com",
    "primary_phone": "04121234567",
    "secondary_phone": "04145556677",
    "created_at": "2026-06-04T10:00:00.000Z"
  }
}
```

HTTP error:
- 404 Not Found

Ejemplo response error:
```json
{
  "errors": [
    "Cliente no encontrado"
  ]
}
```

### 3.3 Crear cliente
POST /api/v1/clients

Content-Type: application/json

Body requerido (anidado en client):
```json
{
  "client": {
    "type_of_person": "Natural",
    "type_of_document": "Cedula",
    "document_number": "12345678",
    "document_issued_at": "15-01-2020",
    "document_expires_at": "15-01-2030",
    "full_name": "Juan Perez",
    "email": "juan@email.com",
    "primary_phone": "04121234567",
    "secondary_phone": "04145556677"
  }
}
```

HTTP success:
- 201 Created

Ejemplo response success:
```json
{
  "client": {
    "id": 1,
    "type_of_person": "Natural",
    "type_of_document": "Cedula",
    "document_number": "12345678",
    "document_issued_at": "15-01-2020",
    "document_expires_at": "15-01-2030",
    "full_name": "Juan Perez",
    "email": "juan@email.com",
    "primary_phone": "04121234567",
    "secondary_phone": "04145556677",
    "created_at": "2026-06-04T10:00:00.000Z"
  }
}
```

HTTP error de validacion:
- 422 Unprocessable Entity

Ejemplo response error:
```json
{
  "errors": [
    "Type of document invalido para Persona Natural"
  ]
}
```

### 3.4 Actualizar cliente
PUT /api/v1/clients/:id

Content-Type: application/json

Body requerido (mismo formato que create):
```json
{
  "client": {
    "type_of_person": "Natural",
    "type_of_document": "Pasaporte",
    "document_number": "12345678",
    "document_issued_at": "15-01-2020",
    "document_expires_at": "15-01-2030",
    "full_name": "Juan Perez Actualizado",
    "email": "juan.actualizado@email.com",
    "primary_phone": "04121234567",
    "secondary_phone": "04145556677"
  }
}
```

HTTP success:
- 200 OK

Ejemplo response success:
```json
{
  "client": {
    "id": 1,
    "type_of_person": "Natural",
    "type_of_document": "Pasaporte",
    "document_number": "12345678",
    "document_issued_at": "15-01-2020",
    "document_expires_at": "15-01-2030",
    "full_name": "Juan Perez Actualizado",
    "email": "juan.actualizado@email.com",
    "primary_phone": "04121234567",
    "secondary_phone": "04145556677",
    "created_at": "2026-06-04T10:00:00.000Z"
  }
}
```

HTTP errors:
- 404 Not Found
- 422 Unprocessable Entity

Ejemplo 404:
```json
{
  "errors": [
    "Cliente no encontrado"
  ]
}
```

Ejemplo 422:
```json
{
  "errors": [
    "Email ya esta en uso"
  ]
}
```

### 3.5 Eliminar cliente (soft delete)
DELETE /api/v1/clients/:id

HTTP success:
- 200 OK

Ejemplo response success:
```json
{
  "message": "Cliente eliminado correctamente"
}
```

HTTP error:
- 404 Not Found

Ejemplo response error:
```json
{
  "errors": [
    "Cliente no encontrado"
  ]
}
```

## 4) Reglas de validacion clave

- type_of_person: obligatorio, Natural o Juridica
- type_of_document: obligatorio, Cedula, Pasaporte o RIF
- Relacion persona/documento:
  - Natural: solo Cedula o Pasaporte
  - Juridica: solo RIF
- document_number: obligatorio y unico
- document_issued_at y document_expires_at: obligatorios
- document_expires_at debe ser mayor a document_issued_at
- full_name: obligatorio, solo letras y espacios
- email: obligatorio, formato valido y unico
- primary_phone: obligatorio, debe iniciar con 0
- secondary_phone: opcional, si viene debe iniciar con 0

## 5) Contrato de errores para frontend

Formato estandar de error:
```json
{
  "errors": ["mensaje 1", "mensaje 2"]
}
```

Recomendacion frontend:
- Mostrar errors como lista de mensajes.
- Si llega un solo error, mostrarlo igual en el mismo componente de errores.

## 6) Notas para la IA que construira el frontend

- Consumir siempre con payload request anidado en client para create/update.
- Manejar 422 como errores de formulario y 404 como recurso inexistente.
- El contrato para recursos (index/show/create/update) usa roots de ActiveModelSerializer: clients/client.
- DELETE responde solo con message.
