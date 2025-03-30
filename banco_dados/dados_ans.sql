create database dados_ans;
use dados_ans;

create table demonstracoes_contabeis (
	id int AUTO_INCREMENT primary KEY,
    data date,
    reg_ans varchar(10),
    cd_conta_contabil varchar(20),
    descricao text,
    vl_saldo_inicial decimal(20,2),
    vl_saldo_final decimal(20,2),
    trimestre varchar(5),
    ano int,
    index (reg_ans),
    index (cd_conta_contabil),
    index (ano),
    index (trimestre)
);

create table operadoras_ativas(
    id INT AUTO_INCREMENT PRIMARY KEY,
    registro_ans VARCHAR(20),
    cnpj VARCHAR(20),
    razao_social TEXT,
    nome_fantasia TEXT,
    modalidade VARCHAR(100),
    logradouro TEXT,
    numero VARCHAR(20),
    complemento TEXT,
    bairro TEXT,
    cidade TEXT,
    uf CHAR(2),
    cep VARCHAR(10),
    ddd VARCHAR(5),
    telefone VARCHAR(20),
    fax VARCHAR(20),
    email TEXT,
    representante TEXT,
    cargo_representante TEXT,
    regiao_comercializacao TEXT,
    data_registro_ans DATE
);

select 
	dc.reg_ans,
    oa.nome_fantasia,
    dc.descricao,
    dc.vl_saldo_final as total_despesa
from demonstracoes_contabeis dc
left join operadoras_ativas oa on dc.reg_ans = oa.registro_ans
where dc.ano = 2024
	and dc.trimestre = '4T'
    and dc.descricao like '%SINISTROS CONHECIDOS%'
order by dc.vl_saldo_final desc
limit 10;

SELECT 
    dc.reg_ans,
    oa.nome_fantasia,
    dc.descricao,
    SUM(dc.vl_saldo_final) AS total_despesa
FROM demonstracoes_contabeis dc
LEFT JOIN operadoras_ativas oa ON dc.reg_ans = oa.registro_ans
WHERE dc.ano = 2024
  AND dc.descricao LIKE '%SINISTROS CONHECIDOS%'
GROUP BY dc.reg_ans, oa.nome_fantasia, dc.descricao
ORDER BY total_despesa DESC
LIMIT 10;


LOAD DATA LOCAL INFILE 'C:/caminho/para/C:\Users\dougl\OneDrive\Área de Trabalho\webscraping-transformacao-ans\banco_dados\1T2023.csv'
INTO TABLE demonstracoes_contabeis
CHARACTER SET latin1
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(data, reg_ans, cd_conta_contabil, descricao, vl_saldo_inicial, vl_saldo_final);

UPDATE demonstracoes_contabeis
SET trimestre = '1T', ano = 2023
WHERE trimestre IS NULL AND ano IS NULL;
    