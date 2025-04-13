# Proyecto SQL – Lógica de Consultas

Este proyecto forma parte del módulo de SQL del Master en Ciencia de Datos impartido por Hack(io) - thePower y tiene como objetivo resolver una serie de ejercicios utilizando consultas SQL aplicadas a una base de datos relacional.

## Estructura del repositorio

- `README.md`: documento actual que resume el proceso y contiene este informe.
- `data/`: Contiene el diagrama proporcionado con la estructura de la base de datos y el PDF con los enunciados.
- `scripts/`: Contiene el script todas las consultas resueltas, numeradas y comentadas con su enunciado.
   - (13/04/25) Se incluye un scrips adicional con las correcciones del ejercicio.

---

## Objetivos del proyecto

- Practicar operaciones fundamentales en SQL: `SELECT`, `JOIN`, `GROUP BY`, `HAVING`, subconsultas, funciones agregadas, etc.
- Aprender a estructurar consultas complejas usando CTEs y tablas temporales.
- Generar informes claros sobre los datos consultados.
- Aplicar buenas prácticas de legibilidad, eficiencia y optimización.

---

## Enfoque seguido

1. Se analizó el **PDF del enunciado** con todos los ejercicios propuestos.
2. Se creó un archivo `.sql` con **cada consulta identificada por su número y enunciado**.
3. Se verificaron y probaron todas las consultas en una base de datos PostgreSQL.
4. Se optimizaron algunas consultas utilizando:
   - `CTEs` (`WITH`) para claridad en operaciones complejas
   - `JOINs` en lugar de subconsultas cuando mejoraban la eficiencia
   - Funciones como `INITCAP`, `CONCAT`, `COUNT(DISTINCT)` y `SUM` según el caso
5. Se validó que los resultados fueran coherentes con el esquema de la base de datos.

---

## Análisis y aprendizajes

Durante el desarrollo del proyecto se abordaron diversos conceptos clave de SQL, aplicados a un conjunto amplio de consultas sobre una base de datos relacional. Entre los aprendizajes más destacados se encuentran:

- Comprensión clara de las diferencias entre los distintos tipos de `JOIN` (`INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`, `CROSS JOIN`) y su aplicación según el contexto de los datos y los resultados esperados.
- Identificación de los casos en los que resulta más adecuado utilizar subconsultas, expresiones de tabla común (`CTEs`) o tablas temporales, dependiendo de la complejidad de la consulta y la necesidad de reutilización o estructuración por pasos.
- Uso correcto de funciones de agregación como `SUM`, `COUNT`, `AVG`, entre otras, en combinación con cláusulas `GROUP BY` y `HAVING` para realizar cálculos por agrupaciones de datos.
- Mejora en la estructuración y legibilidad de consultas, separando lógicamente cada parte del proceso, facilitando su mantenimiento y comprensión.
- Aplicación eficiente de filtros mediante la cláusula `WHERE`, optimizando el enfoque de las consultas para obtener resultados más específicos y relevantes.

---

## Autoría

Proyecto realizado por: **Paloma Mesón de Arana** 
E-mail de contacto: pmeson.da@gmail.com.
Repositorio desarrollado como parte del curso de SQL (DataProject: Lógica Consultas SQL).
