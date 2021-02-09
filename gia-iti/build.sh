source _env.sh

docker build -t $container_tag  .

docker push $container_tag