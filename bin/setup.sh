#!/bin/bash

set -e

CONFIG_DIR="$HOME/.config"
TMP_CONFIG_DIR="$HOME/.tmpconfig"
ANSIBLE_DIR="$CONFIG_DIR/ansible"
SSH_DIR="$HOME/.ssh"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if ! [ -x "$(command -v ansible)" ]; then
      sudo apt-get install ansible
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    
    if ! which -s brew; then
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"  
      (echo; echo "eval $(/opt/homebrew/bin/brew shellenv)") >> "$HOME/.zprofile"
      eval "$(/opt/homebrew/bin/brew shellenv)"
      
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

if ! [[ -d "$ANSIBLE_DIR" ]]; then
  if [[ -d "$CONFIG_DIR" ]]; then
    mv "$CONFIG_DIR" "$TMP_CONFIG_DIR"
  fi

  git clone https://github.com/SamiElkateb/dotfiles "$CONFIG_DIR"

  if [[ -d "$TMP_CONFIG_DIR" ]]; then
    mv "$CONFIG_DIR" "$TMP_CONFIG_DIR"
    mv "$TMP_CONFIG_DIR/*" "$CONFIG_DIR/"
    rm -rf "$TMP_CONFIG_DIR"
  fi
else
  cd "$CONFIG_DIR"
  git pull
fi


if [[ -f "$ANSIBLE_DIR/requirements.yml" ]]; then
  cd "$ANSIBLE_DIR"

  ansible-galaxy install -r requirements.yml
fi

cd "$ANSIBLE_DIR"

if [[ -f "$ANSIBLE_DIR/vault-password.txt" ]]; then
  ansible-playbook --diff --vault-password-file "$ANSIBLE_DIR/vault-password.txt" "$ANSIBLE_DIR/main.yml"
else
  ansible-playbook --diff "$ANSIBLE_DIR/main.yml"
fi
