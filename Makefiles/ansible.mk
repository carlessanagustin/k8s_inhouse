ANSIBLE_FOLDER ?= ./ansible/playbooks
INVENTORY ?= ./ansible/inventory/gcp

LIMIT ?=
TAG ?=
DEBUG ?= --list-tasks --list-hosts

####### gcp instances
gce_instances:
	ansible-playbook -i ${INVENTORY} ${ANSIBLE_FOLDER}/gce_instance.yml ${DEBUG}

####### ansible help
ping_ansible:
	ansible all -i ${INVENTORY} -m ping

facts_ansible:
	ansible all -i ${INVENTORY} -m setup

####### kubernetes: create
install_k8s:
	ansible-playbook -i ${INVENTORY} ${ANSIBLE_FOLDER}/install_k8s.yml ${LIMIT} ${TAG} ${DEBUG}

setup_k8s_master:
	ansible-playbook -i ${INVENTORY} ${ANSIBLE_FOLDER}/setup_k8s_master.yml ${LIMIT} ${TAG} ${DEBUG}

setup_k8s_worker:
	ansible-playbook -i ${INVENTORY} ${ANSIBLE_FOLDER}/setup_k8s_worker.yml ${LIMIT} ${TAG} ${DEBUG}

create_k8s: install_k8s setup_k8s_master setup_k8s_worker

# new user? run this!
setup_k8s_user_env: TAG="-t user_env" setup_k8s_master

####### glusterfs
provision_glusterfs:
	ansible-playbook -i ${INVENTORY} ${ANSIBLE_FOLDER}/provision_glusterfs.yml ${LIMIT} ${TAG} ${DEBUG}

####### haproxy
provision_haproxy:
	ansible-playbook -i ${INVENTORY} ${ANSIBLE_FOLDER}/provision_haproxy.yml ${LIMIT} ${TAG} ${DEBUG}

####### helm
provision_helm:
	ansible-playbook -i ${INVENTORY} ${ANSIBLE_FOLDER}/provision_helm.yml ${LIMIT} ${TAG} ${DEBUG}

####### k8s tools: kompose, kustomize & sysdig
provision_tools:
	ansible-playbook -i ${INVENTORY} ${ANSIBLE_FOLDER}/provision_tools.yml ${LIMIT} ${TAG} ${DEBUG}


# TODO
####### ingress
provision_ingress:
	ansible-playbook -i ${INVENTORY} ${ANSIBLE_FOLDER}/provision_ingress.yml ${LIMIT} ${TAG} ${DEBUG}

####### TICK
provision_tick:
	ansible-playbook -i ${INVENTORY} ${ANSIBLE_FOLDER}/provision_tick.yml ${LIMIT} ${TAG} ${DEBUG}





####### kubernetes: rejoin
provision_k8s_rejoin: install_k8s setup_k8s_master setup_k8s_worker_rejoin

setup_k8s_worker_rejoin:
	ansible-playbook -i ${INVENTORY} ${ANSIBLE_FOLDER}/setup_k8s_worker.yml --extra-vars UNJOIN=true ${LIMIT} ${TAG} ${DEBUG}


## DEPRECATED ###############################################
####### worldsensing actions
deploy_code:
	ansible-playbook -i ${INVENTORY} ${ANSIBLE_FOLDER}/deploy_code.yml ${LIMIT} ${TAG} ${DEBUG}
