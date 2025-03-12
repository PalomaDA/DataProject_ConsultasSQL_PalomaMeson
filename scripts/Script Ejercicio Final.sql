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
	
-- 18. Selecciona todos los nombres de las películas únicos.
SELECT DISTINCT "title"
FROM "film"
;

-- 19. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “film”.
SELECT "title"
FROM "film" AS f
	JOIN "film_category" AS fc -- Unimos con la tabla intermedia
	ON f."film_id" = fc."film_id"
	JOIN "category" AS c -- Para unir finalmente lña tabla que contiene los nombres de las categorías
	ON fc."category_id" = c."category_id"
WHERE "length" > 180 -- Incluimos las condiciones de duración
	AND c."name" = 'Comedy' -- Y género
;

/* 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos y muestra el nombre de la categoría
junto con el promedio de duración.
*/

-- Version únicamente con joins
SELECT "name" AS "categoría", ROUND(AVG("length"), 2) AS "duracion promedio" -- Seleccionamos columnas a mostrar, redondeando el promedio para mayor legibilidad
FROM "category" c
	JOIN "film_category" fm -- Unimos a tabla intermedia
	ON c."category_id" = fm."category_id"
	JOIN "film" f -- Unimos a tabla que ques permite calcular el promedio de duración
	ON fm."film_id" = f."film_id" 
GROUP BY "name" -- Agrupamos por nombre de categoría 
HAVING AVG("length") > 110 -- E incluimos la condición de duración
;

-- Version utilicando una CTE (mejor rendimiento el segundo join se realiza después de filtrar los cálculos) *Preferible en BBDD grandes
WITH promedio_por_categoria AS ( -- Creamos una CTE con id_categoría y promedio ya filtrada
	SELECT fc."category_id", ROUND(AVG(f."length"),2) AS "promedio_duracion"
	FROM "film_category" fc
		JOIN "film" f
		ON fc."film_id" = f."film_id"
	GROUP BY fc."category_id"
	HAVING AVG(f."length") > 110
	)
SELECT c."name" AS "categoría", "promedio_duracion"
FROM "promedio_por_categoria" pc
JOIN "category" c -- Unimos la CTE a la tabla con los nombres de las categorias
ON pc."category_id" = c."category_id"
;

-- 21. ¿Cuál es la media de duración del alquiler de las películas?
SELECT AVG("rental_duration") AS "media_duracion_alquiler"
FROM "film"
;

-- 22. Crea una columna con el nombre y apellidos de todos los actores y actrices.
SELECT CONCAT("first_name", ' ', "last_name") AS "nombre_completo"
FROM "actor"
ORDER BY "nombre_completo" -- Ordenado alfabéticamente de manera ascendente 
;

-- 23. Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente.
SELECT COUNT("rental_id"), DATE("rental_date") -- Convertimos a fecha la columna "rental_date" (inicialmente timpestamp)
FROM "rental"
GROUP BY DATE("rental_date")
ORDER BY COUNT("rental_id") DESC -- Ordenamos por numero de alquileres de manera descendiente
;

-- 24. Encuentra las películas con una duración superior al promedio.
SELECT "title"
FROM "film"
WHERE "length" > (SELECT AVG("length") FROM "film")
;

	-- Con CTE
WITH duracion_promedio AS ( -- Primero calculamos la media de duración 
	SELECT AVG("length") AS "promedio"
	FROM "film" 
	)
SELECT "title"
FROM "film", duracion_promedio
WHERE "length" > duracion_promedio."promedio"
;

-- 25. Averigua el número de alquileres registrados por mes.
SELECT 
	EXTRACT(MONTH FROM "rental_date") AS "mes", -- Extraemos el mes de la fecha de alquiler (rental_date)
	COUNT("rental_id") AS "numero_alquileres" -- Contamos el numero de alquileres
FROM "rental"
GROUP BY "mes" -- Agrupado por mes
ORDER BY "mes" -- Y ordenado por mes de manera ascendente
;

-- 26. Encuentra el promedio, la desviación estándar y varianza del total pagado.
SELECT 
	-- Redondeamos a 2 decimales para una mejro legibilidad
	ROUND(AVG("amount"), 2) AS "media",
	ROUND(STDDEV("amount"), 2) AS "desviacion", 
	ROUND(VARIANCE("amount"), 2) AS "varianza"
FROM "payment"
;

-- 27. ¿Qué películas se alquilan por encima del precio medio?
	-- Calculamos el precio medio con una CTE
WITH precio_medio AS (
	SELECT AVG("rental_rate") AS "promedio_alquiler"
	FROM "film"
	)
SELECT "title", "rental_rate"
FROM "film", "precio_medio"
WHERE "rental_rate" > precio_medio."promedio_alquiler"
;

-- 28. Muestra el id de los actores que hayan participado en más de 40 películas.
SELECT fa."actor_id" AS "id_actor", COUNT(fa."film_id")
FROM "film_actor" fa
	JOIN "film" f 
	ON fa."film_id" = f."film_id"
GROUP BY fa."actor_id"
HAVING COUNT(fa."film_id") > 40
;

-- 29. Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible.
SELECT "title", COUNT(i."inventory_id")
FROM "film" f
	RIGHT JOIN "inventory" i
	ON f."film_id" = i."film_id"
GROUP BY "title"
;











