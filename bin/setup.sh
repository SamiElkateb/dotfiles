#!/bin/bash

set -e

CONFIG_DIR="$HOME/.config/ansible"
SSH_DIR="$HOME/.ssh"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if ! [ -x "$(command -v ansible)" ]; then
      sudo apt-get install ansible
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    if ! [ -x "$(command -v brew)" ]; then
      sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"  
    fi
    if ! [ -x "$(command -v ansible)" ]; then
      brew install ansible
    fi
else
    echo "OS not supported yet" 
    exit 1
fi

if ! [[ -f "$SSH_DIR/id_rsa" ]]; then
  mkdir -p "$SSH_DIR"

  chmod 700 "$SSH_DIR"

  ssh-keygen -b 4096 -t rsa -f "$SSH_DIR/id_rsa" -N "" -C "$USER@$HOSTNAME"

  # cat "$SSH_DIR/id_rsa.pub" >> "$SSH_DIR/authorized_keys"

  # chmod 600 "$SSH_DIR/authorized_keys"
fi


if [[ -f "$CONFIG_DIR/requirements.yml" ]]; then
  cd "$CONFIG_DIR"

  ansible-galaxy install -r requirements.yml
fi

cd "$CONFIG_DIR"

if [[ -f "$CONFIG_DIR/vault-password.txt" ]]; then
  ansible-playbook --diff --vault-password-file "$CONFIG_DIR/vault-password.txt" "$CONFIG_DIR/main.yml"
else
  ansible-playbook --diff "$CONFIG_DIR/main.yml"
fi
