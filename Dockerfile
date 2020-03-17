FROM r-base:3.5.1
WORKDIR /app
COPY . /app

CMD './run.R'
