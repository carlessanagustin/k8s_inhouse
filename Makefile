include Makefiles/ansible.mk

## 1. create instances
step1: gce_instances

# 2. manual step @local node
# update ansible inventory with newly created nodes: `./ansible/inventory/gcp`

## 3. provision k8s master & k8s workers
step2: ping_ansible create_k8s

## 4. provision glusterfs
step3: provision_glusterfs

## 5. provision haproxy
step4: provision_haproxy

# 6. manual step @haproxy node
# `@haproxy$ cd /opt/haproxy`
# change `@haproxy$ sudo vim haproxy.cfg` with worker IPs from `@master$ kubectl get nodes`
# run: `@haproxy$ sudo make up`

steps_auto: step2 step3 step4



requirements:
	sudo apt-get update && sudo apt-get -y install make git ansible

# TODO
step_rejoin: LIMIT="-l master2" install_k8s setup_k8s_master setup_k8s_worker_rejoin
# repeat - 6. manual step @haproxy node
