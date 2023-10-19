sudo apt-get autoremove --purge
sudo apt-get clean
dpkg -l | grep '^rc' | awk '{print $2}' | xargs sudo dpkg --purge
sudo apt-get purge brotli gzip lib32z1 libarchive13:amd64 libbz2-dev:amd64 liblz4-dev:amd64 liblzma-dev:amd64 liblzo2-2:amd64 libmono-system-io-compression-filesystem4.0-cil libmono-system-io-compression4.0-cil libmspack0:amd64 libsnappy1v5:amd64 libucl1:amd64 libwebp6:amd64 libwebpmux3:amd64 p7zip p7zip-full upx-ucl -y || true
sudo apt-get update -y
sudo apt-get install git build-essential libncurses-dev libssl-dev libelf-dev libc-dev bison bc flex rsync debhelper screen libstdc++6 jq -y