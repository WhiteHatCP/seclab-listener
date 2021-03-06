#!/bin/bash
set -e
eval "$(ssh-agent -s)"
chmod 700 travis
openssl aes-256-cbc -K $encrypted_fa51861454fb_key -iv $encrypted_fa51861454fb_iv -in travis/deploy.enc -out travis/deploy -d
chmod 600 travis/deploy
ssh-add travis/deploy
mkdir -m 700 -p ~/.ssh
echo -e "Host *\n\tStrictHostKeyChecking no\n" > ~/.ssh/config
git remote add deploy "git@thewhitehat.club:go/src/github.com/WhiteHatCP/seclab-listener"
echo "Added deploy remote"
git push deploy master 2>&1 | tee deploy.out
grep -q "SUCCESS" deploy.out
