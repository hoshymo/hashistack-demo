# HashiStack demo

HashiCorp product を利用してモダンなインフラをつくるデモ。

## Startup

```
docker compose up
```

## Boundary + Vault

Boundary 起動 log から Auth Method ID と admin Password を得る

```
docker logs hashistack-demo_boundary-server_1

...
Initial auth information:
  Auth Method ID:     ampw_L3MWNBCGH0
  Auth Method Name:   Generated global scope initial password auth method
  Login Name:         admin
  Password:           5pgCIeD7pMdG0LHKshNA
  Scope ID:           global
  User ID:            u_uccFhwZwRo
  User Name:          admin
...
```

tf-boundary/boundary.tf に上記で得た値を入れる

Terraform により Boundary に ssh target を追加する

```
docker exec -it hashistack-demo_n_s1_1 bash

cd tf-boundary
terraform apply
```

host で以下のようにして boundary token を得て、それを環境変数に入れておく

```
boundary authenticate password -auth-method-id=ampw_L3MWNBCGH0 \
  -login-name=admin -password=5pgCIeD7pMdG0LHKshNA

export BOUNDARY_TOKEN=xxxx
```

Boundary web UI http://localhost:9200 に admin で login し、ssh target の id を調べる
以下のようにして ssh する。password が必要。

```
boundary connect ssh -target-id ttcp_E24lgCvCbF -- -l user1
```

(補) target の確認は cli でも可能なはずだが、以下のようにしてもうまくいかない。

```
boundary scopes list
boundary targets list -scope-id o_GJ1NqRwJ9M
```

Vault web UI は http://localhost:8200 でアクセス可能


## Nomad + Consul

同様に、Terraform により Boundary に ssh target を追加する

```
docker exec -it hashistack-demo_n_s1_1 bash

cd tf-nc
terraform apply
```

いくつかのサンプルを入れているので詳しくは .tf を見てください。

Nomad web UI http://localhost:4646 と Consul web UI http://localhost:8500 で状態を確認できます。

example application が http://localhost:9002 で見えるはずだが中途半端で見えてない。

Traefik の例も入れていますがちゃんとつながってない。


## 制限

- 簡易的に試すために、(VM ではなく) Docker compose を使用しています。
  - Nomad は各 host に docker があることを期待するようなので、host の docker を使うようにしています。
    - (おそらくこのために) healthcheck が動作しません。
