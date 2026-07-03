.PHONY: setup lint test tf-init tf-plan tf-apply ansible-deploy helm-deploy clean

# Global Variables
ENV ?= dev

# --- Local Development ---
setup:
	@test -d .venv || (echo "Creating new environment..." && uv venv) && uv sync --all-extras

lint:
	uv run ruff check --fix src/ tests/
	uv run ruff format --check src/ tests/
	uv run mypy src/helixscale/

test:
	uv run pytest tests/unit -v

# --- Infrastructure (Terraform) ---
tf-init:
	cd infra/terraform/environments/$(ENV) && terraform init

tf-fmt:
	terraform fmt -recursive infra/terraform/

tf-validate: tf-init
	cd infra/terraform/environments/$(ENV) && terraform validate

tf-plan: tf-init
	cd infra/terraform/environments/$(ENV) && terraform plan

tf-apply: tf-init
	@if [ "$(ENV)" = "cloud/prod" ]; then \
		cd infra/terraform/environments/$(ENV) && terraform apply; \
	else \
		cd infra/terraform/environments/$(ENV) && terraform apply -auto-approve; \
	fi

# --- Configuration Management (Ansible) ---
ansible-deploy:
	cd infra/ansible && ansible-playbook -i inventory/$(ENV) playbooks/site.yml

# --- Kubernetes Workloads (Helm) ---
helm-deploy:
	helmfile -f infra/helm/helmfile.yaml -e $(ENV) apply

clean:
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete
	rm -rf .pytest_cache .mypy_cache .ruff_cache