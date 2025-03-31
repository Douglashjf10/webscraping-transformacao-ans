from flask import Flask, request, jsonify
from flask_cors import CORS
import pandas as pd

app = Flask(__name__)
CORS(app)

operadoras_df = df = pd.read_csv('Relatorio_cadop.csv', sep=';', encoding='latin1', dtype=str).fillna('')

@app.route('/Relatorio_cadop', methods=['GET'])
def buscar_operadoras():
    termo = request.args.get('q', '').lower()
    if not termo: return jsonify([])

    resultados = operadoras_df[operadoras_df.apply(lambda row: row.astype(str).str.lower().str.contains(termo).any(), axis=1)]
    return jsonify(resultados.to_dict(orient='records'))

if __name__ == '__main__':
    app.run(debug=True)