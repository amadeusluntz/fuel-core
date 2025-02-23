#!/usr/bin/env bash
set -e

err() {
    echo -e "\e[31m\e[1merror:\e[0m $@" 1>&2;
}

status() {
    WIDTH=12
    printf "\e[32m\e[1m%${WIDTH}s\e[0m %s\n" "$1" "$2"
}
# install dasel
curl -sSLf "$(curl -sSLf https://api.github.com/repos/tomwright/dasel/releases/latest | grep browser_download_url | grep linux_amd64 | cut -d\" -f 4)" -L -o dasel 
chmod +x dasel
mv ./dasel /usr/local/bin/dasel
# check appVersion with fuel-core
HELM_APP_VERSION=$(cat deployment/charts/Chart.yaml | dasel -r yaml 'appVersion')
FUEL_CORE_VERSION=$(cat fuel-core/Cargo.toml | dasel -r toml 'package.version')
if [ "$HELM_APP_VERSION" != "$FUEL_CORE_VERSION" ]; then
    err "fuel-core version $FUEL_CORE_VERSION, doesn't match helm app version $HELM_APP_VERSION"
    exit 1
else
  status "fuel-core version matches helm chart app version $HELM_APP_VERSION"
fi
