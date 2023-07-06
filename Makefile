PROGRAM_NAME = provisioner
build:
	cd provision/ && go build -o $(PROGRAM_NAME) .
	mv ./provision/$(PROGRAM_NAME) .

run:
	./provision/$(PROGRAM_NAME)

test-destroy:
	./provision.sh --master-nodes 0
	make build && make run
