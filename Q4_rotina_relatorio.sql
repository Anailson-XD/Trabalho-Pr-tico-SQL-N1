CREATE OR REPLACE FUNCTION fn_relatorio_desempenho_animes(
    p_status_anime VARCHAR DEFAULT 'Finished Airing',
    p_min_episodios INT DEFAULT 12
)
RETURNS TABLE (
    nome_anime VARCHAR,
    status_lancamento VARCHAR,
    total_avaliacoes BIGINT,
    nota_media NUMERIC,
    taxa_conclusao_pct NUMERIC
) AS $$
BEGIN
    IF p_min_episodios <= 0 THEN
        RAISE EXCEPTION 'Erro de Validação: O número mínimo de episódios deve ser maior que zero.';
    END IF;

    RETURN QUERY
    SELECT 
        a.title::VARCHAR AS nome_anime,
        a.airing_status::VARCHAR AS status_lancamento,
        COUNT(uw.user_id) AS total_avaliacoes,
        ROUND(AVG(NULLIF(uw.score, 0)), 2) AS nota_media, 
        ROUND(
            (SUM(CASE WHEN ws.status_description = 'Completed' THEN 1 ELSE 0 END)::NUMERIC / 
            NULLIF(COUNT(uw.user_id), 0)) * 100
        , 2) AS taxa_conclusao_pct
    FROM animes a
    JOIN user_watches uw ON a.anime_id = uw.anime_id
    JOIN watch_status ws ON uw.status = ws.status_id
    WHERE a.airing_status = p_status_anime
      AND a.num_episodes >= p_min_episodios
    GROUP BY a.title, a.airing_status
    HAVING COUNT(uw.user_id) >= 1 
    ORDER BY total_avaliacoes DESC, nota_media DESC;
END;
$$ LANGUAGE plpgsql;
