FROM alpine:latest

ENV HOME=/
ENV VAULT_VERSION="0.10.0"

HEALTHCHECK NONE

RUN apk add --update \
  curl \
  postgresql-client \
  ca-certificates \
  git \
  net-tools \
  nmap \
  python \
  py-pip \
  tcpdump \
  iputils \
  bind-tools \
  mysql-client \
  vim \
  jq \
  bash \
  bash-completion \
  iptables \
  openssh-client \
  openssl \
  wget

# Install pip modules
RUN pip install kubernetes

# Install latest kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
      && chmod +x ./kubectl \
      && mv ./kubectl /usr/local/bin/kubectl

# Install latest kops
RUN curl -LO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64 \
    && chmod +x kops-linux-amd64 \
    && mv kops-linux-amd64 /usr/local/bin/kops

# Install latest helm
RUN wget https://storage.googleapis.com/kubernetes-helm/helm-v2.10.0-rc.2-linux-amd64.tar.gz && tar -zxvf helm-v2.10.0-rc.2-linux-amd64.tar.gz
RUN mv linux-amd64/helm /usr/local/bin/helm

# Install vault (Specified version above)
RUN curl -LO https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip \
  && unzip vault_${VAULT_VERSION}_linux_amd64.zip \
  && rm vault_${VAULT_VERSION}_linux_amd64.zip \
  && chmod +x vault \
  && mv vault /usr/local/bin/vault
