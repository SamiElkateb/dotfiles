#!/bin/sh

CURR_DIR=${PWD##*/}
CURR_DIR=${CURR_DIR:-/} 
REPOSITORY_NAME="$CURR_DIR"
IS_PRIVATE="true"
DESCRIPTION=""
HELP="false"

while getopts "n:p:d:h" opt; do
  case $opt in
    n) REPOSITORY_NAME="$OPTARG";;
    p) IS_PRIVATE="$OPTARG";;
    d) DESCRIPTION="$OPTARG";;
    h) HELP="true";;
    *) ;;
  esac
done

if [ "$HELP" = "true" ] ; then :
  printf "
      -n REPOSITORY_NAME (default=dirname)\n
      -p IS_PRIVATE (default=true)\n
      -d DESCRIPTION (default="")\n
      -h HELP\n"
  exit 0
fi

if [ "$IS_PRIVATE" != "true" ] && [ "$IS_PRIVATE" != "false" ] ; then :
  echo "error: -p true || false"
  exit 1
fi

acknowledge () {
    echo "Press [ENTER] to continue"
    read -r key  
    if [ "$key" != "" ]; then 
      exit 0
    fi
}

create_remote_repo () {
  PRIVATE_STATUS=""
  if [ "$IS_PRIVATE" = "true" ] ; then :
    PRIVATE_STATUS="private"
  fi
  echo "Creating $PRIVATE_STATUS repository $REPOSITORY_NAME"
  acknowledge

  curl -L \
    -X POST \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $GITHUB_TOKEN"\
    -H "X-GitHub-Api-Version: 2022-11-28" \
    https://api.github.com/user/repos \
    -d "{\"name\":\"$REPOSITORY_NAME\",\"description\":\"$DESCRIPTION\",\"private\": $IS_PRIVATE}"

  git remote add origin git@github.com:"$GITHUB_USERNAME"/"$REPOSITORY_NAME".git
  git push -u origin main
}

if git rev-parse --git-dir > /dev/null 2>&1; then : 
  git remote -v|grep -q origin
  if git remote -v|grep -q origin ; then : 
    echo "error: The current repository already has a remote origin"
    exit 1
  fi
  create_remote_repo
else :
  echo "Creating git repository"
  acknowledge
  git init
  git add .
  git commit -m "init: repository"
  create_remote_repo
fi
exit 0
