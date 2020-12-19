FROM python:3.5-alpine3.8
LABEL maintainer="jack17529"
ADD ./ /
RUN pip3 install --upgrade pip
RUN pip3 install -r requirements.txt
EXPOSE 5000
CMD ["python3","app.py"]
