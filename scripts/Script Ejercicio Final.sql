/*
PROYECTO FINAL SLQ DATA SCIENCE
*/

-- 1. Crea el esquema de la BBDD.
/*
1. Creamos una nueva BBDD en DBeaver y la seleccionamos "por defecto"
2. Abrimos el script de la BBDD (Archivo > Buscar archivo denominado)
3. Nos aseguramos de que el script esta asociado a postgres y lo ejecutamos
*/

-- 2. Muestra los nombres de todas las películas con una clasificación por edades de ‘R’.
SELECT "title"
FROM "film"
WHERE "rating" = 'R'
;

--3. Encuentra los nombres de los actores que tengan un “actor_id” entre 30 y 40.
SELECT "actor_id", CONCAT("first_name", ' ', "last_name")
FROM "actor"
WHERE "actor_id" BETWEEN 30 AND 40
ORDER BY "actor_id"
;

-- 4. Obtén las películas cuyo idioma coincide con el idioma original.
SELECT "title", "language_id", "original_language_id"
FROM "film"
--WHERE "language_id" = "original_language_id" -- original_language_id tiene todo valores nulos