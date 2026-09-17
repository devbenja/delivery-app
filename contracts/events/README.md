# Contratos de Eventos Asíncronos (AsyncAPI)

En esta carpeta residirán las especificaciones formales de los eventos que viajan a través de **RabbitMQ** entre los microservicios.

## Estructura Estándar de Eventos:
Todo evento publicado en el bus debe contener los metadatos base:
- `event_id`: UUID único del evento (para deduplicación en consumidores).
- `trace_id`: ID de correlación W3C para rastreo distribuido con OpenTelemetry.
- `timestamp`: Fecha/hora en formato ISO 8601 UTC.
- `event_type`: Nombre del evento (ej: `pedido.creado.v1`).
- `payload`: Datos específicos del evento.
