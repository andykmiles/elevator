FROM python:3
ADD src/. /app
CMD [ "python", "/app/app.py" ]
