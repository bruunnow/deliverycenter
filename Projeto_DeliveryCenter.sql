## 1- Qual o número de hubs por cidade?

SELECT 
	hub_state,
    COUNT(hub_id) AS contagem
FROM 
	exercicio4.hubs
GROUP BY
	hub_state;
    
###########################################

## 2- Qual o número de pedidos (orders) por status?

SELECT 
	order_status,
    COUNT(order_id) AS contagem
FROM 
	exercicio4.orders
GROUP BY
	order_status;
    
###########################################

## 3- Qual o número de lojas (stores) por cidade dos hubs?

SELECT 
	hub_state,
    COUNT(store_id) AS contagem
FROM
	exercicio4.hubs H, exercicio4.stores S 
WHERE
	H.hub_id = S.hub_id
GROUP BY
	hub_state;
    
############################################

## 4- Qual o maior e o menor valor de pagamento (payment_amount) registrado?

SELECT
	MAX(payment_amount) AS max_pagamento,
    MIN(payment_amount) AS min_pagamento
FROM 
	exercicio4.payments;
    
#############################################

## 5- Qual tipo de driver (driver_type) fez o maior número de entregas?

SELECT 
	driver_type,
    COUNT(DL.delivery_order_id) AS contagem
FROM
	exercicio4.drivers D, exercicio4.deliveries DL
WHERE
	D.driver_id = DL.driver_id
GROUP BY
	driver_type;

###############################################

## 6- Qual a distância média das entregas por tipo de driver (driver_modal)?

SELECT
	driver_modal,
    FLOOR(AVG(delivery_distance_meters)) AS media_dist_metros
FROM
	exercicio4.drivers D, exercicio4.deliveries DL
WHERE
	D.driver_id = DL.driver_id
GROUP BY
	driver_modal;

###############################################

## 7- Qual a média de valor de pedido (order_amount) por loja, em ordem decrescente?

SELECT
	S.store_id,
	store_name,
    ROUND(AVG(order_amount),2) AS media_valor_pedido
FROM
	exercicio4.orders O, exercicio4.stores S
WHERE
	O.store_id = S.store_id
GROUP BY
	store_name, S.store_id
ORDER BY
	media_valor_pedido DESC;
    
###############################################

## 8- Existem pedidos que não estão associados a lojas? Se caso positivo, quantos?

SELECT 
	 S.store_id,
	COUNT(O.order_id) AS contagem
FROM
	exercicio4.orders AS O LEFT JOIN exercicio4.stores S 
	ON O.store_id = S.store_id
WHERE
	S.store_id IS NULL
GROUP BY
	store_id;
    
##############################################

## 9- Qual o valor total de pedido (order_amount) no channel 'FOOD PLACE'?

SELECT
	C.channel_name,
	COUNT(order_amount) AS contagem
FROM
	exercicio4.channels C, exercicio4.orders O 
WHERE
	C.channel_id = O.channel_id
    AND channel_name = 'FOOD PLACE';
    
################################################

## 10- Quantos pagamentos foram cancelados (chargeback)?

SELECT
	payment_status,
    COUNT(payment_status) AS contagem
FROM
	exercicio4.payments P 
WHERE
	payment_status = 'CHARGEBACK'
GROUP BY
	payment_status;
    
################################################

## 11- Qual foi o valor médio dos pagamentos cancelados (chargeback)?

SELECT
	payment_status,
    FLOOR(AVG(payment_amount)) AS valor_medio
FROM
	exercicio4.payments P 
WHERE
	payment_status = 'CHARGEBACK'
GROUP BY
	payment_status;

##################################################

## 12- Qual a média do valor de pagamento por método de pagamento (payment_method) em ordem decrescente?

SELECT 
	payment_method,
    ROUND(AVG(payment_amount),2) AS media_valor
FROM 
	exercicio4.payments P 
GROUP BY
	P.payment_method
ORDER BY
	media_valor DESC;
    
##################################################

## 13- Quais métodos de pagamento tiveram valor médio superior a 100?

SELECT 
	payment_method,
    ROUND(AVG(payment_amount),2) AS media_valor
FROM 
	exercicio4.payments P 
GROUP BY
	P.payment_method
HAVING
	media_valor > 100
ORDER BY
	media_valor DESC;
    
###################################################

## 14- Qual a média de valor de pedido (order_amount) por estado do hub (hub_state), segmento da loja (store_segment) e tipo de canal (channel_type)?

SELECT
    ROUND(AVG(order_amount),2) AS valor_medio_pedido,
    H.hub_state,
    S.store_segment,
    C.channel_type
FROM
	exercicio4.orders AS O JOIN exercicio4.channels AS C ON O.channel_id = C.channel_id
    JOIN exercicio4.stores AS S ON O.store_id = S.store_id
    JOIN exercicio4.hubs AS H ON S.hub_id = H.hub_id
GROUP BY
	H.hub_state, S.store_segment, C.channel_type;
    
#####################################################

## 15- Qual estado do hub (hub_state), segmento da loja (store_segment) e tipo de canal (channel_type) teve média de valor de pedido (order_amount) maior que 450?

SELECT
    ROUND(AVG(order_amount),2) AS valor_medio_pedido,
    H.hub_state,
    S.store_segment,
    C.channel_type
FROM
	exercicio4.orders AS O JOIN exercicio4.channels AS C ON O.channel_id = C.channel_id
    JOIN exercicio4.stores AS S ON O.store_id = S.store_id
    JOIN exercicio4.hubs AS H ON S.hub_id = H.hub_id
GROUP BY
	H.hub_state, S.store_segment, C.channel_type
HAVING 
	valor_medio_pedido > 450;
    
###################################################

## 16- Qual o valor total de pedido (order_amount) por estado do hub (hub_state), segmento da loja (store_segment) e tipo de canal (channel_type)? Demonstre os totais intermediários e formate o resultado.

SELECT
    CASE WHEN S.store_segment IS NULL THEN 'Total Seg'
    ELSE S.store_segment
    END AS store_segment,
    CASE WHEN C.channel_type IS NULL THEN 'Total Ch'
    ELSE C.channel_type
    END AS channel_type,
    CASE WHEN H.hub_state IS NULL THEN 'Total Geral'
    ELSE H.hub_state
    END AS hub_state,
    ROUND(SUM(order_amount),2) AS valor_total
FROM
	exercicio4.orders AS O JOIN exercicio4.channels AS C ON O.channel_id = C.channel_id
    JOIN exercicio4.stores AS S ON O.store_id = S.store_id
    JOIN exercicio4.hubs AS H ON S.hub_id = H.hub_id
GROUP BY
	H.hub_state, S.store_segment, C.channel_type WITH ROLLUP
ORDER BY GROUPING (hub_state);

############################################################

## 17- Quando o pedido era do Hub do Rio de Janeiro (hub_state), segmento de loja 'FOOD', tipo de canal Marketplace e foi cancelado, qual foi a média de valor do pedido (order_amount)?

SELECT
    CASE WHEN S.store_segment IS NULL THEN 'Total Seg'
    ELSE S.store_segment
    END AS store_segment,
    CASE WHEN C.channel_type IS NULL THEN 'Total Ch'
    ELSE C.channel_type
    END AS channel_type,
    CASE WHEN H.hub_state IS NULL THEN 'Total Geral'
    ELSE H.hub_state
    END AS hub_state,
    O.order_status,
    ROUND(AVG(order_amount),2) AS media_total
FROM
	exercicio4.orders AS O JOIN exercicio4.channels AS C ON O.channel_id = C.channel_id
    JOIN exercicio4.stores AS S ON O.store_id = S.store_id
    JOIN exercicio4.hubs AS H ON S.hub_id = H.hub_id
WHERE
	H.hub_state = 'RIO DE JANEIRO'
    AND S.store_segment = 'FOOD'
    AND C.channel_type = 'MARKETPLACE'
    AND O.order_status = 'CANCELED'
GROUP BY
	H.hub_state, S.store_segment, C.channel_type, O.order_status;
    
########################################################

## 18- Quando o pedido era do segmento de loja 'GOOD', tipo de canal Marketplace e foi cancelado, algum hub_state teve total de valor do pedido superior a 100.000?

SELECT
    CASE WHEN S.store_segment IS NULL THEN 'Total Seg'
    ELSE S.store_segment
    END AS store_segment,
    CASE WHEN C.channel_type IS NULL THEN 'Total Ch'
    ELSE C.channel_type
    END AS channel_type,
    CASE WHEN H.hub_state IS NULL THEN 'Total Geral'
    ELSE H.hub_state
    END AS hub_state,
    O.order_status,
    ROUND(SUM(order_amount),2) AS valor_total
FROM
	exercicio4.orders AS O JOIN exercicio4.channels AS C ON O.channel_id = C.channel_id
    JOIN exercicio4.stores AS S ON O.store_id = S.store_id
    JOIN exercicio4.hubs AS H ON S.hub_id = H.hub_id
WHERE
    S.store_segment = 'GOOD'
    AND C.channel_type = 'MARKETPLACE'
    AND O.order_status = 'CANCELED'
GROUP BY
	H.hub_state, S.store_segment, C.channel_type, O.order_status
HAVING 
	valor_total > 100.000;
    
############################################################

## 19- Em que data houve a maior média de valor do pedido (order_amount)? Dica: Pesquise e use a função SUBSTRING().

SELECT
	CONCAT(SUBSTRING(O.order_created_day, 1, 2), '-',
            SUBSTRING(O.order_created_month, 1, 2), '-',
            SUBSTRING(O.order_created_year, 1, 4))
            AS data_pedido,
	ROUND(AVG(order_amount),2) AS media_valor
FROM
	exercicio4.orders O
GROUP BY
	data_pedido
ORDER BY
	media_valor DESC;
    
###########################################################

## 20- Em quais datas o valor do pedido foi igual a zero (ou seja, não houve venda)? Dica: Use a função SUBSTRING().

SELECT
	CONCAT(SUBSTRING(O.order_created_day, 1, 2), '-',
            SUBSTRING(O.order_created_month, 1, 2), '-',
            SUBSTRING(O.order_created_year, 1, 4))
            AS data_pedido,
	order_amount
FROM
	exercicio4.orders O
WHERE 
	order_amount = 0 OR order_amount IS NULL
GROUP BY
	data_pedido, order_amount;