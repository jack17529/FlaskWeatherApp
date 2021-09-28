FROM python:3.8-slim
LABEL maintainer="jack17529"
WORKDIR /app
COPY . /app
RUN pip3 install -r requirements.txt --no-cache-dir
EXPOSE 5000
CMD ["python3","app.py"]
