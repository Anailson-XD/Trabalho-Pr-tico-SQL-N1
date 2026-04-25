WITH Metricas_Anuais AS (
    SELECT 
        EXTRACT(YEAR FROM join_date) AS ano,
        COUNT(user_id) AS total_usuarios_ano
    FROM users
    WHERE join_date IS NOT NULL
    GROUP BY EXTRACT(YEAR FROM join_date)
),
Tendencia_Comunidade AS (
    SELECT 
        ano,
        total_usuarios_ano,
        SUM(total_usuarios_ano) OVER (ORDER BY ano) AS total_acumulado,
        ROUND(
            ((total_usuarios_ano - LAG(total_usuarios_ano) OVER (ORDER BY ano))::numeric / 
            NULLIF(LAG(total_usuarios_ano) OVER (ORDER BY ano), 0)) * 100
        , 2) AS variacao_percentual
    FROM Metricas_Anuais
),
Locais_Por_Ano AS (
    SELECT 
        EXTRACT(YEAR FROM join_date) AS ano,
        location,
        COUNT(user_id) AS usuarios_no_local
    FROM users
    WHERE join_date IS NOT NULL 
      AND location IS NOT NULL 
      AND location <> '' 
      AND location <> 'Unknown'
    GROUP BY EXTRACT(YEAR FROM join_date), location
),
Ranking_Locais AS (
    SELECT 
        ano,
        location,
        usuarios_no_local,
        DENSE_RANK() OVER (PARTITION BY ano ORDER BY usuarios_no_local DESC) AS ranking
    FROM Locais_Por_Ano
)
SELECT 
    t.ano,
    t.total_usuarios_ano AS novos_usuarios_no_ano,
    t.total_acumulado,
    t.variacao_percentual AS "crescimento_ano_a_ano_%",
    r.ranking AS top_local,
    r.location AS local_destaque,
    r.usuarios_no_local
FROM Tendencia_Comunidade t
JOIN Ranking_Locais r ON t.ano = r.ano
WHERE r.ranking <= 3
ORDER BY t.total_usuarios_ano DESC, r.ranking ASC;
