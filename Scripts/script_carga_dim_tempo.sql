SET lc_time_names = 'pt_PT';

DROP TABLE IF EXISTS numbers_small;
CREATE TABLE numbers_small (number INT);
INSERT INTO numbers_small VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9);

-- Main-numbers table
DROP TABLE IF EXISTS numbers;
CREATE TABLE numbers (number BIGINT);
INSERT INTO numbers
SELECT thousands.number * 1000 + hundreds.number * 100 + tens.number * 10 + ones.number
FROM numbers_small thousands, numbers_small hundreds, numbers_small tens, numbers_small ones
LIMIT 1000000;

INSERT INTO dim_tempo (sk_tempo, data_atual)
SELECT number, DATE_ADD( '2015-01-01', INTERVAL number DAY )
FROM numbers
WHERE DATE_ADD( '2015-01-01', INTERVAL number DAY ) BETWEEN '2015-01-01' AND '2025-12-31'
ORDER BY number;

-- Update other columns based on the date.
UPDATE dim_tempo SET
ano            = DATE_FORMAT( data_atual, "%Y" ),
mes           = DATE_FORMAT( data_atual, "%M"),
mes_ano   = DATE_FORMAT( data_atual, "%m"),
dia_mes    = DATE_FORMAT( data_atual, "%d" ),
dia             = DATE_FORMAT( data_atual, "%W" ),
dia_semana     = DAYOFWEEK(data_atual),
tipo_dia         = IF( DATE_FORMAT( data_atual, "%W" ) IN ('Sábado','Domingo'), 'Fim de Semana', 'Dia da Semana'),
dia_ano     = DATE_FORMAT( data_atual, "%j" ),
semana_ano    = DATE_FORMAT( data_atual, "%V" ),
trimestre         = QUARTER(data_atual),
data_anterior    = DATE_ADD(data_atual, INTERVAL -1 DAY),
proxima_data        = DATE_ADD(data_atual, INTERVAL 1 DAY);

DROP TABLE IF EXISTS numbers_small;
DROP TABLE IF EXISTS numbers;