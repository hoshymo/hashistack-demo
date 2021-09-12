#!/bin/bash

# Startup dev server & agent
# nomad agent -dev -bind 0.0.0.0 -log-level INFO
# consul agent -dev -client 0.0.0.0

# Register Consul services
# consul services register /workspace/services/counting.hcl
# consul services register /workspace/services/dashboard.hcl

# Start apps
# PORT=9002 COUNTING_SERVICE_URL="http://localhost:5000" ./dashboard-service_linux_amd64 > /dev/null &
# PORT=9003 ./counting-service_linux_amd64 > /dev/null &

# Better to define allow/deny rule as intentions
# consul intention create dashboard counting

# Envoy
# consul connect envoy -sidecar-for counting-1 -admin-bind localhost:19001 > counting-proxy.log &
# consul connect envoy -sidecar-for dashboard > dashboard-proxy.log &
# Built-in proxy
# consul connect proxy -sidecar-for counting-1 > counting-proxy.log &
# consul connect proxy -sidecar-for dashboard > dashboard-proxy.log &

: ${X_NOMAD_MODE:=client}
: ${X_CONSUL_MODE:=client}

echo "Nomad: "${X_NOMAD_MODE}
cp /workspace/etc/nomad.hcl.${X_NOMAD_MODE} /etc/nomad.d/nomad.hcl
echo "Consul: "${X_CONSUL_MODE}
cp /workspace/etc/consul.hcl.${X_CONSUL_MODE} /etc/consul.d/consul.hcl

systemctl start nomad
systemctl start consul

# just keep the container up
tail -f /dev/null
