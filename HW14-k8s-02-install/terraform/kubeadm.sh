#!/bin/bash

sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
sudo mkdir -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl containerd
sudo apt-mark hold kubelet kubeadm kubectl

sudo modprobe  br_netfilter
sudo /bin/su -c "echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf"
sudo /bin/su -c "echo 'net.bridge.bridge-nf-call-iptables=1' >> /etc/sysctl.conf"
sudo /bin/su -c "echo 'net.bridge.bridge-nf-call-arptables=1' >> /etc/sysctl.conf"
sudo /bin/su -c "echo 'net.bridge.bridge-nf-call-ip6tables=1' >> /etc/sysctl.conf"
sudo sysctl -p /etc/sysctl.conf

