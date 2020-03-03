PROJECT_NAME ?= suggpro
PROJECT_VARIANT_NAME ?= infrastructure
STAGE ?= dev
PROFILE ?= default

AWS_REGION ?= eu-west-1

ifeq ($(PROJECT_NAME), suggpro)
    PROJECT_NAME = sugg
    BASE_FOLDER = suggpro
else
    BASE_FOLDER = $(PROJECT_NAME)
endif

hosted-zone:
	@ set -e ; \
	VARIANT="hosted-zone" ; \
	FOLDER="$(BASE_FOLDER)/$$VARIANT" ; \
	AWS_STACK_NAME=$(PROJECT_NAME)-$(PROJECT_VARIANT_NAME)-$$VARIANT-$(STAGE) ; \
	PARAMETERS=$$(jq -r '.[] | [.ParameterKey, .ParameterValue] | join("=")' $$FOLDER/$(STAGE).json) ; \
	FILE_TEMPLATE=$$FOLDER/base.yml ; \
	aws cloudformation deploy \
		--template-file $$FILE_TEMPLATE \
		--region $(AWS_REGION) \
		--capabilities CAPABILITY_IAM \
		--stack-name $$AWS_STACK_NAME \
		--parameter-overrides $$PARAMETERS \
		--profile $(PROFILE)

dns:
	@ set -e ; \
	VARIANT="dns" ; \
	FOLDER="$(BASE_FOLDER)/$$VARIANT" ; \
	AWS_STACK_NAME=$(PROJECT_NAME)-$(PROJECT_VARIANT_NAME)-$$VARIANT-$(STAGE) ; \
	PARAMETERS=$$(jq -r '.[] | [.ParameterKey, .ParameterValue] | join("=")' $$FOLDER/$(STAGE).json) ; \
	FILE_TEMPLATE=$$FOLDER/base.yml ; \
	aws cloudformation deploy \
		--template-file $$FILE_TEMPLATE \
		--region $(AWS_REGION) \
		--capabilities CAPABILITY_IAM \
		--stack-name $$AWS_STACK_NAME \
		--parameter-overrides $$PARAMETERS \
		--profile $(PROFILE)

certificates:
	@ set -e ; \
	VARIANT="certificates" ; \
	FOLDER="$(BASE_FOLDER)/$$VARIANT" ; \
	AWS_STACK_NAME=$(PROJECT_NAME)-$(PROJECT_VARIANT_NAME)-$$VARIANT-$(STAGE) ; \
	PARAMETERS=$$(jq -r '.[] | [.ParameterKey, .ParameterValue] | join("=")' $$FOLDER/$(STAGE).json) ; \
	FILE_TEMPLATE=$$FOLDER/base.yml ; \
	aws cloudformation deploy \
		--template-file $$FILE_TEMPLATE \
		--region $(AWS_REGION) \
		--capabilities CAPABILITY_IAM \
		--stack-name $$AWS_STACK_NAME \
		--parameter-overrides $$PARAMETERS \
		--profile $(PROFILE)

dns-custom:
	@ set -e ; \
	VARIANT="dns-custom" ; \
	FOLDER="$(BASE_FOLDER)/$$VARIANT" ; \
	AWS_STACK_NAME=$(PROJECT_NAME)-$(PROJECT_VARIANT_NAME)-$$VARIANT-$(STAGE) ; \
	FILE_TEMPLATE=$$FOLDER/$(STAGE).yml ; \
	aws cloudformation deploy \
		--template-file $$FILE_TEMPLATE \
		--region $(AWS_REGION) \
		--capabilities CAPABILITY_IAM \
		--stack-name $$AWS_STACK_NAME \
		--profile $(PROFILE)

other-hosted-zone:
	@ set -e ; \
	VARIANT="hosted-zone" ; \
	FOLDER="other/$$VARIANT" ; \
	AWS_STACK_NAME=sugg-$(PROJECT_VARIANT_NAME)-other-$$VARIANT-$(STAGE) ; \
	FILE_TEMPLATE=$$FOLDER/$(STAGE).yml ; \
	aws cloudformation deploy \
		--template-file $$FILE_TEMPLATE \
		--region $(AWS_REGION) \
		--capabilities CAPABILITY_IAM \
		--stack-name $$AWS_STACK_NAME \
		--profile $(PROFILE)

other-certificates:
	@ set -e ; \
	VARIANT="certificates" ; \
	FOLDER="other/$$VARIANT" ; \
	AWS_STACK_NAME=sugg-$(PROJECT_VARIANT_NAME)-other-$$VARIANT-$(STAGE) ; \
	FILE_TEMPLATE=$$FOLDER/$(STAGE).yml ; \
	aws cloudformation deploy \
		--template-file $$FILE_TEMPLATE \
		--region $(AWS_REGION) \
		--capabilities CAPABILITY_IAM \
		--stack-name $$AWS_STACK_NAME \
		--profile $(PROFILE)

other-dns:
	@ set -e ; \
	VARIANT="dns" ; \
	FOLDER="other/$$VARIANT" ; \
	AWS_STACK_NAME=sugg-$(PROJECT_VARIANT_NAME)-other-$$VARIANT-$(STAGE) ; \
	FILE_TEMPLATE=$$FOLDER/$(STAGE).yml ; \
	aws cloudformation deploy \
		--template-file $$FILE_TEMPLATE \
		--region $(AWS_REGION) \
		--capabilities CAPABILITY_IAM \
		--stack-name $$AWS_STACK_NAME \
		--profile $(PROFILE)

other-imgix:
	@ set -e ; \
	VARIANT="imgix" ; \
	FOLDER="other/$$VARIANT" ; \
	AWS_STACK_NAME=sugg-$(PROJECT_VARIANT_NAME)-other-$$VARIANT-$(STAGE) ; \
	FILE_TEMPLATE=$$FOLDER/$(STAGE).yml ; \
	aws cloudformation deploy \
		--template-file $$FILE_TEMPLATE \
		--region $(AWS_REGION) \
		--capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM \
		--stack-name $$AWS_STACK_NAME \
		--profile $(PROFILE)

postgre:
	@ set -e ; \
	VARIANT="postgreSQL" ; \
	FOLDER="$(BASE_FOLDER)/$$VARIANT" ; \
	AWS_STACK_NAME=$(PROJECT_NAME)-$(PROJECT_VARIANT_NAME)-$$VARIANT-$(STAGE) ; \
	PARAMETERS=$$(jq -r '.[] | [.ParameterKey, .ParameterValue] | join("=")' $$FOLDER/$(STAGE).json) ; \
	FILE_TEMPLATE=$$FOLDER/base.yml ; \
	aws cloudformation deploy \
		--template-file $$FILE_TEMPLATE \
		--region $(AWS_REGION) \
		--capabilities CAPABILITY_IAM \
		--stack-name $$AWS_STACK_NAME \
		--parameter-overrides $$PARAMETERS \
		--profile $(PROFILE)

.PHONY: hosted-zone dns certificates dns-custom other-hosted-zone other-certificates other-dns
