
-- ************** PRIMA PARTE ************** 

-- creo tab statistiche
DROP TABLE IF EXISTS stats_libri;

CREATE TABLE stat_libri(
id INT AUTO_INCREMENT PRIMARY KEY,
utente VARCHAR(50) NOT NULL,
ora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
nome_tabella VARCHAR(50),
tipo_operazione ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL
)


--trigger insert 
DROP TRIGGER IF EXISTS insert_libri;

DELIMITER //
CREATE TRIGGER insert_libri
AFTER INSERT ON libri
FOR EACH ROW
BEGIN
    INSERT INTO stat_libri (utente, nome_tabella, tipo_operazione)
    VALUES (CURRENT_USER(), 'libri', 'INSERT');
END //
DELIMITER ;

--trigger update 
DROP TRIGGER IF EXISTS update_libri;

DELIMITER //
CREATE TRIGGER update_libri
AFTER UPDATE ON libri
FOR EACH ROW
BEGIN
    INSERT INTO stat_libri (utente, nome_tabella, tipo_operazione)
    VALUES (CURRENT_USER(), 'libri', 'UPDATE');
END //
DELIMITER ;

--trigger after delete 
DROP TRIGGER IF EXISTS after_delete_libri;

DELIMITER // 
CREATE TRIGGER after_delete_libri
AFTER DELETE ON libri
FOR EACH ROW
BEGIN
    INSERT INTO stat_libri (utente, nome_tabella, tipo_operazione)
    VALUES (CURRENT_USER(), 'libri', 'DELETE' );
END  //
DELIMITER ;



-- ************** SECONDA PARTE ************** 



--creo tab libri cancellati
DROP TABLE IF EXISTS libri_cancellati;

CREATE TABLE libri_cancellati(
id BIGINT AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(255),
nome_autore VARCHAR(255) NOT NULL,
cognome_autore VARCHAR(255) NOT NULL,
nome_editore VARCHAR(255) NOT NULL,
utente VARCHAR(50) NOT NULL,
ora TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- trigger before delete 
DROP TRIGGER IF EXISTS before_delete_libri

DELIMITER //
CREATE TRIGGER before_delete_libri
BEFORE DELETE ON libri
FOR EACH ROW
BEGIN
    --variabili d'appoggio
	DECLARE nomeAutore VARCHAR(255);
    DECLARE cognomeAutore VARCHAR(255);
	DECLARE editore VARCHAR(255);
    
    --joino autori e prendo nome e cognome
	SELECT autori.nome , autori.cognome into nomeAutore, cognomeAutore  FROM libri
    JOIN autori ON OLD.autori_id = autori.autori_id
	LIMIT 1;

    --joino editore e prendo nome 
    SELECT editori.nome into editore FROM libri
    JOIN editori ON OLD.editore_id = editori.editore_id
	LIMIT 1;
    
    --inserisco in tabella
    INSERT INTO libri_cancellati(nome,nome_autore, cognome_autore, nome_editore, utente )
    VALUES (OLD.nome, nomeAutore, cognomeAutore, editore , CURRENT_USER() );
END //
DELIMITER ;

--prova di delete 
DELETE FROM libri WHERE id_libri = 25;