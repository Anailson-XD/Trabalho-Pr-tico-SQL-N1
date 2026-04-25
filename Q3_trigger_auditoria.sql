CREATE TABLE log_auditoria_notas (
    log_id SERIAL PRIMARY KEY,
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    usuario_banco VARCHAR(100),                    
    operacao VARCHAR(20),                          
    identificacao_problema VARCHAR(255),           
    sql_usado TEXT                                 
);


CREATE OR REPLACE FUNCTION fn_bloqueia_nota_invalida()
RETURNS TRIGGER AS $$
BEGIN

    IF NEW.score < 0 OR NEW.score > 10 THEN
        
        INSERT INTO log_auditoria_notas (
            usuario_banco, 
            operacao, 
            identificacao_problema, 
            sql_usado
        ) VALUES (
            current_user, 
            TG_OP, 
            'Violação de Regra: Tentativa de inserir nota ' || NEW.score || ' para o anime_id ' || NEW.anime_id, 
            current_query()
        );

        RAISE WARNING 'Operação Bloqueada: A nota deve estar entre 0 e 10. Nota informada: %', NEW.score;
        
        RETURN NULL;
    END IF;

    RETURN NEW;



CREATE TRIGGER trg_auditoria_nota
BEFORE INSERT OR UPDATE ON user_watches
FOR EACH ROW
EXECUTE FUNCTION fn_bloqueia_nota_invalida();
END;
$$ LANGUAGE plpgsql;
