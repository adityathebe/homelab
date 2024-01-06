#!/bin/bash

# TODO: Move to certmanager

namespaces=("default" "media" "music" "monitoring" "immich")

# Loop through namespaces to delete secrets
for namespace in "${namespaces[@]}"; do
  kubectl -n "$namespace" delete secret home.adityathebe.com
  kubectl -n "$namespace" delete secret wildcard.home.adityathebe.com
done

# Loop through namespaces to create secrets
for namespace in "${namespaces[@]}"; do
  kubectl -n "$namespace" create secret tls wildcard.home.adityathebe.com \
    --key "$HOME/.acme.sh/*.home.adityathebe.com_ecc/*.home.adityathebe.com.key" \
    --cert "$HOME/.acme.sh/*.home.adityathebe.com_ecc/fullchain.cer"

  kubectl -n "$namespace" create secret tls home.adityathebe.com \
    --key "$HOME/.acme.sh/home.adityathebe.com_ecc/home.adityathebe.com.key" \
    --cert "$HOME/.acme.sh/home.adityathebe.com_ecc/fullchain.cer"
done

kubectl -n default create secret tls home.adityathebe.com \
  --key "$HOME/.acme.sh/home.adityathebe.com_ecc/home.adityathebe.com.key" \
  --cert "$HOME/.acme.sh/home.adityathebe.com_ecc/fullchain.cer"
