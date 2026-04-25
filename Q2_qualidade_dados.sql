CREATE OR REPLACE VIEW vw_inconsistencia_episodios AS
WITH Analise_Inconsistencia AS (

    SELECT 
        u.user_id,
        u.username,
        a.title AS nome_anime,
        ws.status_description AS status_usuario,
        uw.num_watched_episodes AS eps_assistidos,
        a.num_episodes AS eps_totais
    FROM user_watches uw
    JOIN users u ON uw.user_id = u.user_id
    JOIN animes a ON uw.anime_id = a.anime_id
    JOIN watch_status ws ON uw.status = ws.status_id
    WHERE a.num_episodes > 0
)
SELECT 
    user_id,
    username,
    nome_anime,
    status_usuario,
    eps_assistidos,
    eps_totais,

    CASE
        WHEN status_usuario = 'Completed' AND eps_assistidos = 0 THEN 1
        WHEN eps_assistidos > eps_totais THEN 2
        WHEN status_usuario = 'Completed' AND eps_assistidos < eps_totais THEN 3
    END AS score_prioridade,

    CASE
        WHEN status_usuario = 'Completed' AND eps_assistidos = 0 THEN 'Conclusão Falsa (0 Eps)'
        WHEN eps_assistidos > eps_totais THEN 'Episódios Excedentes (Erro Digitação)'
        WHEN status_usuario = 'Completed' AND eps_assistidos < eps_totais THEN 'Conclusão Incompleta'
    END AS motivo_inconsistencia
FROM Analise_Inconsistencia

WHERE 
    (status_usuario = 'Completed' AND eps_assistidos = 0)
    OR (eps_assistidos > eps_totais)
    OR (status_usuario = 'Completed' AND eps_assistidos < eps_totais)
ORDER BY score_prioridade ASC, eps_assistidos DESC;
