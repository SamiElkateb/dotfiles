#!/bin/bash

# Dependencies Ansible-vault, Github CLI (gh), Git, Awk, ssh-keygen

set -e

ARG="$1"
CONFIG_DIR="$HOME/.config"
SSH_DIR="$HOME/.ssh"

function prepare() {
  GIT_STATUS=$(git status)
  if ! echo "$GIT_STATUS" |grep -q "nothing to commit, working tree clean" ; then
    echo "prepare-otc: config has uncommited changes"
    exit 1
  fi

  cd "$CONFIG_DIR"

  if ! [[ -f "$CONFIG_DIR/public/id_otc" ]]; then
    CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
    git checkout main && git pull
    git checkout -B "prepare/installation"
    mkdir -p "$SSH_DIR"
    chmod 700 "$SSH_DIR"
    ssh-keygen -b 4096 -t rsa -f "$SSH_DIR/id_otc" -N "" -C "$USER@$HOSTNAME"
    gh ssh-key add "$SSH_DIR/id_otc.pub" -t "install-OTC"
    rm "$SSH_DIR/id_otc.pub"
    ansible-vault encrypt "$SSH_DIR/id_otc" 
    mkdir -p "$CONFIG_DIR/public"
    mv "$SSH_DIR/id_otc" "$CONFIG_DIR/public/id_otc" 
    git add "$CONFIG_DIR/public/id_otc" && git commit -m "prepare: new install"
    git push -u origin prepare/installation
    git checkout "$CURRENT_BRANCH"
  else
    echo "prepare-otc: otc already exists"
    exit 1
  fi
}

function use() {
  cd "$CONFIG_DIR"
  if ! [[ -f "$CONFIG_DIR/public/id_otc" ]]; then
    echo "use-otc: OTC does not exist"
    exit 1
  fi
  if [[ -f "$SSH_DIR/id_rsa" ]]; then
    echo "use-otc: RSA key already exists!"
    exit 1
  fi
  mv "$CONFIG_DIR/public/id_otc" "$SSH_DIR/id_rsa"
  ansible-vault decrypt "$SSH_DIR/id_rsa" 
}

function delete() {
  GIT_STATUS=$(git status)
  if ! echo "$GIT_STATUS" |grep -q "nothing to commit, working tree clean" ; then
    echo "delete-otc: config has uncommited changes"
    exit 1
  fi

  cd "$CONFIG_DIR"
  CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
  OTC_IDS="$(gh ssh-key list|grep install-OTC|awk '{print $5}')"

  IFS=$'\n'
  for id in $OTC_IDS; do
     gh ssh-key delete "$id" -y
  done

  git checkout prepare/installation
  git reset HEAD~1 --hard
  git push --force
  git checkout "$CURRENT_BRANCH"
}

if [ "$ARG" == "prepare" ]; then
  prepare
elif [ "$ARG" == "use" ]; then
  use
elif [ "$ARG" == "delete" ]; then
  delete
fi
