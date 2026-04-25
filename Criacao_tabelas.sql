CREATE TABLE users (
    user_id INT PRIMARY KEY,
    username VARCHAR(150),
    gender VARCHAR(50),
    location VARCHAR(255),
    birth_date DATE,
    join_date DATE, 
    last_scraped_date TIMESTAMP
);

CREATE TABLE animes (
    anime_id INT PRIMARY KEY,
    title VARCHAR(255),
    url TEXT,
    image_path TEXT,
    airing_status VARCHAR(50),
    num_episodes INT,
    mpaa_rating VARCHAR(50),
    last_scraped_date TIMESTAMP,
    title_japanese VARCHAR(255),
    synopsis TEXT,
    title_english VARCHAR(255)
);

CREATE TABLE watch_status (
    status_id INT PRIMARY KEY,
    status_description VARCHAR(50)
);


INSERT INTO watch_status (status_id, status_description) VALUES 
(1, 'Watching'), (2, 'Completed'), (3, 'On Hold'), (4, 'Dropped'), (6, 'Plan to Watch');


CREATE TABLE user_watches (
    user_id INT,
    anime_id INT,
    score INT,
    status INT, 
    num_watched_episodes INT,
    data_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    PRIMARY KEY (user_id, anime_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (anime_id) REFERENCES animes(anime_id) ON DELETE CASCADE,
    FOREIGN KEY (status) REFERENCES watch_status(status_id) ON DELETE SET NULL
);


CREATE TABLE log_auditoria_notas (
    log_id SERIAL PRIMARY KEY,
    user_id INT,
    anime_id INT,
    nota_tentada INT,
    operacao VARCHAR(20),
    data_tentativa TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    motivo_bloqueio VARCHAR(255)
);
