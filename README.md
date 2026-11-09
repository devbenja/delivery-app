# 🚀 Delivery App — Marketplace de 3 Lados (Tipo PedidosYa)

> **Bienvenido a tu proyecto, Benja (Tech Lead).**  
> Este repositorio está diseñado con un enfoque pedagógico de alta calidad para construir una arquitectura de microservicios distribuida y escalable utilizando un equipo de desarrollo híbrido: **1 Humano + 2 Agentes de IA**.

---

## 🕹️ Tu Equipo de Trabajo

| Miembro | Rol | Especialidad |
| :--- | :--- | :--- |
| **🧑‍💻 Benja** | **Tech Lead & Product Owner** | Dirige el proyecto, aprueba contratos, comprende los patrones y valida los checkpoints. |
| **📐 Agente 1** | **Arquitecto & QA Lead (Antigravity)** | Diseña contratos OpenAPI/AsyncAPI, genera suites de tests y explica conceptos con analogías. |
| **💻 Agente 2** | **Core Developer (OpenCode / Subagente)** | Implementa la lógica en NestJS y React Native/React para hacer pasar los tests. |

---

## 🛠️ Stack Tecnológico Oficial

- **Backend:** **NestJS** (TypeScript) con **Prisma ORM**.
- **Infraestructura:** **PostgreSQL 16**, **RabbitMQ 3.13** (AMQP) y **Redis 7** (Caché + Geoespacial) en Docker.
- **Apps Móviles:** **React Native con Expo** (App del Cliente y App del Repartidor).
- **Paneles Web:** **React + Vite / Tailwind** (Panel del Restaurante y Panel de Administración).
- **Monitoreo del Equipo:** **Pixel Dev Office** (Dashboard visual retro en `/apps/pixel-dashboard`).

---

## 🍎 Guía de Inicio Rápido

Si ya tienes las herramientas instaladas (**Node 20**, **pnpm** y **OrbStack**), sigue estos sencillos pasos:

### 1. Clonar el repositorio e instalar dependencias
```bash
git clone <URL_DE_TU_REPOSITORIO> delivery-app
cd delivery-app
pnpm install
```

### 2. Levantar la infraestructura base (Fase 0)
Con un solo comando desde la raíz:
```bash
pnpm infra:up
```

Verifica la salud de los contenedores:
```bash
pnpm infra:status
```
- **PostgreSQL:** Puerto `5432` (con los schemas de cada servicio ya creados).
- **RabbitMQ:** Panel web en [http://localhost:15672](http://localhost:15672) (Usuario: `guest` / Password: `guest`).
- **Redis:** Puerto `6379`.

### 3. Abrir tu Tablero Pixel Art
```bash
pnpm dashboard
```

---

## 🤖 El Mensaje para tu Agente (Copiar y Pegar)

Una vez que tengas el proyecto abierto en tu IDE  (Antigravity o tu editor con agente de IA), **cópiale y pégale este mensaje exacto en el chat**:

```text
Hola. Eres el Agente 1 (Arquitecto y QA) de nuestro equipo. 
Tu directriz permanente es AGENTS.md y tu fuente única de verdad es plan-implementacion.md. 
Yo soy Benja, el Tech Lead (Ingeniero Jr.). 

Ya tengo la infraestructura de la Fase 0 corriendo en mi MacBook M1 (Postgres, RabbitMQ y Redis) y el dashboard Pixel Art abierto.
Explícame con una analogía sencilla el objetivo de la Fase 1 (Servicio de Pedidos y Outbox Pattern) y muéstrame la propuesta de contrato formal para que la revisemos juntos.
```

---

## 📚 Documentación Esencial
- [plan-implementacion.md](plan-implementacion.md): Plan de fases detallado con criterios de avance.
- [AGENTS.md](AGENTS.md): Reglas de comportamiento y roles para la IA.
- [team-status.json](team-status.json): Archivo de estado que sincroniza el tablero Pixel Art.
