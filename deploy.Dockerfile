FROM python:3.8
ADD src/. /app
CMD [ "python", "/app/app.py" ]
