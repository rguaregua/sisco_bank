# Sisco Bank

Aplicacion Rails para gestion de clientes con validaciones de negocio, interfaz web y API JSON.

## Requisitos

- Ruby 3.4.4
- Bundler 2.7.1
- PostgreSQL 14+
- Node.js (solo si usas bin/dev para entorno de desarrollo)

## Instalacion backend (primer arranque)

1. Clona el repo y entra al proyecto.
2. Asegura que PostgreSQL este levantado en tu maquina (puerto 5432 por defecto).
3. Ejecuta este bloque en orden:

```bash
# Dependencias
bundle install

# Base de datos local (development + test)
bin/rails db:prepare

# (Opcional) datos iniciales
bin/rails db:seed

# Levantar backend
bin/rails server -p 8020
```

4. Verifica que el backend responde:

```bash
curl -I http://localhost:8020
curl http://localhost:8020/api/v1/clients
```

Si PostgreSQL usa otro usuario/password/host, exporta DATABASE_URL antes de correr db:prepare.

## Comandos utiles (referencia)

```bash
# 1) Instalacion
bundle install

# 2) Base de datos
bin/rails db:prepare          # crea/migra/carga schema
bin/rails db:migrate          # ejecuta migraciones pendientes
bin/rails db:migrate:status   # estado de migraciones
bin/rails db:rollback         # revierte la ultima migracion
bin/rails db:migrate:reset    # reinicia DB local y vuelve a migrar
bin/rails db:seed             # carga datos iniciales (si existen)

# 3) Ejecutar la app
bin/rails server -p 8020      # servidor rails
bin/dev                       # entorno desarrollo completo

# 4) Pruebas
bundle exec rspec
bundle exec rspec spec/services/client_management_service_spec.rb

# 5) Calidad de codigo
bin/rubocop
bin/brakeman
bin/bundler-audit
```

## Endpoints

### Web (HTML)

- `GET /` -> listado de clientes (root)
- `GET /clients` -> listado de clientes
- `GET /clients/new` -> formulario de creacion
- `POST /clients` -> crear cliente
- `GET /clients/:id/edit` -> formulario de edicion
- `PATCH/PUT /clients/:id` -> actualizar cliente
- `DELETE /clients/:id` -> eliminar cliente

### API (JSON)

- `GET /api/v1/clients` -> listar clientes (paginacion/filtros)
- `GET /api/v1/clients/:id` -> detalle de cliente
- `POST /api/v1/clients` -> crear cliente
- `PUT /api/v1/clients/:id` -> actualizar cliente
- `DELETE /api/v1/clients/:id` -> eliminar cliente

Filtros soportados en listado API/Web: `page`, `per_page`, `name`, `document`, `type_of_person`.

## Estructura principal

- [app/models/client.rb](app/models/client.rb): validaciones y normalizacion de cliente.
- [app/controllers/clients_controller.rb](app/controllers/clients_controller.rb): CRUD web.
- [app/controllers/api/v1/clients_controller.rb](app/controllers/api/v1/clients_controller.rb): CRUD API JSON.
- [db/migrate/20260603025124_create_clients.rb](db/migrate/20260603025124_create_clients.rb): migracion base de clientes.

## Notas

- Locale por defecto en espanol configurado en [config/application.rb](config/application.rb).
- Base de datos de desarrollo y test configuradas en [config/database.yml](config/database.yml).
