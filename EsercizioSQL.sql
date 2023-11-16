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

/*
SELECT a.nome, a.cognome, a.nazione, COUNT(l.autori_id) AS numero_libri_scritti
FROM autori a
JOIN libri l ON a.autori_id = l.autori_id
GROUP BY a.autori_id
HAVING COUNT(l.autori_id) > 2;
*/