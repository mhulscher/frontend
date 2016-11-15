ifndef $(RELEASE)
RELEASE=$(shell git tag -l --points-at HEAD)
ifneq ($(RELEASE),)
MAJOR=$(shell echo ${RELEASE} | cut -d. -f1)
endif
endif
BRANCH=$(shell git rev-parse --abbrev-ref HEAD | perl -ne 'print lc' | tr /: -)
COMMIT=$(BRANCH)-$(shell git rev-parse --short HEAD)
ifndef $(APP)
APP=frontend
endif
REGISTRY=eu.gcr.io/sysops-1372
REPOSITORY=$(REGISTRY)/$(APP)

all: docker-image
clean: docker-rmi

ci-build: docker-image test docker-push write-version docker-rmi
ci-deploy: deis-deploy

test:
	bash ./tests.sh $(REPOSITORY):$(COMMIT)

docker-image:
	docker build --force-rm -t $(REPOSITORY):$(COMMIT) .
ifneq ($(RELEASE),)
	docker tag $(REPOSITORY):$(COMMIT) $(REPOSITORY):$(RELEASE)
	docker tag $(REPOSITORY):$(COMMIT) $(REPOSITORY):$(MAJOR)
endif

docker-push:
	docker push $(REPOSITORY):$(COMMIT)
ifneq ($(RELEASE),)
	docker push $(REPOSITORY):$(RELEASE)
	docker push $(REPOSITORY):$(MAJOR)
endif

write-version:
ifneq ($(RELEASE),)
	echo release=$(RELEASE) > ci-vars.txt
else
	echo release=$(COMMIT)  > ci-vars.txt
endif

docker-rmi:
	docker rmi $(REPOSITORY):$(COMMIT)
ifneq ($(RELEASE),)
	docker rmi $(REPOSITORY):$(RELEASE)
	docker rmi $(REPOSITORY):$(MAJOR)
endif

deis-deploy:
ifneq ($(RELEASE),)
	deis pull $(REPOSITORY):$(RELEASE) -a $(APP)
else
	deis pull $(REPOSITORY):$(COMMIT) -a $(APP)
endif
