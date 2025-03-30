import pdfplumber
import zipfile
import pandas as pd

#inicializando o pdf e extraí as tabelas

def extrair_tabelas_pdf(pdf_path: str) -> pd.DataFrame:
    dados = []
    colunas = None

    with pdfplumber.open("Anexo_I.pdf") as pdf:
        for pagina in pdf.pages:
            tabelas = pagina.extract_tables()
            for tabela in tabelas:
                if tabela:
                    for i, linha in enumerate(tabela):
                        if colunas is None and linha[0] and "PROCEDIMENTO" in linha[0].upper():
                            colunas = linha
                            continue

                        if len(linha) < 4 or not linha[0]:
                            continue
                        dados.append(linha)

#Define colunas padrão se não detectar
    if not colunas:
        colunas = ["Procedimento", "RN", "Vigência", "OD", "AMB", "Outros"]

    return pd.DataFrame(dados, columns=colunas[:len(dados[0])])

def substituir_siglas(df: pd.DataFrame) -> pd.DataFrame:
    if "OD" in df.columns:
        df["OD"] = df["OD"].replace({
        "OD": "Seg. Odontológica"
    })
    if "AMB" in df.columns:
        df["AMB"] = df["AMB"].replace({
        "AMB": "Seg. Ambulatorial"
    })
    return df

def salvar_csv(df: pd.DataFrame, csv_filename: str):
    df.to_csv(csv_filename, index=False)


def compactar_arquivo(arquivo: str, zip_nome: str):
    with zipfile.ZipFile(zip_nome, "w") as zipf:
        zipf.write(arquivo)

def main():
    pdf_path = "Anexo_I.pdf"
    csv_filename = "Rol_Procedimentos.csv"
    zip_filename =  "Teste_Douglas.zip"

    df = extrair_tabelas_pdf(pdf_path)
    df = substituir_siglas(df)
    salvar_csv(df, csv_filename)
    compactar_arquivo(csv_filename, zip_filename)

    print("Etapa 2 concluída com sucesso! ")
    print(f"CSV: {csv_filename}")
    print(f"Zip: {zip_filename}")

if __name__ == "__main__":
    main()