"""
Creates a flask app using a template website.
"""
import requests
from flask import Flask, render_template, request
from flask_sqlalchemy import SQLAlchemy

from configparser import ConfigParser
config = ConfigParser()

config.read('config.ini')

APP = Flask(__name__)
APP.config['DEBUG'] = config.get('main', 'DEBUG')
APP.config['SQLALCHEMY_DATABASE_URI'] = config.get('main', 'SQLALCHEMY_DATABASE_URI')
APP.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = config.get('main', 'SQLALCHEMY_TRACK_MODIFICATIONS')

DB = SQLAlchemy(APP)

class City(DB.Model):
    id = DB.Column(DB.Integer, primary_key=True)
    name = DB.Column(DB.String(50), nullable=False)

@APP.route('/', methods=['GET', 'POST'])
def index():
    """Checks the request made is POST and commits else gets the data of the cities already
    present in the sqlite database.

    Returns:
        render_template : returns the rendered template. 
    """
    
    if request.method == 'POST':
        new_city = request.form.get('city')

        if new_city:
            new_city_obj = City(name=new_city)

            DB.session.add(new_city_obj)
            DB.session.commit()

    cities = City.query.all()

    config.read('secret.ini')
    api_key=config.get('main', 'api_key')
    # print(api_key)
    url = 'http://api.openweathermap.org/data/2.5/weather?q={}&units=imperial&appid='+api_key

    weather_data = []

    for city in cities:

        req_city = requests.get(url.format(city.name)).json()

        weather = {
            'city' : city.name,
            'temperature' : req_city['main']['temp'],
            'description' : req_city['weather'][0]['description'],
            'icon' : req_city['weather'][0]['icon'],
        }

        weather_data.append(weather)


    return render_template('weather.html', weather_data=weather_data)

if __name__ == "__main__":
    from waitress import serve
    serve(APP, host="0.0.0.0", port=5000)
    # APP.run(host='0.0.0.0', port=5000, debug=True)
