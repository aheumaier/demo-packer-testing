all: validate build-all

validate:
	packer validate -var build_rg=rg-shared-dev template.multiplatform.json
build-all: 
	packer build -only azure-ubuntu -var build_rg=rg-shared-dev template.multiplatform.json 
build-docker:
	 packer build -only docker-ubuntu -var build_rg=rg-shared-dev template.multiplatform.json 