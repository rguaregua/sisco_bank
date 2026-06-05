# Sisco Bank

Aplicacion Rails para gestion de clientes con validaciones de negocio, interfaz web y API JSON.

## Requisitos

- Ruby 3.4.4
- Bundler 2.7.1
- PostgreSQL 14+
- Node.js (solo si usas bin/dev para entorno de desarrollo)

## Instalacion

1. Clonar el repositorio y entrar al proyecto.

2. Instalar dependencias Ruby:

```bash
bundle install
```

3. Crear y preparar base de datos (crea, migra y carga schema si aplica):

```bash
bin/rails db:prepare
```

4. Levantar aplicacion:

```bash
bin/rails server -p 8020
```

Alternativa recomendada para desarrollo completo:

```bash
bin/dev
```

## Migraciones ejecutables

Comandos estandar para manejo de migraciones:

```bash
# Ejecutar migraciones pendientes
bin/rails db:migrate

# Ver estado de migraciones
bin/rails db:migrate:status

# Revertir la ultima migracion
bin/rails db:rollback
```

Para entorno nuevo o cuando quieras preparar todo en un paso:

```bash
bin/rails db:prepare
```

Si tu base local quedo desalineada por cambios en historial de migraciones:

```bash
bin/rails db:migrate:reset
```

## Datos iniciales

Si agregas seeds en [db/seeds.rb](db/seeds.rb), puedes cargarlos con:

```bash
bin/rails db:seed
```

## Pruebas

Ejecutar toda la suite:

```bash
bundle exec rspec
```

Ejecutar solo pruebas de servicio de clientes:

```bash
bundle exec rspec spec/services/client_management_service_spec.rb
```

## Calidad de codigo

```bash
bin/rubocop
bin/brakeman
bin/bundler-audit
```

## Estructura principal

- [app/models/client.rb](app/models/client.rb): validaciones y normalizacion de cliente.
- [app/controllers/clients_controller.rb](app/controllers/clients_controller.rb): CRUD web.
- [app/controllers/api/v1/clients_controller.rb](app/controllers/api/v1/clients_controller.rb): CRUD API JSON.
- [db/migrate/20260603025124_create_clients.rb](db/migrate/20260603025124_create_clients.rb): migracion base de clientes.

## Notas

- Locale por defecto en espanol configurado en [config/application.rb](config/application.rb).
- Base de datos de desarrollo y test configuradas en [config/database.yml](config/database.yml).
