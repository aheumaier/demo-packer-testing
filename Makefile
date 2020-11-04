all: build-all

validate:
	packer validate -var build_rg=rg-shared-dev template.multiplatform.json
build-all: validate
	packer build -var build_rg=rg-shared-dev template.multiplatform.json 
build-docker: validate
	 packer build -only docker-ubuntu -var build_rg=rg-shared-dev template.multiplatform.json 
build-ubuntu: validate
	packer build -only azure-ubuntu -var build_rg=rg-shared-dev template.multiplatform.json 
build-windows: validate
	packer build -only azure-windows-server -var build_rg=rg-shared-dev template.multiplatform.json 