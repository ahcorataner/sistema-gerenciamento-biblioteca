-- =====================================================
-- SISTEMA DE GERENCIAMENTO DE BIBLIOTECA
-- MODELO FÍSICO - POSTGRESQL
-- DISCENTES: RENATA COSTA ROCHA / KALINE MARIA CARVALHO / GUILHERME SAMENESES DE LIMA
-- DISCIPLINA: EECP0004 - BANCO DE DADOS (2026 .1 - T02)
-- =====================================================

DROP TABLE IF EXISTS livro_autor CASCADE;
DROP TABLE IF EXISTS emprestimo CASCADE;
DROP TABLE IF EXISTS aluno CASCADE;
DROP TABLE IF EXISTS professor CASCADE;
DROP TABLE IF EXISTS livro CASCADE;
DROP TABLE IF EXISTS autor CASCADE;
DROP TABLE IF EXISTS categoria CASCADE;
DROP TABLE IF EXISTS usuario CASCADE;

CREATE TABLE usuario (
    id_usuario SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefone VARCHAR(20)
);

CREATE TABLE aluno (
    id_usuario INT PRIMARY KEY,
    matricula VARCHAR(20) UNIQUE NOT NULL,
    curso VARCHAR(100) NOT NULL,
    CONSTRAINT fk_aluno_usuario FOREIGN KEY (id_usuario)
        REFERENCES usuario(id_usuario)
);

CREATE TABLE professor (
    id_usuario INT PRIMARY KEY,
    departamento VARCHAR(100) NOT NULL,
    titulacao VARCHAR(100),
    CONSTRAINT fk_professor_usuario FOREIGN KEY (id_usuario)
        REFERENCES usuario(id_usuario)
);

CREATE TABLE categoria (
    id_categoria SERIAL PRIMARY KEY,
    descricao VARCHAR(100) NOT NULL
);

CREATE TABLE livro (
    id_livro SERIAL PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    isbn VARCHAR(30) UNIQUE NOT NULL,
    ano_publicacao INT,
    disponivel BOOLEAN DEFAULT TRUE,
    id_categoria INT NOT NULL,
    CONSTRAINT fk_livro_categoria FOREIGN KEY (id_categoria)
        REFERENCES categoria(id_categoria)
);

CREATE TABLE autor (
    id_autor SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

CREATE TABLE livro_autor (
    id_livro INT NOT NULL,
    id_autor INT NOT NULL,
    PRIMARY KEY (id_livro, id_autor),
    CONSTRAINT fk_livro_autor_livro FOREIGN KEY (id_livro)
        REFERENCES livro(id_livro),
    CONSTRAINT fk_livro_autor_autor FOREIGN KEY (id_autor)
        REFERENCES autor(id_autor)
);

CREATE TABLE emprestimo (
    id_emprestimo SERIAL PRIMARY KEY,
    data_emprestimo DATE NOT NULL,
    data_devolucao DATE,
    id_usuario INT NOT NULL,
    id_livro INT NOT NULL,
    CONSTRAINT fk_emprestimo_usuario FOREIGN KEY (id_usuario)
        REFERENCES usuario(id_usuario),
    CONSTRAINT fk_emprestimo_livro FOREIGN KEY (id_livro)
        REFERENCES livro(id_livro)
);

-- =====================================================
-- INSERÇÃO DE DADOS
-- =====================================================

INSERT INTO categoria (descricao)
VALUES
('Engenharia'),
('Matemática'),
('Literatura'),
('Administração'),
('Medicina'),
('Computação');

INSERT INTO autor (nome)
VALUES
('Andrew S. Tanenbaum'),
('Abraham Silberschatz'),
('Stuart Russell'),
('Peter Norvig'),
('James Stewart'),
('Ian Sommerville'),
('Machado de Assis'),
('Peter F. Drucker'),
('Henry Gray'),
('Arthur C. Guyton'),
('John E. Hall');

INSERT INTO usuario (nome, email, telefone)
VALUES
('Renata Rocha', 'renata.rocha@discente.ufma.br', '98551-5794'),
('Guilherme Lima', 'guilherme.sameneses@discente.ufma.br', '99161-4945'),
('Kaline Carvalho', 'carvalho.kaline@discente.ufma.br', '98148-0672'),
('Raphael Camara', 'raphael.sa@discente.ufma.br', '98783-8147'),
('Paulo Gomes', 'paulo.gsg@discente.ufma.br', '98713-1757'),
('Haroldo Gomes', 'haroldo.gbf@ufma.br', '98290-1518'),
('Paulo Brasil', 'paulo.brasil@ufma.br', '98832-4957'),
('Davi Viana', 'davi.viana@ufma.br', '99202-1726'),
('Allan Kardec', 'allan.kardec@ufma.br', '98886-7131'),
('Ginalber Luiz', 'ginalber.luiz@ufma.br', '98854-8834');

INSERT INTO aluno (id_usuario, matricula, curso)
VALUES
(1, '20240001556', 'Engenharia da Computação'),
(2, '2023034362', 'Ciência e Tecnologia'),
(3, '2021061781', 'Ciência e Tecnologia'),
(4, '20240001547', 'Engenharia da Computação'),
(5, '20240065580', 'Engenharia da Computação');

INSERT INTO professor (id_usuario, departamento, titulacao)
VALUES
(6, 'Engenharia da Computação', 'Doutor'),
(7, 'Ciência e Tecnologia', 'Doutor'),
(8, 'Engenharia da Computação', 'Doutor'),
(9, 'Pós-Graduação em Engenharia Elétrica', 'Doutor'),
(10, 'Pós-Graduação em Engenharia Elétrica', 'Doutor');

INSERT INTO livro (titulo, isbn, ano_publicacao, id_categoria)
VALUES
('Engenharia de Software', '9788543024974', 2018, 1),
('Cálculo - Volume 1', '9788522114610', 2013, 2),
('Dom Casmurro', '9788525044648', 2019, 3),
('O Alienista', '9788572327428', 2014, 3),
('Introdução à Administração', '9788522101030', 2009, 4),
('Gray''s Anatomia', '9788535281637', 2019, 5),
('Guyton & Hall - Tratado de Fisiologia Médica', '9788535289268', 2021, 5),
('Redes de Computadores', '9788582605615', 2021, 6),
('Sistema de Banco de Dados', '9788595157330', 2020, 6),
('Inteligência Artificial: Uma Abordagem Moderna', '9788595158870', 2022, 6);

INSERT INTO livro_autor (id_livro, id_autor)
VALUES
(1, 6),
(2, 5),
(3, 7),
(4, 7),
(5, 8),
(6, 9),
(7, 10),
(7, 11),
(8, 1),
(9, 2),
(10, 3),
(10, 4);

-- =====================================================
-- TRIGGER: VERIFICAR DISPONIBILIDADE
-- =====================================================

CREATE OR REPLACE FUNCTION verificar_disponibilidade_livro()
RETURNS TRIGGER AS
$$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM livro
        WHERE id_livro = NEW.id_livro
        AND disponivel = FALSE
    ) THEN
        RAISE EXCEPTION 'Livro indisponível para empréstimo';
    END IF;

    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER trg_verificar_disponibilidade
BEFORE INSERT ON emprestimo
FOR EACH ROW
EXECUTE FUNCTION verificar_disponibilidade_livro();

-- =====================================================
-- TRIGGER: ATUALIZAR DISPONIBILIDADE
-- =====================================================

CREATE OR REPLACE FUNCTION atualizar_disponibilidade_livro()
RETURNS TRIGGER AS
$$
BEGIN
    UPDATE livro
    SET disponivel = FALSE
    WHERE id_livro = NEW.id_livro;

    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER trg_atualizar_disponibilidade
AFTER INSERT ON emprestimo
FOR EACH ROW
EXECUTE FUNCTION atualizar_disponibilidade_livro();

-- =====================================================
-- INSERÇÃO DE EMPRÉSTIMOS
-- =====================================================

INSERT INTO emprestimo (data_emprestimo, data_devolucao, id_usuario, id_livro)
VALUES
('2026-06-01', '2026-06-15', 1, 1),
('2026-06-02', '2026-06-16', 3, 2),
('2026-06-03', '2026-06-17', 4, 3);

-- =====================================================
-- FUNÇÃO OBRIGATÓRIA
-- =====================================================

CREATE OR REPLACE FUNCTION quantidade_emprestimos(p_id_usuario INT)
RETURNS INTEGER AS
$$
DECLARE
    total INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO total
    FROM emprestimo
    WHERE id_usuario = p_id_usuario;

    RETURN total;
END;
$$
LANGUAGE plpgsql;

-- =====================================================
-- CONSULTA COM FUNÇÃO AGREGADA
-- =====================================================

SELECT COUNT(*) AS total_emprestimos
FROM emprestimo;

-- =====================================================
-- CONSULTA COM HAVING
-- =====================================================

SELECT 
    c.descricao AS categoria,
    COUNT(l.id_livro) AS quantidade_livros
FROM categoria c
JOIN livro l 
    ON c.id_categoria = l.id_categoria
GROUP BY c.descricao
HAVING COUNT(l.id_livro) >= 2;

-- =====================================================
-- TESTE DA FUNÇÃO
-- =====================================================

SELECT quantidade_emprestimos(1) AS quantidade_emprestimos_usuario;

-- =====================================================
-- BUSCAS GERAIS
-- =====================================================

SELECT *
FROM usuario;

SELECT 
    u.id_usuario,
    u.nome,
    u.email,
    a.matricula,
    a.curso
FROM usuario u
JOIN aluno a 
    ON u.id_usuario = a.id_usuario;

SELECT 
    u.id_usuario,
    u.nome,
    u.email,
    p.departamento,
    p.titulacao
FROM usuario u
JOIN professor p 
    ON u.id_usuario = p.id_usuario;

SELECT 
    l.id_livro,
    l.titulo,
    l.ano_publicacao,
    l.disponivel,
    c.descricao AS categoria
FROM livro l
JOIN categoria c 
    ON l.id_categoria = c.id_categoria;

SELECT 
    l.titulo,
    a.nome AS autor
FROM livro l
JOIN livro_autor la 
    ON l.id_livro = la.id_livro
JOIN autor a 
    ON la.id_autor = a.id_autor;

SELECT 
    e.id_emprestimo,
    u.nome AS usuario,
    l.titulo AS livro,
    e.data_emprestimo,
    e.data_devolucao
FROM emprestimo e
JOIN usuario u 
    ON e.id_usuario = u.id_usuario
JOIN livro l 
    ON e.id_livro = l.id_livro;

SELECT 
    id_livro,
    titulo,
    disponivel
FROM livro
WHERE disponivel = TRUE;

SELECT 
    id_livro,
    titulo,
    disponivel
FROM livro
WHERE disponivel = FALSE;

-- =====================================================
-- TESTE DA TRIGGER
-- Este teste deve gerar erro, pois o livro 1 já foi emprestado.
-- Para testar, remova os comentários das duas linhas abaixo.
-- =====================================================

-- INSERT INTO emprestimo (data_emprestimo, data_devolucao, id_usuario, id_livro)
-- VALUES ('2026-06-20', '2026-06-30', 2, 1);