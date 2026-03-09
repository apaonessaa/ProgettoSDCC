import os
import requests
from flask import Flask, request, jsonify

app = Flask(__name__)

API_URL = os.getenv('HF_API')
headers = { "Authorization": f"Bearer {os.getenv('HF_TOKEN')}" }

def query(text, labels):
    payload = {
        "inputs": text,
        "parameters": {"candidate_labels": labels},
    }
    response = requests.post(API_URL, headers=headers, json=payload)
    return response.json(), response.status_code

@app.route('/health', methods=['GET'])
def health_check():
    print("Health check.")
    return 'UP', 200

@app.route('/query', methods=['POST'])
def classifier():
    """Label classification from a text."""
    data = request.get_json()
    labels = data.get('labels', [])
    text = data.get('text', '')

    if text and labels:
        res, status_code = query(text, labels)
        
        if status_code != 200:
            return jsonify({'error': 'HF API'}), status_code

        # [ {'label': LABEL, 'score': SCORE} ]
        sorted_labels = [item['label'] for item in sorted(res, key=lambda x: x['score'], reverse=True)]
        
        return jsonify({f'result': sorted_labels}), 200, {'Content-Type': 'application/json; charset=utf-8'}
    else:
        return jsonify({'error': 'Text to compute not provided'}), 400
    
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000, debug=False)

