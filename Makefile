.DEFAULT_GOAL := help

# -- https://formulae.brew.sh/formula
BREW_FORMULA := homebrew/core

help:
	@awk \
		'BEGIN {FS = ":.*##"; printf "\n\033[1mUsage:\033[0m\n  make \033[36m[ COMMAND ]\n"} \
		/^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2 } \
		/^##@/ { printf "\n\033[1m%s:\033[0m\n", substr($$0, 5) }' \
		$(MAKEFILE_LIST)

# -- @ Commands

.PHONY: all
all: tools cluster ingress registry skaffold certs hosts ## Run all targets

.PHONY: tools	
tools: ## Install necessary tools
	@echo "\n🍺 Install necessary tools"
	brew install --quiet $(BREW_FORMULA)/kind
	brew install --quiet $(BREW_FORMULA)/kubernetes-cli
	brew install --quiet $(BREW_FORMULA)/helm
	brew install --quiet $(BREW_FORMULA)/skaffold
	brew install --quiet $(BREW_FORMULA)/mkcert
	brew install --quiet $(BREW_FORMULA)/nss

.PHONY: cluster
cluster: ## Install local cluster
	@echo "\n⬇️  Install local cluster"
	kind create cluster --config $(PWD)/k8s/kind.yaml --wait 5m

.PHONY: ingress
ingress: ## Setup ingress-nginx controller
	@echo "\n⬇️  Setup ingress-nginx controller"
	kubectl apply --filename $(PWD)/k8s/ingress/deploy.yaml
	@echo "\n⬇️  Wait condition to met"
	kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=120s

.PHONY: registry
registry: ## Configure DockerHub registry in configuration files
	@echo "\n⬇️  Configure DockerHub registry"
	@read -p "Provide your DockerHub account: " dhacc; \
	echo "\n⬇️  Updating configuration with registry: $$dhacc"; \
	sed -i '' 's/<registry>/'"$$dhacc"'/g' $(PWD)/voting-app/skaffold.yaml; \
	sed -i '' 's/<registry>/'"$$dhacc"'/g' $(PWD)/helm/values.yaml; \
	echo "✅ Registry configuration updated"

.PHONY: skaffold
skaffold: ## Generate voting-app images
	@echo "\n⬇️  Using skaffold to generate starting images"
	cd voting-app && \
	export IMAGE_TAG=latest && \
	skaffold build --profile vote-images,-seed-image && \
	skaffold build --profile -vote-images,seed-image

.PHONY: certs
certs: ## Make locally trusted development certificates
	@echo "\n⬇️  Make locally trusted development certificates"
	cd .tls && \
	mkcert '*.kind.local' && \
	kubectl create namespace dev && \
	kubectl --namespace dev create secret tls demo-cert --key=_wildcard.kind.local-key.pem --cert=_wildcard.kind.local.pem && \
	mkcert --install

.PHONY: hosts
hosts: ## Add hosts to /etc/hosts
	@while true; do \
		read -p "Add hosts @ /etc/hosts? [Yy/Nn] " yn; \
		case $$yn in \
			[Yy]*) sudo -- sh -c -e "echo '127.0.0.1 	dev-vote.kind.local dev-result.kind.local' >> /etc/hosts"; break;; \
			[Nn]*) echo "\n⬇️  Skipping..."; break;; \
			*) echo "Please answer Y/y or N/n";; \
		esac; \
	done
