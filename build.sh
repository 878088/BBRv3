#!/bin/bash

echo "正在克隆 linux-6.5.y 分支..."
if ! git clone --branch linux-6.5.y --jobs=0 https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git; then
    echo "克隆 linux-6.5.y 分支失败"
    exit 1
fi

cd linux || exit 1

echo "正在添加 google-bbr 远程仓库..."
if ! git remote add google-bbr https://github.com/google/bbr.git; then
    echo "添加 google-bbr 远程仓库失败"
    exit 1
fi

echo "正在获取最新的 google-bbr 仓库变更..."
if ! git fetch google-bbr; then
    echo "获取最新的 google-bbr 仓库变更失败"
    exit 1
fi

echo "正在切换到 google-bbr/v3 分支..."
if ! git checkout google-bbr/v3; then
    echo "切换到 google-bbr/v3 分支失败"
    exit 1
fi

echo "正在切换回 linux-6.5.y 分支..."
if ! git checkout linux-6.5.y; then
    echo "切换回 linux-6.5.y 分支失败"
    exit 1
fi

echo "正在将 google-bbr/v3 分支合并到 linux-6.5.y 分支（无需手动编辑）..."
if ! git merge --no-edit google-bbr/v3; then
    echo "将 google-bbr/v3 分支合并到 linux-6.5.y 分支失败"
    exit 1
fi

echo "合并成功完成！"
