
DROP PROCEDURE crea_libro

DELIMITER //

CREATE PROCEDURE crea_libro(
    IN titolo VARCHAR(255), 
    IN cognome_autore VARCHAR(255), 
    IN nome_autore VARCHAR(255), 
    IN descrizione_genere VARCHAR(255), 
    IN nome_editore VARCHAR(50), 
    IN numero_pagine INT,
    IN anno INT
)
BEGIN

    DECLARE id_autore BIGINT;
    DECLARE id_genere BIGINT;
    DECLARE id_editore BIGINT;
    
-- seleziono l id autore
    SELECT autori_id INTO id_autore
    FROM autori
    WHERE cognome = cognome_autore 
    AND nome = nome_autore
    LIMIT 1;
    
    IF id_autore IS NULL 
    THEN
    SELECT CONCAT('EDITORE Non Censito');
    CALL LogAttivita('Autore Non Censito', 'crea_libro', 'Admin', 'warning');
    ELSE
    
    
-- seleziono l id genere     
    SELECT genere_id INTO id_genere 
    FROM genere
    WHERE descrizione = descrizione_genere
    LIMIT 1;
    IF id_genere IS NULL 
    THEN 
    INSERT INTO genere(descrizione)
    VALUES (descrizione_genere);
    CALL LogAttivita('genere aggiunto con successo', 'crea_libro', 'Admin', 'info');
    SELECT genere_id INTO id_genere 
    FROM genere
    WHERE descrizione = descrizione_genere
    LIMIT 1;
    END IF;
    
    
-- seleziono l id editore
    SELECT editore_id INTO id_editore 
    FROM editori 
    WHERE editori.nome = nome_editore
    LIMIT 1;
    IF id_editore IS NULL
    THEN
	CALL LogAttivita('editore Non Censito', 'crea_libro', 'Admin', 'warning');
    SELECT CONCAT('EDITORE Non Censito');
    ELSE
    
    INSERT INTO libri (nome, numero_pagine, autori_id, genere_id, editore_id, anno)
    VALUES (titolo, numero_pagine, id_autore, id_genere, id_editore, anno);
	CALL LogAttivita('libro aggiunto con successo', 'crea_libro', 'Admin', 'info');
    END IF;
    END IF;
END //

DELIMITER ;

CALL crea_libro('Fermo e Lucia', 'Manzoni', 'Alessandro', 'GENEREDIPROVAPERLOG', 'amadori', 500, 1880);

CALL Crea_libro('Le due città ','Dickens','Charles','Romanzo', 'amadori' , 190 , 1900);

CALL Crea_libro('Il Conte di Carmagnola','Manzoni','Alessandro','generediProva', 'editorenonesistente' , 190 , 1900);


DROP TABLE IF EXISTS log_oggetti_dB;

CREATE TABLE log_oggetti_db (
    id BIGINT AUTO_INCREMENT NOT NULL,
    messaggio VARCHAR(255),
    nome_oggetto_db VARCHAR(255),
    utente VARCHAR(255),
    livello_messaggio ENUM('info', 'warning', 'error'),
    data TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

DROP PROCEDURE IF EXISTS LogAttivita

DELIMITER //

CREATE PROCEDURE LogAttivita (
    IN messaggio VARCHAR(255),
    IN nome_oggetto_db VARCHAR(255),
    IN utente VARCHAR(255),
    IN livello_messaggio ENUM('info', 'warning', 'error')
)
BEGIN
    INSERT INTO log_oggetti_db (messaggio, nome_oggetto_db, utente, livello_messaggio)
    VALUES (messaggio, nome_oggetto_db, utente, livello_messaggio);

    DELETE FROM log_oggetti_db WHERE data < NOW() - INTERVAL 5 MINUTE;
END //

DELIMITER ;

