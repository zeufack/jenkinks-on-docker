.PHONY: start-jenkins
start-jenkins:
	@echo "Running jenkins on docker"
	docker run --rm --name jenkins -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts


# Run a jenkins ocean from custom dockerfile buildes images
.PHONY: ocean-jenkins
ocean-jenkins:
	@echo "Running ocenan jenkins on docker"
	docker run --name jenkins-blueocean  \
                --network jenkins --env DOCKER_HOST=tcp://docker:2376 \
                --env DOCKER_CERT_PATH=/certs/client --env DOCKER_TLS_VERIFY=1 \
                --publish 8080:8080 --publish 50000:50000 \
                --volume jenkins-data:/var/jenkins_home \
                --volume jenkins-docker-certs:/certs/client:ro \
                --volume "$HOME":/home \
                --restart=on-failure \
                --env JAVA_OPTS="-Dhudson.plugins.git.GitSCM.ALLOW_LOCAL_CHECKOUT=true" \
                cutomjenkins-blueocean:2.426.1-1


.PHONY: run-postgress
run-postgress:
	@echo "Running postgress database"
	docker run -d --rm \
		-v pgdata:/var/lib/postgresql/data \
		-v ${PWD}/postgres.conf:/etc/postgresql/postgresql.conf \
		-e POSTGRES_PASSWORD=foobarbaz \
		-p 5432:5432 \
		postgres:15.1-alpine -c 'config_file=/etc/postgresql/postgresql.conf'

