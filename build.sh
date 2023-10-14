#!/bin/bash

kernel() {
    git clone https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git --branch linux-6.5.y 
    cd linux 
    git remote add google-bbr https://github.com/google/bbr.git 
    git fetch google-bbr 
    git checkout linux-6.5.y 
    echo "Merge remote-tracking branch 'google-bbr/v3' into linux-6.5.y" > .git/MERGE_MSG 
    git merge
}

kernel
