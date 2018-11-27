# Deploy a Kubernetes in-house

Deploy a Kubernetes cluster in-house. The idea of this Infrastructure as Code repo is to solve the installation of a Kubernetes cluster in-house with Ubuntu OS instances shared files and port forwarding.

The Kubernetes cluster is composed of 1 master node and X worker nodes. We'll use GlusterFS for file sharing purposes, then a HAProxy to forward ports 80 and 443 requests to the cluster nodes.

## Requirements

* Make
* Ansible
* Ubuntu

## Usage

### 1. Create GCE Instances (optional)

* **Use only if you want to create instances in Google Compute Engine.**
* Create a service account following this instructions: https://docs.ansible.com/ansible/latest/scenario_guides/guide_gce.html#credentials
* Copy variables file: `cp ./ansible/playbooks/private.yml.example ./ansible/playbooks/private.yml`
* Edit playbook variables file: `vim ./ansible/playbooks/private.yml`
* Change variables with newly created service account and instance requirements

```yaml
gce_service_account_email: <service account email>
gce_credentials_file: <path to json credentials file>
gce_project_id: <my project id>
gce_nodes:
  - { gce_instance_name: '<instance name>', gce_machine_type: '<n1-standard-2 for example>', gce_tags: '<firewall target tags>'}
gce_image: <ubuntu-1404 for example>
gce_disk_size: <OS disk size in GB>
gce_zone: <GCE zone>
```
* Then run `make gce_instances` to create the instances.

> more info about the Ansible module: https://docs.ansible.com/ansible/2.6/modules/gce_module.html?highlight=gce

### 2. Node authentication

* To allow running Ansible tasks in remote nodes.
* Create inventory file: `cp ./ansible/inventory/gcp.example ./ansible/inventory/gcp`
* Edit inventory file: `vim ./ansible/inventory/gcp`
* Change variables with instance details

```shell
ansible_host=<node ip>
GSERVER_IP=<glusterfs node internal ip>
ansible_user=<ssh user - must be sudo>
ansible_ssh_private_key_file=<path to ssh user key>
```

* Then run `make steps_auto` to deploy Kubernetes, GlusterFS and HAProxy.
* Then setup HAProxy:

```shell
@master$ kubectl get nodes # and save worker IPs
@haproxy$ cd /opt/haproxy
@haproxy$ sudo vim haproxy.cfg # add worker IPs
@haproxy$ sudo make up
```

## Available commands in Makefile

* Create instances in GCP project: `make gce_instances`
* Ansible ping check: `make ping_ansible`
* Create Kubernetes cluster:`make create_k8s`
* Install Helm in Kubernetes master: `make provision_helm`
* Install kompose, kustomize & sysdig Kubernetes master: `make provision_tools`
* Provision GlusterFS node: `make provision_glusterfs`
* Provision HAProxy node: `make provision_haproxy`
* Setup my user environment with Kubernetes cluster: `make setup_k8s_user_env`
* Install Kubernetes requirements and binary files: `make install_k8s`
* Install Kubernetes master with kubeadm: `make setup_k8s_master`
* Join workers to master with kubeadm: `make setup_k8s_worker`
