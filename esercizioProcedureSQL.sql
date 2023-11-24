DROP PROCEDURE IF EXISTS crea_libro

--creo procedura con dati in ingresso
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
main_block: BEGIN
    --dichiaro varbiabili
    DECLARE id_autore BIGINT;
    DECLARE id_genere BIGINT;
    DECLARE id_editore BIGINT;
    DECLARE no_autore VARCHAR(50);
    DECLARE no_editore VARCHAR(50);
    --do valore ai messaggi che mostrerò entrati negli if corrispondenti
    SET no_autore = 'AUTORE Non Censito';
	SET no_editore = 'EDITORE Non Censito';  
-- AUTORE (recupero id autore poi controllo che esista)
    SELECT autori_id INTO id_autore
    FROM autori
    WHERE cognome = cognome_autore 
    AND nome = nome_autore
    LIMIT 1;
    IF id_autore IS NULL 
    THEN
    SELECT no_autore AS MESSAGGIO;
    CALL LogAttivita('Autore Non Censito', 'crea_libro', 'Admin', 'warning'); --logger
    LEAVE main_block; -- esco dalla procedure
	END IF;
-- GENERE (recupero id genere poi controllo che esista se non esiste lo aggiungo )
    SELECT genere_id INTO id_genere 
    FROM genere
    WHERE descrizione = descrizione_genere
    LIMIT 1;
    IF id_genere IS NULL 
    THEN 
    INSERT INTO genere(descrizione) --lo aggiungo in genere
    VALUES (descrizione_genere);
    CALL LogAttivita('genere aggiunto con successo', 'crea_libro', 'Admin', 'info'); --logger
    SELECT genere_id INTO id_genere 
    FROM genere
    WHERE descrizione = descrizione_genere
    LIMIT 1;
    END IF;
-- EDITORE (recupero id editore poi controllo che esista)
    SELECT editore_id INTO id_editore 
    FROM editori 
    WHERE editori.nome = nome_editore
    LIMIT 1;
    IF id_editore IS NULL
    THEN
    SELECT no_editore AS MESSAGGIO;
	CALL LogAttivita('editore Non Censito', 'crea_libro', 'Admin', 'warning'); --logger 
	LEAVE main_block; -- esco dalla procedure 
	END IF;
    --inserisco i dati ricavati    
    INSERT INTO libri (nome, numero_pagine, autori_id, genere_id, editore_id, anno)
    VALUES (titolo, numero_pagine, id_autore, id_genere, id_editore, anno);
	CALL LogAttivita('libro aggiunto con successo', 'crea_libro', 'Admin', 'info'); --logger
END //
DELIMITER ;

-- chiamata funzionante (aggiunge genere)
CALL crea_libro('Fermo e Lucia', 'Manzoni', 'Alessandro', 'GENEREDIPROVAPERLOG', 'Mondadori', 500, 1880);

-- chiamata non funzionante (autore non in db)
CALL Crea_libro('Le due città ','Dickens','Charles','Romanzo', 'Mondadori' , 190 , 1900);

-- chiamata non funzionante (editore non in db)
CALL Crea_libro('Il Conte di Carmagnola','Manzoni','Alessandro','generediProva', 'amadori' , 190 , 1900);

-- creo tab logger
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

--creo procedura logger
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
    DELETE FROM log_oggetti_db WHERE data < NOW() - INTERVAL 5 MINUTE; -- elimino tabelle di piu di 5 min
END //
DELIMITER ;

