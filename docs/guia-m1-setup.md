# 🍏 Guía Maestra de Instalación y Configuración para MacBook Air M1

> **Perfil del Desarrollador:** Benja (Tech Lead & Product Owner)  
> **Objetivo:** Preparar un entorno de desarrollo profesional, ultra-rápido, silencioso y optimizado para la arquitectura **Apple Silicon (M1)** sin sobrecalentar el equipo ni saturar la memoria RAM.

---

## 💡 Los Fundamentos (Explicados con Analogías Cotidianas)

Antes de teclear comandos en la terminal, entendamos qué hace cada herramienta que vamos a instalar:

1. **Homebrew:**
   > *Analogía:* Es la "App Store" de los ingenieros de software para la terminal. En vez de ir a una página web a descargar un archivo `.dmg` o `.pkg`, arrastrarlo y darle siguiente-siguiente, Homebrew se encarga de descargar, instalar y actualizar herramientas de sistema con una sola orden.

2. **Node.js LTS y pnpm:**
   > *Analogía:* **Node.js** es el motor a gasolina que permite que el código JavaScript/TypeScript corra fuera del navegador (en tu servidor). **pnpm** es un bibliotecario extremadamente inteligente: en lugar de imprimir 10 fotocopias de un libro de 500 páginas para 10 habitaciones distintas (como hace `npm` normal, llenando tu disco duro), guarda un único libro en la biblioteca central y pone marcadores de lectura que apuntan a él.

3. **OrbStack (en vez de Docker Desktop):**
   > *Analogía:* Docker tradicional en macOS es como un camión con acoplado que consume combustible (batería y RAM) incluso cuando está estacionado en el semáforo. **OrbStack** es una moto eléctrica diseñada específicamente para el motor de tu Mac M1: arranca en 2 segundos y consume menos de 100 MB de memoria en reposo.

---

## 📋 Requisitos Previos

En tu MacBook Air M1 solo necesitas tener abierta la aplicación **Terminal** (puedes buscarla presionando `Cmd + Espacio` y escribiendo `Terminal` o usar tu emulador preferido como **iTerm2** o la terminal integrada de tu editor).

---

## 🛠️ Paso a Paso: Instalación de Herramientas

### Paso 1: Instalar Xcode Command Line Tools
Son las herramientas básicas de compilación que necesita macOS para cualquier tarea de programación.

Abre la Terminal y escribe:
```bash
xcode-select --install
```
> *Aparecerá una ventana emergente en macOS preguntando si deseas instalar las herramientas de desarrollo. Haz clic en **Instalar** y espera a que termine.*

---

### Paso 2: Instalar Homebrew (El Gestor de Paquetes)
Copia y pega este comando oficial en tu Terminal y presiona `Enter`:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

> ⚠️ **Paso Clave para Apple Silicon (M1):**  
> Al finalizar, la terminal te mostrará un mensaje llamado **"Next steps"**. Te pedirá ejecutar dos comandos para agregar Homebrew a tu ruta del sistema (`PATH`). Ejecútalos (lucen así):
> ```bash
> echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
> eval "$(/opt/homebrew/bin/brew shellenv)"
> ```

Verifica que quedó bien instalado:
```bash
brew --version
```
*(Deberías ver algo como `Homebrew 4.x.x`)*.

---

### Paso 3: Instalar Node.js LTS y Git
Usaremos Homebrew para instalar la versión estable de Node.js y la última versión de Git:

```bash
brew install node@20 git
```

Agrega Node 20 al camino del sistema:
```bash
echo 'export PATH="/opt/homebrew/opt/node@20/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

Verifica la instalación:
```bash
node -v   # Debe responder v20.x.x
npm -v    # Debe responder 10.x.x
git --version
```

---

### Paso 4: Instalar pnpm (El Gestor Eficiente)
Instalamos `pnpm` globalmente:

```bash
npm install -g pnpm
```

Configura el entorno de pnpm:
```bash
pnpm setup
source ~/.zshrc
pnpm -v   # Debe responder 9.x.x
```

---

### Paso 5: Instalar OrbStack (Docker Ultraliviano para M1)
Ejecuta con Homebrew:

```bash
brew install --cask orbstack
```

> **Primer inicio de OrbStack:**  
> 1. Abre **OrbStack** desde Spotlight (`Cmd + Espacio` -> `OrbStack`).  
> 2. Te pedirá permisos iniciales de administrador (escribe tu contraseña de Mac para permitir la red virtual).  
> 3. ¡Listo! Verás el icono de OrbStack en la barra superior de tu Mac. Ya tienes Docker corriendo consumiendo casi 0% de CPU y batería.

Verifica que el comando `docker` responda desde tu terminal:
```bash
docker --version
docker compose version
```

---

## 🚀 Paso a Paso: Puesta en Marcha del Proyecto

Ahora que tu máquina tiene el motor preparado, configuremos el repositorio de la app de delivery.

### Paso 6: Clonar el Repositorio
Ve a la carpeta donde prefieras guardar tus proyectos (por ejemplo, `~/Developer` o `~/Proyectos`):

```bash
mkdir -p ~/Proyectos
cd ~/Proyectos
git clone <URL_DEL_REPOSITORIO> delivery-app
cd delivery-app
```

---

### Paso 7: Instalar Dependencias del Monorepo con pnpm
En la raíz del proyecto ejecutamos:

```bash
pnpm install
```

> Gracias a `pnpm-workspace.yaml`, este comando vinculará automáticamente todas las aplicaciones y servicios compartiendo paquetes sin duplicar archivos.

---

### Paso 8: Levantar la Infraestructura Base (Postgres, RabbitMQ, Redis)
Gracias a los scripts configurados en el proyecto, puedes levantar todo con un solo comando desde la raíz:

```bash
pnpm infra:up
```
*(O de forma equivalente: `docker compose -f infra/docker-compose.yml up -d`)*.

---

### Paso 9: Verificar que Todo Esté Sano (Healthchecks)
Verifica el estado de los contenedores:

```bash
pnpm infra:status
```

Deberías ver 3 servicios corriendo:
1. `delivery_postgres`: Estado `healthy` en puerto `5432`.
2. `delivery_rabbitmq`: Estado `healthy` en puertos `5672` (AMQP) y `15672` (UI Web).
3. `delivery_redis`: Estado `healthy` en puerto `6379`.

#### 🌐 Inspección Visual Inmediata:
- **Panel Web de RabbitMQ:** Abre en tu navegador [http://localhost:15672](http://localhost:15672)  
  - *Usuario:* `guest`
  - *Contraseña:* `guest`
- **Dashboard Pixel Art:** Ejecuta en la terminal:
  ```bash
  pnpm dashboard
  ```
  *(Se abrirá tu navegador predeterminado mostrando la oficina retro de agentes en tiempo real)*.

---

## 🎛️ Comandos Útiles para el Día a Día

| Tarea | Comando desde la raíz |
| :--- | :--- |
| **Levantar contenedores** | `pnpm infra:up` |
| **Ver estado y salud** | `pnpm infra:status` |
| **Ver logs en tiempo real** | `pnpm infra:logs` |
| **Detener contenedores** | `pnpm infra:down` |
| **Abrir Pixel Dashboard** | `pnpm dashboard` |

---

## 🛡️ Medidas de Cuidado para tu MacBook Air M1

1. **Evita emuladores de Android/iOS pesados:** Para probar las apps en fases móviles, usaremos **Expo Go** en tu smartphone físico escaneando un código QR. Esto ahorra hasta 5 GB de RAM.
2. **Modo Foco de Servicio:** Durante cada fase, solo mantendremos encendido el microservicio en el que estemos trabajando (ej. `pedidos` en la Fase 1), sin gastar energía en servicios inactivos.
3. **Límites de RAM en Docker:** Ya dejamos fijado en `docker-compose.yml` un tope máximo de 1.2 GB entre Postgres, RabbitMQ y Redis. Tu Mac siempre se mantendrá fresca.
