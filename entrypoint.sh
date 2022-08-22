#!/usr/bin/env sh

# Install kubectl 
curl -LO https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
&& install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl


# Create kube directory
if [ ! -d "$HOME/.kube" ]; then
	mkdir -p $HOME/.kube
fi

# paste kubeconfig
echo $BASE64_KUBE_CONFIG | base64 -d > $HOME/.kube/config 


kubectl $*
