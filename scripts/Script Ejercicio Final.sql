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
	-- Si quiero que aparezcan todos los nombres de películas, si no existen en inventario la cantidad será 0
SELECT 
	"title", 
	COUNT(i."inventory_id") AS "cantidad_disponible"
FROM "film" f
	LEFT JOIN "inventory" i -- Con el LEFT JOIN me aseguro de que estan todas las películas se muestran aunque NO esten en inventario
	ON f."film_id" = i."film_id"
GROUP BY "title"
;

	-- Si queremos que sólo se muestre el nombre de las peliculas que existen en el inventario 
SELECT "title", COUNT(i."inventory_id") AS "cantidad_disponible"
FROM "film" f
	INNER JOIN "inventory" i 
	ON f."film_id" = i."film_id"
GROUP BY "title"
;

-- 30. Obtener los actores y el número de películas en las que ha actuado.
WITH peliculas_actor AS ( 
	SELECT "actor_id", COUNT(*) AS "numero_peliculas" -- Creamos una CTE para realizar el conteo de películas por actor
	FROM "film_actor" fa
	GROUP BY "actor_id"
	)
SELECT  
	CONCAT(a."first_name", ' ', a."last_name") AS "actor", 
	pa."numero_peliculas"
FROM "actor" a
	JOIN peliculas_actor pa -- Hacemos el JOIN con la tabla actors para poder mostrar los nombres en vez del actor_id
	ON a."actor_id" = pa."actor_id";

-- 31. Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados.
	-- Solo 
SELECT 
    f."title",
    CONCAT(a."first_name", ' ', a."last_name") AS "nombre_actor"
FROM "film" f
	LEFT JOIN "film_actor" fa  -- LEFT JOIN para que se muestren TODAS las películas
	ON f."film_id" = fa."film_id"
	LEFT JOIN "actor" a 
	ON fa."actor_id" = a."actor_id"
ORDER BY a."first_name" NULLS FIRST; -- Nos permite mostrar las peliculas sin actores asociados al principio para confirmar

-- 32. Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna película.
SELECT 
	CONCAT(a."first_name", ' ', a."last_name") AS "nombre_actor",
	f."title"
FROM "actor" a
	LEFT JOIN "film_actor" fa  -- LEFT JOIN para que se muestren TODOS los actores
	ON a."actor_id" = fa."actor_id"
	LEFT JOIN "film" f
	ON fa."film_id" = f."film_id"
ORDER BY f."title" ASC NULLS FIRST; -- Mestra los actores sin película primero para confirmar (en este caso no hay)

-- 33. Obtener todas las películas que tenemos y todos los registros de alquiler.
SELECT f."title", r."rental_id"
FROM "film" f
	FULL JOIN "inventory" i -- FULL JOIN para asegurarnos de que entran todos los registros, de todas las tablas
	ON f."film_id" = i."film_id"
	FULL JOIN "rental" r
	ON i."inventory_id" = r."inventory_id"
ORDER BY f."title" NULLS FIRST
;

	-- Podemos ver cuantas veces se ha alquilado cada película
SELECT f."title", COUNT(r."rental_id")
FROM "film" f
	FULL JOIN "inventory" i -- FULL JOIN para asegurarnos de que entran todos los registros, de todas las tablas
	ON f."film_id" = i."film_id"
	FULL JOIN "rental" r
	ON i."inventory_id" = r."inventory_id"
GROUP BY f."title"
ORDER BY COUNT(r."rental_id") DESC -- Primero las que mas se han alquilado
;

-- 34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.
SELECT c."customer_id", c."first_name", c."last_name", t."gasto_total"
FROM "customer" c
	JOIN (
	  SELECT "customer_id", SUM("amount") AS "gasto_total"
	  FROM "payment"
	  GROUP BY "customer_id"
	  ORDER BY SUM("amount") DESC
	  LIMIT 5
	) t ON c."customer_id" = t."customer_id"
ORDER BY t."gasto_total" DESC;

-- 35. Selecciona todos los actores cuyo primer nombre es 'Johnny'.
SELECT *
FROM "actor"
WHERE "first_name" = UPPER('Johnny')
;

-- 36. Renombra la columna “first_name” como Nombre y “last_name” como Apellido.
ALTER TABLE "actor"  RENAME COLUMN "first_name" TO "Nombre";

ALTER TABLE "actor"  RENAME COLUMN "last_name" TO "Apellido";
	
	-- Y comprobamos que se han renombrado correctamente
SELECT "Nombre", "Apellido"
FROM "actor"
;

	-- Volvemos a dejarla como estaba para evitar errores en las queries anteriores
-- ALTER TABLE "actor"  RENAME COLUMN "Nombre" TO "first_name";

-- ALTER TABLE "actor"  RENAME COLUMN "Apellido" TO "last_name";

-- 37. Encuentra el ID del actor más bajo y más alto en la tabla actor.
SELECT MIN("actor_id") AS "mas_bajo", MAX("actor_id") AS "mas_alto"
FROM "actor"
;

-- 38. Cuenta cuántos actores hay en la tabla “actor” (valdría igual el actor_id máximo)
SELECT COUNT(*) AS "numero_actores"
FROM "actor"
;

-- 39. Selecciona todos los actores y ordénalos por apellido en orden ascendente.
SELECT *
FROM "actor"
ORDER BY "last_name" -- Por defecto, se ordena de manera ascendente
;

-- 40. Selecciona las primeras 5 películas de la tabla “film”.
SELECT "film_id", "title"
FROM "film"
ORDER BY "film_id"
LIMIT 5;

-- 41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. ¿Cuál es el nombre más repetido?
SELECT "first_name", COUNT("actor_id")
FROM "actor"
GROUP BY "first_name"
ORDER BY COUNT("actor_id") DESC, "first_name"  -- Ordenamos en funcion de los nombres mas repetidos primero y despues alfabeticamente
;

-- 42. Encuentra todos los alquileres y los nombres de los clientes que los realizaron.
SELECT 
	r."rental_id", 
	CONCAT(c."first_name", ' ', c."last_name") AS "cliente",
	DATE(r."rental_date")
FROM "rental" r
	JOIN "customer" c
	ON r."customer_id" = c."customer_id"
;

-- 43. Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.
SELECT 
	CONCAT(c."first_name", ' ', c."last_name") AS "cliente",
	r."rental_id"
FROM "customer" c
	LEFT JOIN "rental" r
	ON c."customer_id" = r."customer_id"
ORDER BY "cliente"
;

	-- Si además quisiera ver el nombre de las películas que han alquilado en vez del id de alquiler:
	WITH pelicula_alquilada AS (
		SELECT "title", "customer_id"
		FROM "film" f
			JOIN "inventory" i
			ON f."film_id" = i."film_id"
			JOIN "rental" r
			ON i."inventory_id" = r."inventory_id"
		)
	SELECT 
		CONCAT(c."first_name", ' ', c."last_name") AS "cliente",
		"title"
	FROM "customer" c
		LEFT JOIN pelicula_alquilada pa
		ON c."customer_id" = pa."customer_id"
	ORDER BY "cliente"
	;
	

-- 44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta? ¿Por qué? Deja después de la consulta la contestación.
SELECT COUNT(*)
FROM "film" f
	CROSS JOIN "film_category" fc
	CROSS JOIN "category" c
	/* CROSS JOIN genera todas las combinaciones posibles entre las filas de las tablas, que pueden llegar a tener un enorme peso sin aportar información
	 	real y útil de cara a hacer un análisis
	 */

-- 45. Encuentra los actores que han participado en películas de la categoría 'Action'.
WITH "cat_peliculas" AS (
	SELECT 	
		fc."film_id"
	FROM "film_category" fc
		JOIN "category" c
		ON fc."category_id" = c."category_id"
	WHERE UPPER(c."name") = 'ACTION' -- Para asegurarnos de que todas las peliculas categorizadas como 'Action' se incluyan esten escritas con mayus o minus
	)
SELECT 
	INITCAP(CONCAT(a."first_name", ' ', a."last_name")) AS "actor" -- INITCAP para que el texto este primera con mayus, resto en minus
FROM "actor" a
	JOIN "film_actor" fa
	ON a."actor_id" = fa."actor_id"
WHERE fa."film_id" IN (SELECT "film_id" FROM "cat_peliculas")
ORDER BY "actor"
;

  -- Versión solo con JOINS (más eficiente)
	SELECT 
	    INITCAP(CONCAT(a."first_name", ' ', a."last_name")) AS "actor"
	FROM "actor" a
		JOIN "film_actor" fa 
		ON a."actor_id" = fa."actor_id"
		JOIN "film_category" fc 
		ON fa."film_id" = fc."film_id"
		JOIN "category" c 
		ON fc."category_id" = c."category_id"
	WHERE UPPER(c."name") = 'ACTION'
	ORDER BY "actor"
  ;
  
 -- 46. Encuentra todos los actores que no han participado en películas.
SELECT 
	INITCAP(CONCAT(a."first_name", ' ', a."last_name")) AS "actor"
FROM "actor" a
	LEFT JOIN "film_actor" fa -- Con LEFT JOIN nos aseguramos de que seleccionamos a TODOS los actores
	ON a."actor_id" = fa."actor_id"
WHERE fa."film_id" IS NULL -- Y fltramos por aquellos que NO estan asociados a ninguna película (a través de film_id): NO hay actores sin película registardos

-- 47. Selecciona el nombre de los actores y la cantidad de películas en las que han participado.
SELECT 
	INITCAP(CONCAT(a."first_name", ' ', a."last_name")) AS "actor",
	COUNT(fa."film_id") AS "numero_peliculas"
FROM "actor" a
	JOIN "film_actor" fa 
	ON a."actor_id" = fa."actor_id"
GROUP BY "actor"
ORDER BY "numero_peliculas" DESC -- ordenamos de manera descendente mostrando primero los actores que han participado en más películas
;

-- 48. Crea una vista llamada “actor_num_peliculas” que muestre los nombres de los actores y el número de películas en las que han participado.
CREATE VIEW actor_num_peliculas AS (
	SELECT 
		INITCAP(CONCAT(a."first_name", ' ', a."last_name")) AS "actor",
		COUNT(fa."film_id") AS "numero_peliculas"
	FROM "actor" a
		JOIN "film_actor" fa 
		ON a."actor_id" = fa."actor_id"
	GROUP BY "actor"
	)
;

	-- Comprobamos que se ha creado correctamente
	SELECT *
	FROM "actor_num_peliculas"
	;
	
-- 49. Calcula el número total de alquileres realizados por cada cliente.
WITH alquileres_cliente AS (
	SELECT "customer_id", COUNT("rental_id") AS "total_alquileres"
	FROM "rental"
	GROUP BY "customer_id"
	)
SELECT 
	INITCAP(CONCAT(c."first_name", ' ', c."last_name")) AS "cliente",
	"total_alquileres"
FROM "alquileres_cliente" ac
	JOIN "customer" c
	ON ac."customer_id" = c."customer_id"
;

-- 50. Calcula la duración total de las películas en la categoría 'Action'.
WITH cat_peliculas AS (
	SELECT "film_id"
	FROM "film_category"
	WHERE "category_id" IN (
		SELECT "category_id"
		FROM "category"
		WHERE UPPER("name") = 'ACTION'
		)
	)
SELECT SUM("length") AS "duracion_total_accion"
FROM "film" f
	JOIN cat_peliculas ca
	ON f."film_id" = ca."film_id"
;

-- 51. Crea una tabla temporal llamada “cliente_rentas_temporal” para almacenar el total de alquileres por cliente.
CREATE TEMPORARY TABLE cliente_rentas_temporal AS (
    SELECT 
        INITCAP(CONCAT(c."first_name", ' ', c."last_name")) AS "cliente",
        COUNT(r."rental_id") AS "total_alquileres"
    FROM "customer" c
    LEFT JOIN "rental" r ON c."customer_id" = r."customer_id"
    GROUP BY c."customer_id", c."first_name", c."last_name"
);


	-- Verificar que la tabla temporal se ha creado correctamente
	SELECT * FROM cliente_rentas_temporal
	ORDER BY "total_alquileres" DESC;
	


