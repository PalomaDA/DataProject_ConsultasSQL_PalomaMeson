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
SELECT "actor_id", CONCAT("first_name", ' ', "last_name") -- Concatenamos nombre y apellido para verlos en una sola columna
FROM "actor"
WHERE "actor_id" BETWEEN 30 AND 40
ORDER BY "actor_id"
;

-- 4. Obtén las películas cuyo idioma coincide con el idioma original.
SELECT "title", "language_id", "original_language_id"
FROM "film"
WHERE "language_id" = "original_language_id" -- original_language_id tiene todo valores nulos
OR "original_language_id" IS NULL -- Si interpretamos los valores nulos como iguales a lenguaje_id
;

-- 5. Ordena las películas por duración de forma ascendente.
SELECT "title", "length"
FROM "film"
ORDER BY "length" -- Por defecto se ordena de manera ascendente (ASC)
;

-- 6. Encuentra el nombre y apellido de los actores que tengan ‘Allen’ en su apellido.
SELECT "first_name", "last_name"
FROM "actor"
WHERE "last_name" = 'ALLEN'
;

-- 7. Encuentra la cantidad total de películas en cada clasificación de la tabla “film” y muestra la clasificación junto con el recuento.
SELECT rating, COUNT("film_id") AS "film_count"
FROM "film"
GROUP BY "rating"
;

-- 8. Encuentra el título de todas las películas que son ‘PG-13’ o tienen una duración mayor a 3 horas en la tabla film.
SELECT "title", "rating", "length"
FROM "film"
WHERE "rating" = 'PG-13' OR "length" > 60 * 3 -- Como la duracion esta en minutos, multiplicamos 60 min que tiene una hora por 3
;

-- 9. Encuentra la variabilidad de lo que costaría reemplazar las películas.
SELECT 
	ROUND(AVG("replacement_cost"),2) AS "Media",
	ROUND(VARIANCE("replacement_cost"),2) AS "Varianza", 
	ROUND(STDDEV("replacement_cost"),2) AS "Desviación"
-- Calculculamos la varianza y la desviación típica del coste de remplazo y redondeamos a dos decimales para mayor legibilidad
FROM "film"
;

	/* Según los resultados intepretamos que hay una variabilidad considerable 
 	* Confirmamos calculando el Coeficiente de Variación (desviacion/media)*100
	*/
	SELECT 
		ROUND((STDDEV("replacement_cost")/AVG("replacement_cost")) * 100,2)
		AS "Coeficiente de Variación"
	FROM "film"
	;
	-- CV > 30, por tanto se trata de unos datos NO homogéneos


-- 10. Encuentra la mayor y menor duración de una película de nuestra BBDD.
SELECT 
	MAX("length") AS "Mayor Duración",
	MIN("length") AS "Menor Duración"
FROM "film"
;

-- 11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día.
SELECT DATE("payment_date"), "amount"
FROM "payment"
ORDER BY "payment_date" DESC -- Ordenamos de manera descendente para obtener los últimos alquileres
OFFSET 2 -- Indicamos que se salte el último y el penúltimo
LIMIT 1 -- Y muestre solo un día, el antepenúltimo
;

-- 12. Encuentra el título de las películas en la tabla “film” que no sean ni ‘NC-17’ ni ‘G’ en cuanto a su clasificación.
SELECT "title", "rating" 
FROM "film"
WHERE "rating" NOT IN ('NC-17', 'G')
;

/* 13. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y 
muestra la clasificación junto con el promedio de duración.
*/
SELECT "rating", ROUND(AVG("length"),2) AS "promedio_duracion" 
FROM "film"
GROUP BY "rating"
;

-- 14. Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.
SELECT "title", "length"
FROM "film"
WHERE "length" > 180
;

-- 15. ¿Cuánto dinero ha generado en total la empresa?
SELECT SUM("amount") AS "beneficio_total" -- Calculamos la suma total de pagos realizados
FROM "payment"
;
	-- 67.416,51

-- 16. Muestra los 10 clientes con mayor valor de id.
SELECT 
	customer_id AS "id", 
	CONCAT("first_name", ' ', "last_name") AS "nombre_cliente"
FROM customer
ORDER BY "customer_id" DESC -- Ordenamos por el valor de id de manera descendente (arriba los valores más altos)
LIMIT 10 -- Y mostramos únicamente los 10 primeros
;

-- 17. Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igby’.
	-- Obteniendo el actor_id mentiende una subconsulta
	SELECT CONCAT("first_name", ' ', "last_name") -- Seleccionamos el nombre y apellido
	FROM "actor"
	WHERE "actor_id" IN ( 
		SELECT "actor_id"
		FROM "film_actor" AS fa
		JOIN "film" AS f
		ON fa."film_id" = f."film_id"
		WHERE "title" = 'EGG IGBY')
	;

	-- Realizando tres JOINS 
	SELECT DISTINCT CONCAT(a."first_name", ' ', a."last_name") AS "Actor"
	FROM "actor" AS a
	JOIN "film_actor" fa ON a."actor_id" = fa."actor_id"
	JOIN "film" f ON fa."film_id" = f."film_id"
	WHERE f."title" = 'EGG IGBY'
	;
	










