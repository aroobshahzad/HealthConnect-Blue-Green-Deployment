# switch-traffic.sh
# Switch traffic to Green
docker-compose down blue
docker-compose up -d green
