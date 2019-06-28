FROM python:3.5-alpine3.8
LABEL maintainer="jack17529"
RUN pip3 install flask &&\
    pip3 install requests &&\
    pip3 install Flask-SQLAlchemy
EXPOSE 5000
ADD ./ /
CMD ["python3","app.py"]
