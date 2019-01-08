#!/usr/bin/env bash
# RUN AS ROOT
# from: https://github.com/kubernetes/kubeadm/issues/610 + https://kubernetes.io/docs/setup/independent/install-kubeadm/

kubeadm_conf=/etc/systemd/system/kubelet.service.d/10-kubeadm.conf
if [[ $(swapon | wc -l) -gt 1 ]] ;  then
  # echo "swap ON"
  kubeadm reset -f

  grep -q '^Environment="KUBELET_EXTRA_ARGS' $kubeadm_conf && \
     sed -i 's/^Environment="KUBELET_EXTRA_ARGS.*/Environment="KUBELET_EXTRA_ARGS=--fail-swap-on=false"/' $kubeadm_conf \
     || echo 'Environment="KUBELET_EXTRA_ARGS=--fail-swap-on=false"' >> $kubeadm_conf

  systemctl daemon-reload
  systemctl restart kubelet

  swapoff -a
  sed -i '/ swap / s/^/#/' /etc/fstab
# else
#   echo "swap OFF" ;
fi
