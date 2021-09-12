path "ssh/creds/devs" {
  capabilities = ["read"]
}

path "ssh/creds/ops" {
  capabilities = ["read"]
}

# ↓ がただしいらしい?
path "secret/ssh/creds/devs" {
  capabilities = ["read"]
}

path "secret/ssh/creds/ops" {
  capabilities = ["read"]
}
