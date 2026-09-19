# Plan de implementación — App de Delivery Escalable (Tipo PedidosYa)

> **Nota para el equipo:** Este proyecto se desarrolla con un enfoque pedagógico de excelencia para un **Ingeniero en Computación Jr.** en conjunto con **Agentes de IA**. El objetivo es aprender y dominar la arquitectura de software real de sistemas distribuidos, construyendo un producto de calidad de producción paso a paso, sin sobrecarga ni complejidades innecesarias.

---

## 1. El Equipo de Trabajo y Reglas de Convivencia

### 1.1 Miembros del Equipo
1. **🧑‍💻 Humano (Tech Lead & Product Owner):** Define requerimientos, aprueba contratos, aprende los conceptos clave y valida los checkpoints.
2. **📐 Agente 1 (Arquitecto y QA en Antigravity):** Diseña contratos (OpenAPI/AsyncAPI), redacta pruebas y explica los conceptos de forma sencilla antes de programar.
3. **💻 Agente 2 (Core Developer en OpenCode / Subagente):** Programa la lógica de negocio en NestJS y React Native/React para hacer pasar los tests.

### 1.2 Reglas para no perderse en el camino
- **Regla del Bocado Único:** Solo se trabaja y se discute la fase activa. No nos preocupamos por fases futuras hasta haber completado y entendido la actual.
- **Explicaciones con Analogías:** Antes de implementar un patrón técnico (ej. Outbox, Idempotencia, Sagas), el agente debe explicarlo en lenguaje cotidiano con una analogía simple.
- **Contract-First:** Toda funcionalidad se define primero en un archivo de contrato YAML legible y breve que el humano aprueba con un vistazo.
- **Brújula Visual (Dashboard Pixel Art):** Una app web local estilo retro 16-bits muestra el estado de las tareas y qué está haciendo cada miembro del equipo en tiempo real.

---

## 2. Stack Tecnológico Oficial

### 2.1 Backend (Microservicios)
- **Framework:** **NestJS** con TypeScript (aprovecha su estructura modular ordenada y soporte nativo de `@nestjs/microservices`).
- **Persistencia:** **PostgreSQL 16** con **Prisma ORM** (fácil de leer, seguro y con autocompletado total).
- **Mensajería Asíncrona:** **RabbitMQ 3.13** (Exchange tipo topic y colas durables con DLQ).
- **Caché y Coordenadas GPS:** **Redis 7** (para caché de catálogo y comandos geoespaciales `GEOADD`/`GEOSEARCH` para repartidores).
- **Comunicación en Tiempo Real:** **WebSockets (Socket.IO / ws)** integrado en NestJS para tracking de pedidos.

### 2.2 Frontend y Aplicaciones Clientes (Enfoque B)
- **App Móvil del Cliente (Comensal):** **React Native con Expo** (exploración de menús, carrito, pago y seguimiento en mapa en vivo).
- **App Móvil del Repartidor (Rider):** **React Native con Expo** (recepción de pedidos, mapa de ruta y emisión de coordenadas GPS).
- **Panel del Comercio (Restaurante):** **React + Vite / Tailwind** (pantalla de pedidos de cocina con alertas sonoras en vivo).
- **Panel de Administración (Backoffice):** **React + Vite / Tailwind** (métricas y gestión de comercios).
- **Dashboard Pixel Art del Equipo:** **HTML5 Canvas / Vite** (oficina virtual retro que muestra el estado de las tareas de los agentes).

### 2.3 Rendimiento y Entorno Local (MacBook Air M1 / Apple Silicon)
- **Gestor de Paquetes:** **pnpm** con Workspaces (`pnpm-workspace.yaml`) para evitar duplicación de `node_modules`, ahorrando hasta un 70% de espacio en disco y cuidando la vida útil del SSD.
- **Motor de Contenedores:** **OrbStack** (recomendado sobre Docker Desktop) para arrancar en 2 segundos con menos de 100 MB de RAM y consumo mínimo de batería.
- **Compilación Ultrarrápida:** **SWC** en NestJS (`nest start -b swc`) para compilar a velocidades nativas sin calentar el procesador M1 (refrigeración pasiva).
- **Límites de Recursos:** Topes de memoria en `docker-compose.yml` (máximo 1.2 GB sumando Postgres, RabbitMQ y Redis) para garantizar fluidez en modelos de 8 GB o 16 GB de RAM unificada.
- **Testing Rápido:** **Vitest** en lugar de Jest tradicional para aprovechar el soporte nativo ESM y paralelismo de núcleos Apple Silicon.

### 2.4 Mapas, Geolocalización y Ruteo (Estrategia Open Source y Self-Hosted)
- **Visualización Cartográfica:** **MapLibre GL** (librería open-source para React Native y React, libre de ataduras de Google Maps / Apple Maps).
- **Búsqueda de Direcciones (Geocoding):** Integración con **Nominatim / LocationIQ** (Free tiers generosos de miles de consultas diarias).
- **Indexación y Búsqueda de Repartidores:** **Redis 7 Geo** (`GEOADD`, `GEOSEARCH`) para filtrar motos cercanas en radio de kilómetros en menos de 2 milisegundos sin consultar disco.
- **Motor de Ruteo y Distancias (Self-Hosted):** Contenedor Docker con **OSRM (Open Source Routing Machine)** alimentado con datos libres de **OpenStreetMap (.osm.pbf)**. Permite calcular rutas, tiempos de entrega (ETA) y matrices de distancia a **$0 USD en llamadas de API**. *(Ver ADR-001 en `/docs/adr/`)*.

---

## 3. Estructura del Monorepo

```text
/nombre-app
├── /apps                          # Aplicaciones de usuario
│   ├── /cliente-mobile            # React Native (Expo) - App comensal
│   ├── /repartidor-mobile         # React Native (Expo) - App repartidor
│   ├── /comercio-web              # React (Vite) - Pantalla de pedidos del local
│   ├── /admin-web                 # React (Vite) - Panel administrativo
│   └── /pixel-dashboard           # Tablero Pixel Art de monitoreo del equipo
│
├── /services                      # Microservicios en NestJS
│   ├── /gateway                   # API Gateway (Auth, Proxy y WebSockets)
│   ├── /pedidos                   # Máquina de estados del pedido + Outbox
│   ├── /usuarios                  # Registro, login y roles (JWT)
│   ├── /pagos                     # Cobros seguros e idempotentes
│   ├── /catalogo                  # Menús, productos y stock con caché
│   ├── /despacho                  # Asignación de repartidores y GPS (Redis)
│   └── /notificaciones            # Consumidor de eventos para emails/push
│
├── /contracts                     # Contratos formales de comunicación
│   ├── /api                       # Especificaciones OpenAPI 3.1 (REST)
│   └── /events                    # Especificaciones AsyncAPI (RabbitMQ)
│
├── /docs                          # Documentación y registros de decisiones
│   └── guia-m1-setup.md           # Guía paso a paso para MacBook Air M1
│
└── /infra                         # Infraestructura Docker local
    └── docker-compose.yml         # Postgres, RabbitMQ y Redis
```

---

## 4. Fases de Implementación Progresivas

---

### Fase 0 — Entorno Base y el Tablero Pixel Art

**Objetivo:** Levantar la infraestructura mínima necesaria y el visor visual de tu equipo de IA optimizado para tu MacBook Air M1.

- [x] Estructura base de carpetas del proyecto y configuración de monorepo con `pnpm`.
- [x] `docker-compose.yml` con límites de memoria M1 para **PostgreSQL**, **RabbitMQ** y **Redis**.
- [x] Guía paso a paso de instalación y configuración pedagógica en [`docs/guia-m1-setup.md`](docs/guia-m1-setup.md).
- [ ] Módulo `/apps/pixel-dashboard`: interfaz web estilo oficina retro pixel art sincronizada con `team-status.json`.
- [ ] Ejecutar `pnpm infra:up` en la Mac y validar salud de los 3 contenedores.

> **¿Qué aprenderás en esta fase?**
> Cómo Docker/OrbStack y un gestor eficiente como `pnpm` permiten levantar un ecosistema distribuido completo (Postgres, RabbitMQ, Redis) con un solo comando, de forma silenciosa y sin saturar la memoria de tu Mac.

---

### Fase 1 — Servicio de Pedidos (Tu primer microservicio NestJS + Outbox)

**Objetivo:** Crear el servicio que gestiona la vida de un pedido y aprender a no perder eventos.

- [ ] Concepto explicado: *¿Por qué no podemos guardar en la base de datos y enviar a RabbitMQ en dos pasos separados si se corta la luz? (Problema de la doble escritura).*
- [ ] Contrato de endpoints y eventos (`crear_pedido`, `pedido_creado`).
- [ ] Proyecto NestJS para `pedidos` conectado a Postgres con Prisma.
- [ ] Implementación de la tabla `pedidos` y la tabla `outbox_events`.
- [ ] Worker que lee de la tabla outbox y envía el mensaje a RabbitMQ.

> **¿Qué aprenderás en esta fase?**
> Cómo funciona una máquina de estados de un pedido y cómo el patrón Outbox garantiza que ningún pedido se quede sin avisar al resto del sistema.

---

### Fase 2 — Servicio de Usuarios y Autenticación (JWT y Roles)

**Objetivo:** Saber quién es quién en el marketplace (Cliente, Dueño de Restaurante o Repartidor).

- [ ] Concepto explicado: *¿Cómo viaja tu identidad en un token JWT sin tener que consultar la base de datos en cada clic?*
- [ ] Servicio NestJS de `usuarios` con registro y login.
- [ ] Contraseñas encriptadas con algoritmos seguros (Bcrypt/Argon2).
- [ ] Emisión de JWT con el rol correspondiente del usuario.

> **¿Qué aprenderás en esta fase?**
> Autenticación moderna con tokens y cómo proteger rutas según el tipo de usuario.

---

### Fase 3 — API Gateway (El recepcionista del sistema)

**Objetivo:** Crear la puerta de entrada única para no exponer todos los microservicios directamente a internet.

- [ ] Concepto explicado: *¿Por qué una app móvil debe hablar con un solo punto central en vez de con 6 servidores distintos?*
- [ ] Servicio NestJS `gateway` que redirige el tráfico a `pedidos` y `usuarios`.
- [ ] Validación de tokens JWT en la puerta de entrada (si el token no es válido, no pasa).

> **¿Qué aprenderás en esta fase?**
> El rol fundamental de un API Gateway y el filtrado de seguridad centralizado.

---

### Fase 4 — Bus de Eventos y Notificaciones (Comunicación Asíncrona)

**Objetivo:** Aprender a desacoplar servicios para que funcionen como piezas de dominó que no se bloquean entre sí.

- [ ] Concepto explicado: *¿Cómo funciona un cartero digital (RabbitMQ) y qué pasa si el destinatario está apagado?*
- [ ] Servicio NestJS `notificaciones` que escucha el evento `pedido_creado`.
- [ ] Configuración de colas durables y Dead Letter Queue (DLQ) para mensajes con error.

> **¿Qué aprenderás en esta fase?**
> El patrón Publicador/Suscriptor (Pub/Sub) y por qué hace que el sistema sea inmune a caídas temporales de servicios secundarios.

---

### Fase 5 — Catálogo (Caché con Redis) y Panel del Comercio

**Objetivo:** Publicar menús y recibir pedidos en la cocina del restaurante.

- [ ] Concepto explicado: *¿Por qué guardar en memoria RAM (Redis) las pizzas de la pizzería en lugar de preguntarle a la base de datos 10,000 veces por minuto?*
- [ ] Servicio `catalogo` con CRUD de productos y stock.
- [ ] Implementación de caché rápida con Redis (Cache-Aside).
- [ ] `/apps/comercio-web`: Panel web simple en React para que el restaurante vea sus productos y reciba alertas de pedidos.

> **¿Qué aprenderás en esta fase?**
> Estrategias de caché y cómo conectar una app web con NestJS.

---

### Fase 6 — Despacho y Tracking en Tiempo Real (GPS + WebSockets + OpenStreetMap)

**Objetivo:** Localizar a los repartidores en tiempo real, calcular rutas precisas y asignar el pedido a la moto más cercana sin incurrir en costos de Google Maps.

- [ ] Concepto explicado: *¿Por qué Redis Geo para proximidad inmediata y OpenStreetMap/OSRM para ruteo en lugar de pagar miles de dólares a Google Maps?*
- [ ] Servicio `despacho` con almacenamiento y filtrado de coordenadas GPS en **Redis 7 Geo** (`GEOADD`, `GEOSEARCH`).
- [ ] Motor de Ruteo **OSRM (Open Source Routing Machine)** en Docker con datos de **OpenStreetMap (.osm.pbf)** para calcular distancias, rutas y ETA a $0 USD.
- [ ] Canal WebSocket en el Gateway para streaming de coordenadas en vivo hacia los clientes.
- [ ] `/apps/repartidor-mobile`: App Expo simple con emisión periódica de GPS.
- [ ] Visualización en mapa en `/apps/cliente-mobile` usando **MapLibre GL** (open source).

> **¿Qué aprenderás en esta fase?**
> Cómo combinar memoria RAM (Redis Geo) para búsquedas de proximidad en milisegundos con motores de ruteo abiertos (OSRM + OpenStreetMap) para crear un sistema de logística profesional sin dependencia de APIs comerciales caras.

---

### Fase 7 — Pagos Seguros e Idempotencia

**Objetivo:** Cobrar de forma segura sin peligro de cobrar dos veces si el usuario aprieta el botón repetidamente con mala señal.

- [ ] Concepto explicado: *¿Qué es una Idempotency Key y por qué evita cobros dobles?*
- [ ] Servicio `pagos` con integración simulada de tarjeta / tokens.
- [ ] Registro de claves de idempotencia para transacciones únicas.

> **¿Qué aprenderás en esta fase?**
> Seguridad en transacciones financieras y cumplimiento básico de estándares de pago.

---

### Fase 8 — La App del Cliente y la Saga Completa

**Objetivo:** Juntar todas las piezas en la app del comensal.

- [ ] Concepto explicado: *¿Qué es el patrón Saga? (Si no hay saldo en la tarjeta, avisarle a la cocina que no prepare la pizza y reponer el stock).*
- [ ] `/apps/cliente-mobile`: App en React Native (Expo) donde el usuario elige productos, paga y ve en un mapa el tracking en vivo.
- [ ] Flujo completo de la orden coordinado de punta a punta.

> **¿Qué aprenderás en esta fase?**
> Cómo orquestar un flujo completo de negocio entre múltiples servicios móviles y backend.

---

### Fase 9 — Observabilidad (Rastrear un pedido con lupa)

**Objetivo:** Poder ver exactamente qué camino siguió un pedido a través de todos los servicios cuando algo falla.

- [ ] Concepto explicado: *¿Qué es un Trace ID y por qué es como el número de guía de seguimiento de un paquete?*
- [ ] Integración de OpenTelemetry y logs con formato estructurado.

> **¿Qué aprenderás en esta fase?**
> Monitoreo y depuración profesional de sistemas distribuidos en producción.

---

## 5. Criterio de Avance

Avanzamos de fase cuando:
1. Las pruebas automatizadas preparadas por el Agente 1 pasan en verde.
2. Tú, como Tech Lead, comprendes la analogía y el propósito del patrón implementado.
3. El Dashboard Pixel Art marca la fase completada y pasa a la siguiente.
