# Local Vault environments with Docker

## Vault - Dev environment
```
https://hub.docker.com/_/vault/

git clone https://github.com/mark-greene/vault.git
docker pull vault

docker run --cap-add IPC_LOCK -e 'VAULT_DEV_ROOT_TOKEN_ID=dev-token' -e 'VAULT_ADDR=http://127.0.0.1:8200' -p 8200:8200 --name=dev-vault vault

curl -s -H "X-Vault-Token: dev-token" -X GET http://localhost:8200/v1/sys/mounts
```

## Vault - HA environment
```
https://github.com/tolitius/cault
```
Follow cault readme from your vault project folder
```
git clone https://github.com/tolitius/cault.git
docker-compose up
docker exec -it cault_vault_1 sh
Init
Unseal
Auth with <Initial Root Token from Init>
```
On host machine
```
alias vault='docker exec -it cault_vault_1 vault "$@"'
vault status

http://localhost:8500/

curl -X GET -H "X-Vault-Token:<Initial Root Token from Init>" http://localhost:8200/v1/sys/mounts

vault token-create	# creates new root token
curl -X GET -H "X-Vault-Token:<new token>" http://localhost:8200/v1/sys/mounts

vault token-create -policy=default
curl -X GET -H "X-Vault-Token:<new token>" http://localhost:8200/v1/sys/mounts
```

## Test Vault
From Dev or HA environment, edit vault.rb with your root token and run
```
ruby vault.rb
```

## Resources

https://www.hashicorp.com/blog/vault-0-6/#response-wrapping

https://www.vaultproject.io/api/index.html

https://aws.amazon.com/quickstart/architecture/vault/
