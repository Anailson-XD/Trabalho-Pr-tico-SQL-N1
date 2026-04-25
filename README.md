# ⛩️ Trabalho Prático com MyAnimeList

## ☯ Contexto:
O banco foi construído em PostgreSQL (via Supabase) utilizando um recorte de dados reais extraídos do Kaggle. Pegamos dados do site MyAnimeList como: animes, usuarios, notas de avaliação, status (completo, dropado, assistindo).

### 愛 Modelagem:
Foram Utilizadas 5 Tabelas ( users, animes, user_watches, watch_status, log_auditoria_notas )

### Soluções:
Pegamos uma planilha gigante e meio bagunçada da internet. Para facilitar nosso sistema, criamos uma 'sala de espera'. O banco de dados olhou todo mundo que estava lá, barrou os animes que estavam duplicados e só deixou entrar no sistema oficial os dados limpinhos e corretos.

✅ Questão 1: Nós construímos um painel que conta a história da comunidade ao longo dos anos. O banco calcula sozinho quantos usuários novos entraram a cada ano, faz um ranking de qual país trouxe mais gente e nos diz se o site cresceu ou encolheu em comparação com o ano anterior, mostrando o total acumulado na história.

✅ Questão 2: Nós criamos um 'detector de anomalias' para manter as estatísticas do site justas. O sistema vasculha os dados e dedura os espertinhos: 'Opa, esse cara marcou que terminou o anime, mas assistiu zero episódios!'. O banco classifica isso automaticamente como 'Prioridade 1' para a equipe de moderação investigar se é um robô.

✅ Questão 3: Colocamos um 'segurança' na porta do nosso sistema. Se um hacker ou um erro tentar colocar uma nota impossível para um anime (tipo 15, sendo que o máximo é 10), o segurança não só barra a operação na hora, como também grava um 'boletim de ocorrência' dizendo a data, a hora e a foto exata do código que o invasor usou.

✅ Questão 4: Fizemos um gerador de relatórios onde o usuário só precisa 'apertar os botões'. Se o gerente quiser saber: 'Quais são os animes que já terminaram de lançar e têm pelo menos 12 episódios?', o banco faz os cálculos matemáticos complexos por trás dos panos e gera uma tabela pronta, dizendo a nota média e a porcentagem exata de pessoas que realmente não abandonaram o anime.

✅ Questão 5: Entendemos que o Diretor da empresa e o cara do Suporte precisam olhar para os dados de forma diferente. Por isso, criamos duas 'lentes':

  1. A lente do Gerente: Mostra a 'visão de helicóptero' (resumo de qual classificação etária faz mais sucesso no site todo).

  2. A lente do Suporte: Mostra o 'microscópio' (um feed de atividades ao vivo mostrando exatamente o nome de quem deu a nota e o que ele      está assistindo agora).
