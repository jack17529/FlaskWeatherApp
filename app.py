"""
Creates a flask app using a template website.
"""
import requests
from flask import Flask, render_template, request
from flask_sqlalchemy import SQLAlchemy

APP = Flask(__name__)
APP.config['DEBUG'] = True
APP.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///weather.db'
APP.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

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

    url = 'http://api.openweathermap.org/data/2.5/weather?q={}&units=imperial&appid=271d1234d3f497eed5b1d80a07b3fcd1'

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
    APP.run(host='0.0.0.0', port=5000, debug=True)
