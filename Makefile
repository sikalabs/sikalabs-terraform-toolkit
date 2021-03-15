setup-git-hooks:
	rm -rf .git/hooks
	(cd .git && ln -s ../.git-hooks hooks)

tf-fmt-check:
	terraform fmt -recursive -check

tf-fmt:
	terraform fmt -recursive

GITLAB_DOMAIN = gitlab.example.com
GITLAB_PROJECT_ID = 1
GITLAB_TF_BACKEND_NAME = example

##
# Terraform
##
tf-init:
ifndef GITLAB_USERNAME
	$(error GITLAB_USERNAME is undefined)
endif
ifndef GITLAB_PERSONAL_ACCESS_TOKEN
	$(error GITLAB_PERSONAL_ACCESS_TOKEN is undefined)
endif
	terraform init \
	-backend-config="address=https://${GITLAB_DOMAIN}/api/v4/projects/${GITLAB_PROJECT_ID}/terraform/state/${GITLAB_TF_BACKEND_NAME}" \
	-backend-config="lock_address=https://${GITLAB_DOMAIN}/api/v4/projects/${GITLAB_PROJECT_ID}/terraform/state/${GITLAB_TF_BACKEND_NAME}/lock" \
	-backend-config="unlock_address=https://${GITLAB_DOMAIN}/api/v4/projects/${GITLAB_PROJECT_ID}/terraform/state/${GITLAB_TF_BACKEND_NAME}/lock" \
	-backend-config="username=${GITLAB_USERNAME}" \
	-backend-config="password=${GITLAB_PERSONAL_ACCESS_TOKEN}" \
	-backend-config="lock_method=POST" \
	-backend-config="unlock_method=DELETE" \
	-backend-config="retry_wait_min=5"

