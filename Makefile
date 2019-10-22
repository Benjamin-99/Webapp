PROJECT_NAME ?= sugg
PROJECT_VARIANT_NAME ?= infrastructure
STAGE ?= dev
PROFILE ?= default

AWS_REGION ?= eu-west-1

hosted-zone:
	@ set -e ; \
	FOLDER="hosted-zone" ; \
	AWS_STACK_NAME=$(PROJECT_NAME)-$(PROJECT_VARIANT_NAME)-$$FOLDER-$(STAGE) ; \
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
	FOLDER="dns" ; \
	AWS_STACK_NAME=$(PROJECT_NAME)-$(PROJECT_VARIANT_NAME)-$$FOLDER-$(STAGE) ; \
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
    FOLDER="certificates" ; \
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
	FOLDER="dns-custom" ; \
	AWS_STACK_NAME=$(PROJECT_NAME)-$(PROJECT_VARIANT_NAME)-$$FOLDER-$(STAGE) ; \
	FILE_TEMPLATE=$$FOLDER/$(STAGE).yml ; \
	aws cloudformation deploy \
		--template-file $$FILE_TEMPLATE \
		--region $(AWS_REGION) \
		--capabilities CAPABILITY_IAM \
		--stack-name $$AWS_STACK_NAME \
		--profile $(PROFILE)

.PHONY: hosted-zone dns certificates dns-custom
