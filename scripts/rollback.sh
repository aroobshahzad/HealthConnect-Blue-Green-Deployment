# rollback.sh
echo "Rolling back to Blue environment"
docker-compose down
docker-compose up -d blue
