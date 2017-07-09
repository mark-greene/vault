require "vault"
require "time"
# https://infinum.co/the-capsized-eight/hiding-secrets-in-vault

# The address of the Vault server, also read as ENV["VAULT_ADDR"]
#client = Vault::Client.new(address: "https://vault.cloud.onelxk.co")
client = Vault::Client.new(address: "http://localhost:8200")

# The token to authenticate with Vault, also read as ENV["VAULT_TOKEN"]
# client.token = "dev-token" # for Vault-Dev
# vault token-create # for Vault-HA
# token          	a0422291-3451-e148-abdc-ae760c142848
# token_accessor 	73b22c8f-5251-edf6-ce54-88bd3df8bded
client.token = "a0422291-3451-e148-abdc-ae760c142848"

# # Proxy connection information, also read as ENV["VAULT_PROXY_(thing)"]
# client.proxy_address  = "10.10.9.101"
# client.proxy_port     = "443"

# Custom SSL PEM, also read as ENV["VAULT_SSL_CERT"]
# client.ssl_pem_file = "/Users/mark/.ssh/HashiCorp-Vault.pem"

# Use SSL verification, also read as ENV["VAULT_SSL_VERIFY"]
client.ssl_verify = false

# Timeout the connection after a certain amount of time (seconds), also read
# as ENV["VAULT_TIMEOUT"]
client.timeout = 30

# It is also possible to have finer-grained controls over the timeouts, these
# may also be read as environment variables
client.ssl_timeout  = 5
client.open_timeout = 5
client.read_timeout = 30

p client.sys.mounts
p client.sys.seal_status
p client.logical.write("secret/mark", awesome: true, awards: "12")
p client.logical.read("secret/mark")
p client.logical.write("cubbyhole/mark", awesome: true, awards: "21")
p client.logical.read("cubbyhole/mark")

# Request new access token as wrapped response where the TTL of the temporary
# token is "5s".
wrapped = client.auth_token.create(wrap_ttl: "5s")

# Unwrap wrapped response for final token using the initial temporary token.
p token = client.logical.unwrap_token(wrapped)
