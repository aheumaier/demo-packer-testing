all: validate build

validate:
	packer validate -var build_rg=rg-shared-dev template.ubuntu.json
build: 
	packer build -var build_rg=rg-shared-dev template.ubuntu.json 