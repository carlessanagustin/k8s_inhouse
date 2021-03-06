ANSIBLE_FOLDER ?= ./ansible/playbooks
INVENTORY ?= ./ansible/inventory/gcp

LIMIT ?=
TAG ?=
DEBUG ?= --list-tasks --list-hosts
ASK_PASS ?=

####### gcp instances
gce_instances:
	ansible-playbook -i ${INVENTORY} ${ANSIBLE_FOLDER}/gce_instance.yml ${DEBUG}

####### ansible help
ping_ansible:
	ansible all -i ${INVENTORY} -m ping ${ASK_PASS}

facts_ansible:
	ansible all -i ${INVENTORY} -m setup ${ASK_PASS}

####### kubernetes: create
install_k8s:
	ansible-playbook -i ${INVENTORY} ${ANSIBLE_FOLDER}/install_k8s.yml ${LIMIT} ${TAG} ${DEBUG} ${ASK_PASS}

setup_k8s_master:
	ansible-playbook -i ${INVENTORY} ${ANSIBLE_FOLDER}/setup_k8s_master.yml ${LIMIT} ${TAG} ${DEBUG} ${ASK_PASS}

setup_k8s_worker:
	ansible-playbook -i ${INVENTORY} ${ANSIBLE_FOLDER}/setup_k8s_worker.yml ${LIMIT} ${TAG} ${DEBUG} ${ASK_PASS}

create_k8s: install_k8s setup_k8s_master setup_k8s_worker

# new user? run this!
setup_k8s_user_env: TAG="-t user_env" setup_k8s_master

####### glusterfs
provision_glusterfs:
	ansible-playbook -i ${INVENTORY} ${ANSIBLE_FOLDER}/provision_glusterfs.yml ${LIMIT} ${TAG} ${DEBUG} ${ASK_PASS}

####### haproxy
provision_haproxy:
	ansible-playbook -i ${INVENTORY} ${ANSIBLE_FOLDER}/provision_haproxy.yml ${LIMIT} ${TAG} ${DEBUG} ${ASK_PASS}

####### helm
provision_helm:
	ansible-playbook -i ${INVENTORY} ${ANSIBLE_FOLDER}/provision_helm.yml ${LIMIT} ${TAG} ${DEBUG} ${ASK_PASS}

####### k8s tools: kompose, kustomize & sysdig
provision_tools:
	ansible-playbook -i ${INVENTORY} ${ANSIBLE_FOLDER}/provision_tools.yml ${LIMIT} ${TAG} ${DEBUG} ${ASK_PASS}

####### ingress
provision_ingress:
	ansible-playbook -i ${INVENTORY} ${ANSIBLE_FOLDER}/provision_ingress.yml ${LIMIT} ${TAG} ${DEBUG} ${ASK_PASS}

####### tick
provision_tick:
	ansible-playbook -i ${INVENTORY} ${ANSIBLE_FOLDER}/provision_tick.yml ${LIMIT} ${TAG} ${DEBUG} ${ASK_PASS}

####### telegraf
provision_telegraf:
	ansible-playbook -i ${INVENTORY} ${ANSIBLE_FOLDER}/provision_telegraf.yml ${LIMIT} ${TAG} ${DEBUG} ${ASK_PASS}

####### ark
provision_ark:
	ansible-playbook -i ${INVENTORY} ${ANSIBLE_FOLDER}/provision_ark.yml ${LIMIT} ${TAG} ${DEBUG} ${ASK_PASS}





####### kubernetes: rejoin
provision_k8s_rejoin: install_k8s setup_k8s_master setup_k8s_worker_rejoin

setup_k8s_worker_rejoin:
	ansible-playbook -i ${INVENTORY} ${ANSIBLE_FOLDER}/setup_k8s_worker.yml --extra-vars UNJOIN=true ${LIMIT} ${TAG} ${DEBUG} ${ASK_PASS}
