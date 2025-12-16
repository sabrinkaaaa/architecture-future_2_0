#!/bin/bash
set -e

curl -sfL https://get.k3s.io | sh -

sudo cat /etc/rancher/k3s/k3s.yaml > /home/ubuntu/k3s.yaml
sudo chown ubuntu:ubuntu /home/ubuntu/k3s.yaml

echo "K3s installed"
