import os
import requests
from flask import Flask, request, jsonify

app = Flask(__name__)

HF_MODEL = os.getenv('HF_MODEL')
HF_API = os.getenv('HF_API')
headers = { "Authorization": f"Bearer {os.getenv('HF_TOKEN')}", 'Content-Type': 'application/json; charset=utf-8' }

def query(text):
    tag="<506f274>"
    prefix = f"""Il tuo task è quello di corregere grammaticalmente il testo fornito. Restituisci ESCLUSIVAMENTE la versione completa e grammaticalmente corretta del testo delimitato dal tag {tag}. Non includere nella risposta il tag. La risposta non deve contenere caratteri Unicode Escaped. Ecco il testo da correggere: """ 
    payload = {
        "messages": [
            {
                "role": "user",
                "content": prefix + f"{tag}{text}{tag}"
            }
        ],
        "model": HF_MODEL
    }
    response = requests.post(HF_API, headers=headers, json=payload)
    return response.json()["choices"][0]["message"]["content"], response.status_code

@app.route('/health', methods=['GET'])
def health_check():
    print("Health check requested!")
    return 'UP', 200

@app.route('/query', methods=['POST'])
def corrector():
    """Text grammar corrector."""
    data = request.get_json()
    text = data.get('text', '')
    
    if text:
        res, status_code = query(text)
        
        if status_code != 200:
            return jsonify({'error': 'HF API'}), status_code
        
        unescaped_res = res.encode('utf-8').decode('unicode_escape') 
        
        return jsonify({f'result': unescaped_res }), 200, {'Content-Type': 'application/json; charset=utf-8'}
    else:
        return jsonify({'error': 'Text to compute not provided'}), 400
    
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000, debug=True)

