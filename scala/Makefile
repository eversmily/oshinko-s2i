LOCAL_IMAGE ?= radanalytics-scala-spark

# If you are going to push the built image to a registry
# using the "push" make target then you should replace
# "project" with an appropriate path for your registry and/or project
PUSH_IMAGE=project/radanalytics-scala-spark

DOCKERFILE=../Dockerfile.scala
DOCKERFILE_CONTEXT=..

.PHONY: build clean push test

build:
	docker build --pull -t $(LOCAL_IMAGE) -f $(DOCKERFILE) $(DOCKERFILE_CONTEXT)

clean:
	- docker rmi $(LOCAL_IMAGE)
	rm -rf utils

push: build
	docker tag $(LOCAL_IMAGE) $(PUSH_IMAGE)
	docker push $(PUSH_IMAGE)

utils:
	cd ../common && make build
	cp -r ../common/utils .

test:
	docker build -t $(PUSH_IMAGE)-candidate -f $(DOCKERFILE) $(DOCKERFILE_CONTEXT)
	IMAGE_NAME=$(PUSH_IMAGE)-candidate test/run
