<table align="center">
<tr>
<td align="center" width="25%">
<img src="figuras/ufma.png" width="140">
</td>

<td align="center" width="50%">
<strong>Universidade Federal do Maranhão (UFMA)</strong><br>
Centro de Ciências Exatas e Tecnologia (CCET)<br>
Curso de Engenharia da Computação<br>
Disciplina: Banco de Dados (EECP0004)<br><br>

<strong>Discentes:</strong><br>
Renata Costa Rocha<br>
Kaline Maria Carvalho<br>
Guilherme Sameneses de Lima
</td>

<td align="center" width="25%">
<img src="figuras/logo.jpg" width="140">
</td>
</tr>
</table>

---

# Sistema de Gerenciamento de Biblioteca

<p align="center">
<em>Projeto de modelagem e implementação de banco de dados relacional para gerenciamento de bibliotecas acadêmicas utilizando PostgreSQL.</em>
</p>

<p align="center">
<img src="https://img.shields.io/badge/Status-Concluído-blue?style=flat-square">
<img src="https://img.shields.io/badge/PostgreSQL-17-336791?style=flat-square&logo=postgresql&logoColor=white">
<img src="https://img.shields.io/badge/Modelagem-Chen-green?style=flat-square">
<img src="https://img.shields.io/badge/SQL-Database-orange?style=flat-square">
<img src="https://img.shields.io/badge/Projeto-Acadêmico-success?style=flat-square">
<img src="https://img.shields.io/badge/GitHub-Versionamento-black?style=flat-square&logo=github">
</p>

---

# 1. Descrição do Projeto

O presente projeto consiste na modelagem e implementação de um Sistema de Gerenciamento de Biblioteca utilizando banco de dados relacional.

A proposta contempla todas as etapas clássicas do processo de modelagem de dados, incluindo os modelos conceitual, lógico e físico, bem como sua implementação em PostgreSQL.

O sistema permite o gerenciamento de usuários, livros, autores, categorias e empréstimos, oferecendo mecanismos para controle do acervo bibliográfico e da disponibilidade das obras.

---

# 2. Objetivos

- Modelar um banco de dados utilizando a abordagem Entidade-Relacionamento;
- Aplicar os conceitos da modelagem conceitual na notação de Chen;
- Desenvolver o modelo lógico relacional;
- Implementar o modelo físico em PostgreSQL;
- Utilizar funções e triggers para automatização de regras de negócio;
- Realizar consultas utilizando funções agregadas e cláusula HAVING.

---

# 3. Problema Modelado

Bibliotecas acadêmicas necessitam controlar informações relacionadas a usuários, livros, autores e empréstimos.

O sistema proposto permite:

- Cadastro de alunos e professores;
- Controle do acervo bibliográfico;
- Associação entre livros e autores;
- Classificação dos livros por categoria;
- Registro de empréstimos;
- Controle automático da disponibilidade dos livros.

---

# 4. Requisitos da Atividade

A atividade proposta exigia:

- Modelo Conceitual;
- Modelo Lógico;
- Modelo Físico;
- Mínimo de cinco entidades;
- Relacionamento 1:N;
- Relacionamento N:N;
- Especialização;
- Consulta com função agregada;
- Consulta utilizando HAVING;
- Implementação de função;
- Implementação de trigger.

Todos os requisitos foram atendidos.

## Roteiro da Atividade

<p align="center">
<img src="figuras/Roteiro.png" width="900">
</p>

<p align="center">
<em><strong>Figura 1.</strong> Roteiro da atividade proposto pela disciplina.</em>
</p>

---

# 5. Modelo Conceitual

O modelo conceitual foi elaborado utilizando a notação de Chen.

### Entidades

- Usuário
- Aluno
- Professor
- Livro
- Autor
- Categoria
- Empréstimo

### Relacionamentos 1:N

- Categoria → Livro
- Usuário → Empréstimo
- Livro → Empréstimo

### Relacionamento N:N

- Livro ↔ Autor

### Especialização

- Usuário → Aluno
- Usuário → Professor

<p align="center">
<img src="modelos/conceitual.png" width="1000">
</p>

<p align="center">
<em><strong>Figura 2.</strong> Modelo Conceitual do Sistema de Gerenciamento de Biblioteca.</em>
</p>

---

# 6. Modelo Lógico

O modelo lógico foi obtido a partir da transformação do modelo conceitual para o paradigma relacional.

<p align="center">
<img src="modelos/logico.png" width="1000">
</p>

<p align="center">
<em><strong>Figura 3.</strong> Modelo Lógico do Sistema de Gerenciamento de Biblioteca.</em>
</p>

---

# 7. Modelo Físico

O modelo físico foi implementado em PostgreSQL.

### Tabelas Implementadas

- usuario
- aluno
- professor
- categoria
- livro
- autor
- livro_autor
- emprestimo

<p align="center">
<img src="modelos/resumofisico.png" width="1000">
</p>

<p align="center">
<em><strong>Figura 4.</strong> Estrutura física implementada no PostgreSQL.</em>
</p>

---

# 8. Funcionalidades Implementadas

## Consulta com Função Agregada

```sql
SELECT COUNT(*) AS total_emprestimos
FROM emprestimo;
```

### Resultado

<p align="center">
<img src="figuras/agregada.png" width="900">
</p>

---

## Consulta utilizando HAVING

```sql
SELECT
    c.descricao,
    COUNT(l.id_livro) AS quantidade_livros
FROM categoria c
JOIN livro l
ON c.id_categoria = l.id_categoria
GROUP BY c.descricao
HAVING COUNT(l.id_livro) >= 2;
```

### Resultado

<p align="center">
<img src="figuras/having.png" width="900">
</p>

---

## Função

```sql
CREATE OR REPLACE FUNCTION quantidade_emprestimos(p_id_usuario INT)
RETURNS INTEGER
```

Responsável por retornar a quantidade de empréstimos realizados por determinado usuário.

### Resultado

<p align="center">
<img src="figuras/funcao.png" width="900">
</p>

---

## Trigger

### Trigger de Verificação de Disponibilidade

Impede a realização de empréstimos quando o livro já se encontra indisponível.

### Resultado

<p align="center">
<img src="figuras/trigger.png" width="900">
</p>

---

# 9. Tecnologias Utilizadas

- PostgreSQL 17
- SQL
- pgAdmin 4
- Git
- GitHub

---

# 10. Estrutura do Projeto

```text
biblioteca-bd/
│
├── README.md
├── sql/
│   └── biblioteca.sql
├── modelos/
│   ├── conceitual.png
│   ├── logico.png
│   └── resumofisico.png
├── figuras/
│   ├── ufma.png
│   ├── logo.jpg
│   ├── Roteiro.png
│   ├── agregada.png
│   ├── having.png
│   ├── funcao.png
│   └── trigger.png
└── documentos/
```

---

# 11. Considerações Finais

O desenvolvimento deste projeto permitiu aplicar conceitos fundamentais de modelagem de bancos de dados, abrangendo desde a abstração conceitual até a implementação física em PostgreSQL.

Além da construção dos modelos conceitual e lógico, foram explorados recursos avançados do banco de dados, como funções, triggers e consultas analíticas, contribuindo para a consolidação dos conhecimentos adquiridos na disciplina.

O trabalho atendeu integralmente aos requisitos propostos, contemplando relacionamentos 1:N e N:N, especialização, consultas avançadas e mecanismos de automação por meio de funções e triggers.

---

# 12. Contato

### Renata Costa Rocha
📧 renata.rocha@discente.ufma.br

### Kaline Maria Carvalho
📧 carvalho.kaline@discente.ufma.br

### Guilherme Sameneses de Lima
📧 guilherme.sameneses@discente.ufma.br

---

**Universidade Federal do Maranhão (UFMA)**  
**Curso de Engenharia da Computação**  
**Disciplina: Banco de Dados (EECP0004)**