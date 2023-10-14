#!/bin/bash

echo "克隆Kernel"
if ! git clone --branch linux-6.5.y --jobs=0 https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git; then
    echo "克隆Kernel失败"
    exit 1
fi

cd linux || exit 1

echo "添加BBR远程仓库"
if ! git remote add google-bbr https://github.com/google/bbr.git; then
    echo "添加BBR远程仓库失败"
    exit 1
fi

echo "更新BBR仓库"
if ! git fetch google-bbr; then
    echo "更新BBR仓库失败"
    exit 1
fi

echo "切换BBRv3"
if ! git checkout google-bbr/v3; then
    echo "切换BBRv3失败"
    exit 1
fi

echo "切换Kernel"
if ! git checkout linux-6.5.y; then
    echo "切换Kernel失败"
    exit 1
fi

echo "BBRv3合并到Kernel"
if ! git merge --no-edit google-bbr/v3; then
    echo "BBRv3合并到Kernel失败"
    exit 1
fi

cd .. || exit 1

echo "复制Kernel"
if ! cp -r linux linux-arm; then
    echo "复制Kernel失败"
    exit 1
fi

echo "AMD配置"
if ! curl -sSL https://raw.githubusercontent.com/BPG8780/BBR/main/AMD/.config > linux/.config; then
    echo "AMD配置失败"
    exit 1
fi

echo "ARM配置"
if ! curl -sSL https://raw.githubusercontent.com/BPG8780/BBR/main/AMD/.config > linux-arm/.config; then
    echo "ARM配置失败"
    exit 1
fi


