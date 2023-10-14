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

echo "切换Kernel"
if ! git checkout linux-6.5.y; then
    echo "切换Kernel失败"
    exit 1
fi

if echo "Merge remote-tracking branch 'google-bbr/v3' into linux-6.5.y" > .git/MERGE_MSG; then
    echo "合并消息写入成功"
else
    echo "合并消息写入失败"
    exit 1
fi

echo "BBRv3合并到Kernel"
if ! git merge; then
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

echo "开始构建"

(
    cd linux
    echo "编译Linux (x86_64)"
    if ! make -j$(nproc) LLVM=1 CC="sccache clang" HOSTCC="sccache clang" olddefconfig; then
        echo "编译Linux (x86_64)失败"
        exit 1
    fi

    if ! make -j$(nproc) LLVM=1 CC="sccache clang" HOSTCC="sccache clang" bindeb-pkg; then
        echo "编译Linux (x86_64)失败"
        exit 1
    fi
) &

(
    cd linux-arm
    echo "编译Linux (ARM64)"
    if ! make -j$(nproc) LLVM=1 ARCH=arm64 CC="sccache clang" HOSTCC="sccache clang" olddefconfig; then
        echo "编译Linux (ARM64)失败"
        exit 1
    fi

    if ! make -j$(nproc) LLVM=1 ARCH=arm64 CC="sccache clang" HOSTCC="sccache clang" bindeb-pkg; then
        echo "编译Linux (ARM64)失败"
        exit 1
    fi
) &

wait

echo "构建完成"
