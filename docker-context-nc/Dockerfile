FROM ubuntu:latest

WORKDIR /workspace

# Install essentials
RUN set -x && \
  apt update && apt install -y --no-install-recommends \
    systemctl iptables ca-certificates curl dnsutils unzip gnupg && \
  # Installing Envoy ... is not necessary. Consul has built-in proxy for -dev.
  apt install -y --no-install-recommends \
    apt-transport-https gnupg2 lsb-release && \
  curl -sL 'https://deb.dl.getenvoy.io/public/gpg.8115BA8E629CC074.key' | gpg --dearmor -o /usr/share/keyrings/getenvoy-keyring.gpg && \
  echo a077cb587a1b622e03aa4bf2f3689de14658a9497a9af2c427bba5f4cc3c4723 /usr/share/keyrings/getenvoy-keyring.gpg | sha256sum --check && \
  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/getenvoy-keyring.gpg] https://deb.dl.getenvoy.io/public/deb/ubuntu $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/getenvoy.list && \
  apt update && apt install -y --no-install-recommends \
    getenvoy-envoy && \
  # apt -y clean && rm -rf /var/lib/apt/lists/* && \
  echo "done."

# Install HashiCorp tools
RUN set -x && \
  curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - && \
  # instead doing `lsb_release -cs` and apt-add-repository ...
  LSB_RELEASE=$(grep DISTRIB_CODENAME /etc/lsb-release | sed 's/^[A-Z_]*=//g') && \
  echo "deb [arch=amd64] https://apt.releases.hashicorp.com ${LSB_RELEASE} main" | tee /etc/apt/sources.list.d/hashicorp.list && \
  apt update && apt install -y --no-install-recommends \
    terraform nomad consul && \
  echo "done."

# demo apps
RUN set -x && \
  curl -sSL -O https://github.com/hashicorp/demo-consul-101/releases/download/0.0.3.1/counting-service_linux_amd64.zip \
    -O https://github.com/hashicorp/demo-consul-101/releases/download/0.0.3.1/dashboard-service_linux_amd64.zip && \
  unzip counting-service_linux_amd64.zip && \
  unzip dashboard-service_linux_amd64.zip && \
  rm *.zip && \
  mkdir -p /usr/local/exampleapp/bin && \
  mv counting-service_linux_amd64 dashboard-service_linux_amd64 /usr/local/exampleapp/bin && \
  echo "done."

RUN set -x && \
  # (can be space separated list)
  systemctl enable nomad.service && \
  systemctl enable consul.service && \
  # Consul Connect - CNI plugins
  # https://www.nomadproject.io/docs/integrations/consul-connect
  # required to setup network type = "bridge", with iptables
  mkdir -p /opt/cni/bin && \
  curl -sSL "https://github.com/containernetworking/plugins/releases/download/v0.9.0/cni-plugins-linux-$( [ $(uname -m) = aarch64 ] && echo arm64 || echo amd64)"-v0.9.0.tgz | tar -C /opt/cni/bin -xzf - && \
  echo "done."

# docker CLI
RUN set -x && \
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list && \
  apt update && apt install -y --no-install-recommends \
    docker-ce-cli && \
  mkdir -p /var/run/docker/netns && \
  echo "done."

# COPY services /workspace/services
COPY systemd/system/ /etc/systemd/system/
COPY etc /workspace/etc
# COPY tf-nc /workspace/tf # mount the volume instead
COPY docker-entrypoint.sh /workspace/docker-entrypoint.sh

CMD [ "/workspace/docker-entrypoint.sh" ]
