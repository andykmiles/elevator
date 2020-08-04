FROM python:3
ADD src/. /app
CMD [ "python", "/app/built.py" ]
