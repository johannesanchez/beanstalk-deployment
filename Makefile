# Import local environment overrides
$(shell touch .env)
include .env

# Project variables
VAR ?= var.local

# AWS ECR Settings
DOCKER_REGISTRY ?= 
AWS_ACCOUNT_ID ?= 
DOCKER_LOGIN_EXPRESSION ?= aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin URL_ECR

# Release settings
export ENVVAR ?= X

#template
test:
	${INFO} "Locate to directory"
	@ cd ./docker
	${INFO} "Building images ..."
	@ docker build -t grafanatest .
	# ${INFO} "Building images..."
	# @ docker-compose $(TEST_ARGS) build $(NOPULL_FLAG) test
	${INFO} "Running tests..."
	@ docker-compose $(TEST_ARGS) up test
	# ${INFO} "Running tests..."
	# @ docker-compose $(TEST_ARGS) up test
	@ mkdir -p $(TEST_DIR)
	@ docker cp $$(docker-compose $(TEST_ARGS) ps -q test):/app/build/test-results/junit/. $(TEST_DIR)
	@ $(call check_exit_code,$(TEST_ARGS),test)
	${INFO} "Removing existing artefacts..."
	@ rm -rf build
	${INFO} "Copying build artefacts..."
	@ docker cp $$(docker-compose $(TEST_ARGS) ps -q test):/app/build/. build
	${INFO} "Test complete"