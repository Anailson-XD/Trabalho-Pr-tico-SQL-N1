CREATE OR REPLACE VIEW vw_painel_gerencial_classificacao AS
SELECT 

    CASE 
        WHEN a.mpaa_rating IS NULL OR a.mpaa_rating = '' OR a.mpaa_rating = 'Unknown' THEN 'Sem Classificação'
        ELSE a.mpaa_rating 
    END AS classificacao_indicativa,
    
    COUNT(DISTINCT a.anime_id) AS total_animes_no_catalogo,
    COUNT(uw.user_id) AS total_avaliacoes_recebidas,
    ROUND(AVG(NULLIF(uw.score, 0)), 2) AS nota_media_geral
FROM animes a
JOIN user_watches uw ON a.anime_id = uw.anime_id
GROUP BY 
    CASE 
        WHEN a.mpaa_rating IS NULL OR a.mpaa_rating = '' OR a.mpaa_rating = 'Unknown' THEN 'Sem Classificação'
        ELSE a.mpaa_rating 
    END
ORDER BY total_avaliacoes_recebidas DESC;




CREATE OR REPLACE VIEW vw_painel_analitico_avaliacoes AS
SELECT 
    uw.data_registro::DATE AS data_da_nota,
    u.username AS usuario,
    a.title AS nome_anime,
    uw.score AS nota_dada,
    ws.status_description AS status_atual
FROM user_watches uw
JOIN users u ON uw.user_id = u.user_id
JOIN animes a ON uw.anime_id = a.anime_id
JOIN watch_status ws ON uw.status = ws.status_id
ORDER BY uw.data_registro DESC;
