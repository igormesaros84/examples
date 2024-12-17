# Intro
Sample terraform script that deploys a resource group, and within a `vpn` with a `vpn gateway` through which you can connect to a `vm`.

# Instructions

Running the terraform requires running the following commands in order

```
terraform init
terraform plan -var-file="./values/default-vars.tfvars" 
terraform apply -var-file="./values/default-vars.tfvars"
```

When prompted type in `yes`,
