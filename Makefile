db-create:
	sudo docker-compose run app bundle exec rake db:create db:migrate

start:
	sudo docker-compose -f docker-compose.yml up