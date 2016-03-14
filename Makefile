build:
	@docker build -t cedvan/toran-proxy:latest .

start:
	@docker run --name toran-proxy -d -p 80:80 -e "TORAN_CRON_TIMER=minutes" -v /tmp/toran-proxy:/data/toran-proxy cedvan/toran-proxy:latest

logs:
	@docker logs -f toran-proxy

stop:
	@docker stop toran-proxy

remove: stop
	@docker rm -f toran-proxy

bash:
	@docker exec -it toran-proxy bash

clean:
	@sudo rm -rf /tmp/toran-proxy
