DROP SCHEMA IF EXISTS libri;
CREATE SCHEMA libri ;

USE libri;

CREATE TABLE autori ( 
autori_id BIGINT AUTO_INCREMENT NOT NULL,
nome VARCHAR(255) NOT NULL,
cognome VARCHAR(255) NOT NULL,
anno_nascita INT NOT NULL,
anno_morte INT,
sesso VARCHAR(255),
nazione VARCHAR(255),
PRIMARY KEY (autori_id)
);

CREATE TABLE  libri (
id_libri BIGINT AUTO_INCREMENT,
nome VARCHAR(255) NOT NULL,
numero_pagine INT NOT NULL,
anno INT NOT NULL,
autori_id BIGINT,
PRIMARY KEY (id_libri),
FOREIGN KEY (autori_id) REFERENCES autori(autori_id) 
);


INSERT INTO autori (nome, cognome, anno_nascita, anno_morte, sesso, nazione) VALUES
('Alessandro', 'Manzoni', 1785, 1873, 'M', 'Italia'),
('Lev', 'Tolstoi', 1828, 1910, 'M', 'Russia'),
('Bruno', 'Vespa', 1944, NULL, 'M', 'Italia'),
('Stephen', 'King', 1947, NULL, 'M', 'USA'),
('Ernest', 'Hemingway', 1899, 1961, 'M', 'USA'),
('Umberto', 'Eco', 1932, 2016, 'M', 'Italia'),
('Susanna', 'Tamaro', 1957, NULL, 'F', 'Italia'),
('Virginia', 'Woolf', 1882, 1941, 'F', 'Inghilterra'),
('Agatha', 'Christie', 1890, 1976, 'F', 'Inghilterra');


INSERT INTO libri (nome, numero_pagine, anno, autori_id) VALUES
('I promessi sposi', 720, 1840, 1),
('Storia della colonna infame', 200, 1840, 1),
('Guerra e pace', 1225, 1869, 2),
('Anna Karenina', 864, 1877, 2),
('Donne al potere', 300, 2005, 3),
('La grande tempesta', 320, 2010, 3),
('Misery', 370, 1987, 4),
('IT', 1138, 1986, 4),
('Shining', 447, 1977, 4),
('Il vecchio e il mare', 127, 1952, 5),
('Per chi suona la campana', 480, 1940, 5),
('Fiesta', 320, 1926, 5),
('Il nome della rosa', 512, 1980, 6),
('Foucault’s Pendulum', 641, 1988, 6),
('Va dove ti porta il cuore', 208, 1994, 7),
('Gita al faro', 209, 1927, 8),
('Orlando', 264, 1928, 8),
("Assassinio sull'Orient Express", 256, 1934, 9),
('Sipario', 224, 1975, 9);

/*
SELECT nazione, COUNT(id_libri) AS numero_libri
FROM autori
JOIN libri ON libri.autori_id = autori.autori_id
GROUP BY nazione
ORDER BY numero_libri DESC;
*/

/*
SELECT autori.nome , autori.cognome , COUNT(id_libri) AS numero_libri
FROM autori
JOIN libri ON libri.autori_id = autori.autori_id 
AND nazione IN('inghilterra','italia') 
AND autori.anno_morte IS NULL
GROUP BY autori.nome , autori.cognome
HAVING COUNT(libri.id_libri) > 1;
*/

/*
SELECT libri.nome, autori.nazione, autori.anno_nascita
FROM libri
JOIN autori ON libri.autori_id = autori.autori_id
WHERE (autori.nazione = 'USA' AND autori.anno_nascita > 1945)
OR (autori.nazione = 'Italia' AND libri.nome LIKE '%o');
*/

/* 
SELECT nome, anno 
FROM libri 
WHERE (YEAR(NOW()) - anno > 30);
*/

/*
SELECT *
FROM libri
JOIN autori ON libri.autori_id = autori.autori_id
WHERE autori.sesso = 'F';
*/

/*
SELECT *
FROM libri
WHERE length(nome) > 8
*/

/*
SELECT libri.nome, numero_pagine, nazione
FROM libri
JOIN autori ON libri.autori_id = autori.autori_id
WHERE (nazione IN ('Russia', 'Italia') AND numero_pagine > 100 )
*/

/*
SELECT nome, numero_pagine
FROM libri
WHERE (numero_pagine < 200 
AND nome LIKE 'i%');
*/

/*
SELECT * 
FROM libri 
JOIN autori ON libri.autori_id = autori.autori_id
WHERE libri.anno < 2000 
AND libri.anno > 1960;
*/

/*
SELECT autori.nome, COUNT(autori.autori_id) AS numero_libri
FROM autori
JOIN libri ON libri.autori_id = autori.autori_id
GROUP BY autori.nome
HAVING COUNT(autori.autori_id) > 2;
*/

-- 2 PARTE --

-- CREO TABELLA GENERE
CREATE TABLE genere( 
genere_id BIGINT AUTO_INCREMENT,
descrizione VARCHAR(50) NOT NULL,
PRIMARY KEY(genere_id)
)  ;

-- INSERISCO DATI
INSERT INTO genere (descrizione)  VALUES
('giallo'),
('horror'),
('storico'),
('romanzo');

-- AGGIUNGO FK 
ALTER TABLE libri ADD (
genere_id BIGINT,
FOREIGN KEY(genere_id) REFERENCES genere(genere_id)
);

UPDATE libri
INNER JOIN autori ON libri.autori_id = autori.autori_id
SET libri.genere_id = CASE 
    WHEN autori.autori_id = 1 THEN 3
    WHEN autori.autori_id = 2 THEN 3
    WHEN autori.autori_id = 3 THEN 4
	WHEN autori.autori_id = 4 THEN 1
	WHEN autori.autori_id = 5 THEN 3
    WHEN autori.autori_id = 6 THEN 4
    WHEN autori.autori_id = 7 THEN 4
    WHEN autori.autori_id = 8 THEN 2
    WHEN autori.autori_id = 9 THEN 4
ELSE libri.genere_id 
END;

CREATE TABLE editori (
editore_id BIGINT AUTO_INCREMENT,
nome VARCHAR(50),
PRIMARY KEY(editore_id)
);

INSERT INTO editori(nome) VALUES 
('Amadori'),
('Rizzoli');

ALTER TABLE libri ADD (
editore_id BIGINT,
FOREIGN KEY(editore_id) REFERENCES editori(editore_id)
);

UPDATE libri
INNER JOIN autori ON libri.autori_id = autori.autori_id
SET libri.editore_id = CASE 
    WHEN autori.autori_id = 1 THEN 1
    WHEN autori.autori_id = 2 THEN 2
    WHEN autori.autori_id = 3 THEN 1
	WHEN autori.autori_id = 4 THEN 2
	WHEN autori.autori_id = 5 THEN 1
    WHEN autori.autori_id = 6 THEN 2
    WHEN autori.autori_id = 7 THEN 2
    WHEN autori.autori_id = 8 THEN 1
    WHEN autori.autori_id = 9 THEN 1
ELSE libri.editore_id
END;
SELECT COUNT(*) AS numero_autori
FROM (
    SELECT autori.autori_id
    FROM autori
    JOIN libri ON autori.autori_id = libri.autori_id
    GROUP BY autori.autori_id
    HAVING COUNT(libri.id_libri) > 2
) AS autori_con_piu_di_due_libri;

SELECT * FROM libri 
JOIN autori ON autori.autori_id = libri.autori_id
WHERE libri.genere_id = 1
AND autori.anno_morte IS NULL;

SELECT * 
FROM libri
JOIN autori ON autori.autori_id = libri.autori_id
WHERE libri.genere_id IN (1,4)
AND autori.sesso = 'M'
AND libri.editore_id = 2;

SELECT editori.nome, libri.nome
FROM libri
JOIN editori ON editori.editore_id = libri.editore_id
WHERE libri.genere_id  != 1
AND length(editori.nome) < 8; 

SELECT * 
FROM libri
JOIN autori ON autori.autori_id = libri.autori_id
WHERE libri.genere_id  != 4
AND autori.nazione = 'Italia'
AND libri.nome LIKE '%i';

SELECT autori.nome, anno_nascita ,COUNT(libri.autori_id) as numero_libri
FROM libri
JOIN autori ON autori.autori_id = libri.autori_id
WHERE libri.genere_id  != 2
GROUP BY autori.nome, autori.anno_nascita
HAVING COUNT(libri.id_libri) > 1
ORDER BY anno_nascita DESC ;

SELECT * 
FROM libri
JOIN autori ON autori.autori_id = libri.autori_id
WHERE libri.genere_id = 4
AND autori.nazione != 'Italia'
ORDER BY autori.nome asc;

SELECT count(libri.id_libri) as numero_libri, genere.descrizione
FROM libri
JOIN autori ON autori.autori_id = libri.autori_id
JOIN genere ON libri.genere_id = genere.genere_id
where autori.nazione != "Italia"
AND genere.genere_id != 2
group by genere.descrizione;

SELECT *
FROM libri
JOIN autori ON autori.autori_id = libri.autori_id
WHERE libri.genere_id  != 4
AND autori.nazione = 'Italia'
AND libri.nome LIKE '%i';

SELECT editori.nome AS nome_editore, COUNT(libri.id_libri) AS numero_libri
FROM libri
JOIN autori ON libri.autori_id = autori.autori_id
JOIN editori ON libri.editore_id = editori.editore_id
WHERE autori.nome = 'Alessandro'
GROUP BY editori.nome
HAVING COUNT(libri.id_libri) > 1
ORDER BY COUNT(libri.id_libri) ASC;

SELECT libri.nome
FROM libri
JOIN editori ON libri.editore_id = editori.editore_id
WHERE LENGTH(libri.nome) > 7 AND editori.nome = 'Mondadori';

SELECT DISTINCT autori.nome, autori.cognome
FROM autori
JOIN libri ON autori.autori_id = libri.autori_id
WHERE LENGTH(libri.nome) < 10 AND libri.numero_pagine BETWEEN 10 AND 500;

CREATE VIEW v_libri_autori_genere_editori AS
SELECT 
	autori.nome AS NomeAutore,
	autori.cognome AS CognomeAutore,
	libri.nome AS TitoloLibro,
	editori.nome AS Editore,
	genere.descrizione AS Genere
FROM libri
JOIN autori ON libri.autori_id = autori.autori_id
JOIN genere ON libri.genere_id = genere.genere_id
JOIN editori ON libri.editore_id = editori.editore_id;

SELECT * from v_libri_autori_genere_editori;

CREATE VIEW v_libri_autori_editori_ita AS 
SELECT 
	 autori.nome AS NomeAutore,
     autori.cognome AS CognomeAutore,
	 libri.nome AS TitoloLibro,
     editori.nome AS Editore
     FROM libri
JOIN autori ON libri.autori_id = autori.autori_id
JOIN genere ON libri.genere_id = genere.genere_id
JOIN editori ON libri.editore_id = editori.editore_id
WHERE autori.nazione = 'italia';     
     
SELECT * from v_libri_autori_editori_ita;     
     
     
