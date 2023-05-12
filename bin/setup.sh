#!/bin/bash

set -e

if [[ "$OSTYPE" == "darwin"* ]]; then
  # Ask System Events permission:
  osascript -e 'tell application "System Events" to keystroke " "'
fi

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

if [ -z "$WITH_NOTIFICATION" ]; then
  read -p "With Notification: 
  0: NO
  1: YES
  " WITH_NOTIFICATION
  export WITH_NOTIFICATION
  echo

  if [ "$WITH_NOTIFICATION" = 1 ]; then
    read -s -p "Notification Password: " NOTIFICATION_PASSWORD
    NOTIFICATION_VAULT_FILE="$TMP_DIR/notification_password.txt"
    echo "$NOTIFICATION_PASSWORD" > "$NOTIFICATION_VAULT_FILE"
    echo
    if [ -z "$ANSIBLE_VAULT_PASSWORD_FILE" ]; then 
      ANSIBLE_VAULT_PASSWORD_FILE="$NOTIFICATION_VAULT_FILE"
    else
      ANSIBLE_VAULT_PASSWORD_FILE="$ANSIBLE_VAULT_PASSWORD_FILE $NOTIFICATION_VAULT_FILE"
    fi
    export ANSIBLE_VAULT_PASSWORD_FILE
  fi
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

if ! [[ -d "$ANSIBLE_DIR" ]]; then
  if [[ -d "$CONFIG_DIR" ]]; then
    mv "$CONFIG_DIR" "$TMP_CONFIG_DIR"
  fi
fi

if ! [[ -d "$TMP_DIR/ansible" ]]; then
  git clone "https://github.com/SamiElkateb/ansible.git" "$TMP_DIR/ansible"
fi

cd "$TMP_DIR/ansible"
git pull
CONDITIONAL_TAGS=""
if [ "$WITH_AUTH" = 1 ]; then
  CONDITIONAL_TAGS="$CONDITIONAL_TAGS,auth"
fi
if [ "$WITH_NOTIFICATION" = 1 ]; then
  CONDITIONAL_TAGS="$CONDITIONAL_TAGS,notify"
fi

export ANSIBLE_BECOME_PASSWORD
export SUDO_ASKPASS="$TMP_DIR/pass.sh"
echo '#!/bin/bash' > "$SUDO_ASKPASS"
echo "echo '$ANSIBLE_BECOME_PASSWORD'" >> "$SUDO_ASKPASS"
chmod +x "$SUDO_ASKPASS"
if [ "$INSTALL_LEVEL" = 1 ]; then
  ansible-playbook -e ansible_become_password='{{ lookup("env", "ANSIBLE_BECOME_PASSWORD") }}' --tags "core$CONDITIONAL_TAGS" main.yml
elif [ "$INSTALL_LEVEL" = 2 ]; then
  ansible-playbook -e ansible_become_password='{{ lookup("env", "ANSIBLE_BECOME_PASSWORD") }}'  --tags "basic$CONDITIONAL_TAGS" main.yml
elif [ "$INSTALL_LEVEL" = 3 ]; then
  ansible-playbook -e ansible_become_password='{{ lookup("env", "ANSIBLE_BECOME_PASSWORD") }}' --tags "extended$CONDITIONAL_TAGS" main.yml
fi

rm "$SUDO_ASKPASS"
unset SUDO_ASKPASS
unset ANSIBLE_BECOME_PASSWORD
unset NOTIFICATION_PASSWORD

if [ -f "$NOTIFICATION_VAULT_FILE" ]; then
  rm "$NOTIFICATION_VAULT_FILE"
fi

if [[ -d "$TMP_CONFIG_DIR" ]]; then
  cp "$TMP_CONFIG_DIR/*" "$CONFIG_DIR/"
  rm -rf "$TMP_CONFIG_DIR"
fi
