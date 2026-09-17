-- ==============================================================
-- Script de Inicialización de la Base de Datos - Delivery App
-- Ejecutado automáticamente por Docker al crear el contenedor
-- ==============================================================

-- Habilitar extensiones para generación de UUIDs y funciones criptográficas
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Creación de Schemas Aislados por cada Microservicio
-- Esto garantiza independencia lógica de datos sin necesidad de levantar 6 bases de datos distintas
CREATE SCHEMA IF NOT EXISTS pedidos;
CREATE SCHEMA IF NOT EXISTS usuarios;
CREATE SCHEMA IF NOT EXISTS pagos;
CREATE SCHEMA IF NOT EXISTS catalogo;
CREATE SCHEMA IF NOT EXISTS despacho;
CREATE SCHEMA IF NOT EXISTS notificaciones;

-- Registro informativo en consola de PostgreSQL
DO $$
BEGIN
   RAISE NOTICE '=========================================================';
   RAISE NOTICE ' Delivery DB: Schemas inicializados con éxito!';
   RAISE NOTICE ' Schemas: pedidos, usuarios, pagos, catalogo, despacho, notificaciones';
   RAISE NOTICE '=========================================================';
END $$;
