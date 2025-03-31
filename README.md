## 🔧 Explicação do que foi feito:

- **Etapa 1 (Java)**: Implementado o scraping usando **Jsoup** para acessar o site, baixar e compactar os Anexos I e II.
- **Etapa 2 (Python)**: Usado **pdfplumber** para ler as tabelas do Anexo I, **pandas** para manipulação dos dados, e **zipfile** para compactar o CSV gerado.
- **Etapa 3 (MYSQL)**:  - Criado banco de dados e as tabelas `demonstracoes_contabeis` e `operadoras_ativas` com base nos CSVs da ANS.
  - Utilizado `LOAD DATA LOCAL INFILE` para importar os dados com encoding correto (`latin1`).
  - Desenvolvidas queries analíticas para identificar as 10 operadoras com maiores despesas em **“EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS DE ASSISTÊNCIA À SAÚDE MÉDICO HOSPITALAR”**:
    - No **último trimestre**
    - No **último ano**
- **Etapa 4 (API + Frontend)**:
- - Criada uma **API em Flask (Python)** com a rota `GET /Relatorio_cadop` que realiza busca textual em todos os campos do CSV de operadoras ativas.
  - Habilitado **CORS** para permitir acesso do frontend.
  - Desenvolvido um **frontend em Vue.js** com `axios` para integrar com a API.
  - A busca exibe nome fantasia, razão social, Moralidade, UF e Representante.