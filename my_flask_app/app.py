from flask import Flask, request, render_template

app = Flask(__name__)

@app.route('/')
def form():
    return render_template('form.html')

@app.route('/display')
def display():
    # Get values from the query string (GET request)
    city = request.args.get('city')
    country = request.args.get('country')

    return render_template('display.html', city=city, country=country)

if __name__ == '__main__':
    app.run(debug=True, port=8000)