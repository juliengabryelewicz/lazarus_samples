CREATE DATABASE application_gestion_classe CHARACTER SET 'utf8';

CREATE TABLE classes (
    id int UNSIGNED AUTO_INCREMENT,
    nom varchar(255),
    PRIMARY KEY (id)
);

CREATE TABLE matieres (
    id int UNSIGNED AUTO_INCREMENT,
    nom varchar(255),
    PRIMARY KEY (id)
);

CREATE TABLE eleves (
    id INT UNSIGNED AUTO_INCREMENT,
    prenom VARCHAR(100) NOT NULL,
    nom VARCHAR(100) NOT NULL,
    date_naissance DATE,
    commentaire TEXT,
    id_classe INT UNSIGNED,
    PRIMARY KEY (id),
    FOREIGN KEY (id_classe) REFERENCES classes(id) ON DELETE CASCADE
);


CREATE TABLE notes (
    id INT UNSIGNED AUTO_INCREMENT,
    nom VARCHAR(255),
    note FLOAT(4,2),
    commentaire TEXT,
    date_note DATE,
    id_eleve INT UNSIGNED,
    id_matiere INT UNSIGNED,
    PRIMARY KEY (id),
    FOREIGN KEY (id_eleve) REFERENCES eleves(id) ON DELETE CASCADE,
    FOREIGN KEY (id_matiere) REFERENCES matieres(id) ON DELETE CASCADE
);
