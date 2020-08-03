FROM python:3
COPY src/ build/
CMD [ "python", "./built.py" ]
