import os
from flask import Flask, render_template, request
from transformers import pipeline


classifier = pipeline("text-classification", model="michellejieli/emotion_text_classifier") 

app = Flask(__name__)

def get_prediction(message):
    # inference
    results = classifier(message)  
    return results

@app.route('/', methods=['GET'])
def get():
    return render_template("home.html")

@app.route('/', methods=['POST'])
def predict():
    message = request.form['message']
    results = get_prediction(message)
    return render_template('result.html', text = f'{message}', prediction = results)


if __name__ == "__main__":
    port = int(os.environ.get('PORT', 5000))
    app.run(debug=True, host='0.0.0.0', port=port)