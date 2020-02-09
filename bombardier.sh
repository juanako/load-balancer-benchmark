#!/bin/bash
mkdir -p $2;

echo "running warmup...";
docker run -ti --rm --network=host --ulimit nofile=20000:40000 alpine/bombardier --fasthttp -o json -p result -c 1000 -n 50000 -t 60s -l $1 | jq '.' | tee "$2/warmup.json" > /dev/null;

sleep 5;

for value in 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000
do
  echo "running concurrency = $value";
  docker run -ti --rm --network=host --ulimit nofile=20000:40000 alpine/bombardier --fasthttp -o json -p result -c $value -n 300000 -t 60s -l $1 | jq '.' | tee "$2/c$value.json" > /dev/null;
  sleep 5;
done
