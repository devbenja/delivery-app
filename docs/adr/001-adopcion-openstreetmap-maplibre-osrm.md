# ADR-001: Adopción de OpenStreetMap (OSM), MapLibre GL y OSRM Self-Hosted para Geolocalización y Ruteo

- **Estado:** Aprobado
- **Fecha:** 2026-09-19
- **Decisores:** Benja (Tech Lead & Product Owner), Agente 1 (Arquitecto & QA)
- **Área:** Arquitectura de Datos Geoespaciales y Frontend Mobile/Web

---

## 1. Contexto y Problema

Una plataforma de delivery de tres lados (Cliente, Comercio, Repartidor) depende fuertemente de tres servicios geoespaciales:
1. **Visualización:** Despliegue de mapas interactivos en aplicaciones móviles (React Native) y paneles web (React).
2. **Búsqueda de Direcciones (Geocoding):** Conversión de texto de direcciones en coordenadas de latitud/longitud y viceversa.
3. **Cálculo de Rutas y Distancias (Routing & ETA):** Determinación del trayecto óptimo entre el local gastronómico y el domicilio del cliente, cálculo de tiempos estimados de llegada (ETA) y costo de envío.

### El Riesgo Financiero de las APIs Propietarias:
Soluciones líderes como **Google Maps Platform** cobran aproximadamente:
- **$7.00 USD por cada 1,000 cargas** de mapas dinámicos.
- **$5.00 USD por cada 1,000 consultas** de direcciones (Geocoding).
- **$5.00 a $10.00 USD por cada 1,000 cálculos de ruta** (Directions API).

En un escenario operativo moderado de **10,000 pedidos mensuales**, donde los repartidores actualizan su posición periódicamente y los clientes monitorean la entrega en vivo, la factura de Google Maps puede superar con facilidad los **$400 a $800 USD mensuales**, destruyendo la rentabilidad unitaria del negocio en etapas tempranas.

---

## 2. Opciones Consideradas

### Opción A: Google Maps Platform
- **Ventajas:** Máxima precisión en números domiciliarios en casi cualquier ciudad, soporte oficial extenso.
- **Desventajas:** Costos exorbitantes a escala, facturación impredecible, riesgo de suspensión de cuenta ante picos de tráfico.

### Opción B: Mapbox Platform
- **Ventajas:** Excelente SDK móvil y diseño visual moderno. Generoso nivel gratuito (50,000 cargas/mes).
- **Desventajas:** Aunque más económico que Google (~60% menos), sigue siendo una API propietaria con costos crecientes a partir de 1,000 pedidos/día.

### Opción C: Ecosistema OpenStreetMap (OSM) + MapLibre GL + OSRM Self-Hosted (Seleccionada)
- **Visualización:** **MapLibre GL** (bifurcación open-source y comunitaria de Mapbox GL).
- **Proximidad de Repartidores:** **Redis 7 Geo** (`GEOADD`, `GEOSEARCH`) en memoria RAM (< 2 ms).
- **Geocoding:** Proveedores abiertos (LocationIQ / Nominatim) con capas gratuitas de hasta 10,000 peticiones diarias.
- **Ruteo y Matrices de Distancia:** Contenedor Docker con **OSRM (Open Source Routing Machine)** alimentado por extractos regionales libres de OpenStreetMap (`.osm.pbf`).

---

## 3. Decisión

Se adopta la **Opción C: Ecosistema Abierto y Self-Hosted basado en OpenStreetMap**:
1. En el frontend móvil (React Native / Expo) y web (React) utilizaremos **MapLibre GL**.
2. En el backend (`despacho`), utilizaremos **Redis Geo** para el rastreo y asignación por proximidad de repartidores.
3. Para el cálculo de rutas y tiempos de entrega, utilizaremos **OSRM en un contenedor Docker**, garantizando **$0 USD en costos de licencia por cálculo de ruta**.

---

## 4. Consecuencias

### Positivas (+):
- **Cero costo de licenciamiento de ruteo:** Se pueden calcular millones de rutas entre comercios y comensales sin pagar a proveedores externos.
- **Latencia ultrabaja:** El motor OSRM corre en la misma red local/Docker de los microservicios, respondiendo en 1 a 3 milisegundos en lugar de viajar por internet hacia servidores de Google.
- **Independencia de proveedor (No Vendor Lock-in):** Si se cambia de servidor o nube, la cartografía y el ruteo viajan con el código.

### Negativas / Desafíos Mitigados (-):
- **Descarga de mapa regional:** Se debe descargar el archivo `.osm.pbf` correspondiente a la ciudad o provincia donde operará la app (ej. 50 MB a 150 MB). *Mitigación: Automatizado mediante script en la carpeta `/infra`.*
- **Consumo de memoria de OSRM:** OSRM carga el grafo de calles en RAM (~100 MB a 250 MB para una ciudad mediana). *Mitigación: Perfectamente soportado tanto en la MacBook M1 como en servidores VPS básicos de 2 GB de RAM.*
