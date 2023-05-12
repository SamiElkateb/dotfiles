#!/bin/bash

set -e

# Ask System Events permission:
osascript -e 'tell application "System Events" to keystroke " "'

CONFIG_DIR="$HOME/.config"
TMP_CONFIG_DIR="$HOME/.tmpconfig"
ANSIBLE_DIR="$CONFIG_DIR/ansible"
TMP_DIR="/tmp"

if [ -z "$INSTALL_LEVEL" ]; then
  read -p "Installation Level: 
  1: CORE
  2: BASIC
  3: EXTENDED
  " INSTALL_LEVEL
  export INSTALL_LEVEL
  echo
fi

if [ -z "$WITH_AUTH" ]; then
  read -p "With Authentication: 
  0: NO
  1: YES
  " WITH_AUTH
  export WITH_AUTH
  echo
fi

if [ -z "$ANSIBLE_BECOME_PASSWORD" ]; then
  read -s -p "Ansible Become Password: " ANSIBLE_BECOME_PASSWORD
  export ANSIBLE_BECOME_PASSWORD
  echo
fi

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if ! [ -x "$(command -v ansible)" ]; then
      sudo apt-get install ansible
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    
    if ! which -s brew; then
      curl -fssL https://raw.githubusercontent.com/Homebrew/install/f18475b/install.sh > "$TMP_DIR/brew_install.sh"
      EXPECTED_SHASUM=568c87c18fc211eb8f8236e042741522868f9a09a36f529fe3445544a7b21154
      COMPUTED_SHASUM=$(shasum -a 256 "$TMP_DIR/brew_install.sh" | awk '{print $1}')
      if ! [ "$EXPECTED_SHASUM" = "$COMPUTED_SHASUM" ]; then
        echo "$COMPUTED_SHASUM"
        echo "Brew installer corrupted!"
        exit 1 
      fi
      chmod +x "$TMP_DIR/brew_install.sh"
      export SUDO_ASKPASS="$TMP_DIR/pass.sh"
      echo '#!/bin/bash' > "$SUDO_ASKPASS"
      echo "echo '$ANSIBLE_BECOME_PASSWORD'" >> "$SUDO_ASKPASS"
      chmod +x "$SUDO_ASKPASS"
      export NONINTERACTIVE=1
      "$TMP_DIR/brew_install.sh"
      rm "$SUDO_ASKPASS"
      unset SUDO_ASKPASS

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

# if ! [[ -f "$SSH_DIR/id_rsa" ]]; then
#   mkdir -p "$SSH_DIR"
#
#   chmod 700 "$SSH_DIR"
#
#   ssh-keygen -b 4096 -t rsa -f "$SSH_DIR/id_rsa" -N "" -C "$USER@$HOSTNAME"
#
#   # cat "$SSH_DIR/id_rsa.pub" >> "$SSH_DIR/authorized_keys"
#
#   # chmod 600 "$SSH_DIR/authorized_keys"
# fi

if ! [[ -d "$ANSIBLE_DIR" ]]; then
  if [[ -d "$CONFIG_DIR" ]]; then
    mv "$CONFIG_DIR" "$TMP_CONFIG_DIR"
  fi
# else
#   cd "$CONFIG_DIR"
#   git pull
fi


# if [[ -f "$ANSIBLE_DIR/requirements.yml" ]]; then
#   cd "$ANSIBLE_DIR"
#
#   ansible-galaxy install -r requirements.yml
# fi

# cd "$ANSIBLE_DIR"

# if [[ -f "$ANSIBLE_DIR/vault-password.txt" ]]; then
#   ansible-playbook --diff --ask-become-pass --vault-password-file "$ANSIBLE_DIR/vault-password.txt" "$ANSIBLE_DIR/main.yml"
# else
#   ansible-playbook --diff --ask-become-pass "$ANSIBLE_DIR/main.yml"
# fi
#

if ! [[ -d "$TMP_DIR/ansible" ]]; then
  git clone "https://github.com/SamiElkateb/ansible.git" "$TMP_DIR/ansible"
fi

cd "$TMP_DIR/ansible"
git pull
AUTH_TAG=""
if [ "$WITH_AUTH" = 1 ]; then
  AUTH_TAG=",auth"
fi

export ANSIBLE_BECOME_PASSWORD
if [ "$INSTALL_LEVEL" = 1 ]; then
  ansible-playbook -e ansible_become_password='{{ lookup("env", "ANSIBLE_BECOME_PASSWORD") }}' --tags "core$AUTH_TAG" main.yml
elif [ "$INSTALL_LEVEL" = 2 ]; then
  ansible-playbook -e ansible_become_password='{{ lookup("env", "ANSIBLE_BECOME_PASSWORD") }}' --tags "basic$AUTH_TAG" main.yml
elif [ "$INSTALL_LEVEL" = 3 ]; then
  ansible-playbook -e ansible_become_password='{{ lookup("env", "ANSIBLE_BECOME_PASSWORD") }}' --tags "extended$AUTH_TAG" main.yml
fi
unset ANSIBLE_BECOME_PASSWORD

if [[ -d "$TMP_CONFIG_DIR" ]]; then
  cp "$TMP_CONFIG_DIR/*" "$CONFIG_DIR/"
  rm -rf "$TMP_CONFIG_DIR"
fi
