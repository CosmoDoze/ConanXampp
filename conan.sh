#!/bin/bash

TRIM="$1"
CUSTOM="$2"

case "$TRIM" in
  --default|-d|"")
    LOCAL=`pwd`
  ;;
  --set|-s)
    if [ "$CUSTOM" ];
      then
        LOCAL=$CUSTOM
      else
        echo "The path is not defined, please Try Again."
        exit 0
    fi
  ;;
  *)
    case $TRIM in
      -default|--d)
        echo "Please try again, you meant '--default' or '-d' and not $TRIM"
      ;;
      -set|--s)
        echo "Please try again, you meant '--set' or '-s' and not $TRIM"
      ;;
      *)
        echo "Try again, '$TRIM' is not defined."
      ;;
    esac
    # program execution finally
    exit 0
  ;;
esac

cd $LOCAL # ! important, don't change.

# settings of system user
DATA=~/.watch

if [ -e $DATA ];
  then
    while read line
      do
        USER="$line"
    done < $DATA/saved.txt
  else
    mkdir -p $DATA
    printf "User: "
      read USER
    echo -e "$USER" >> $DATA/saved.txt
fi

# basic information
APP="conan"
FOR="/home/$USER/.apache/htdocs/"

# history information
TMP_FILE="history.txt"
TMP="/tmp/$TMP_FILE"
BKP="/tmp/bkp_history/"

mkdir -p $BKP # ! important don't change

if [ -e $BKP$TMP_FILE ];
  then
    echo '' >> /tmp/file.txt
  else
    echo '' >> $BKP$TMP_FILE
fi

# preview default
LAST="ls -c -l -g -R --ignore=$APP.sh"

# the folder is true or false
for i in `find`;
    do
      if [ -f $LOCAL/$i ];
        then
          FOLDER=true
        else
          FOLDER=false
      fi
done

echo "------------------------------------------------------"
  if [ $FOLDER = true ];
    then
      printf 'o--> Files: '
      ls --color=auto
    else
      echo "Not have files..."
  fi
echo "------------------------------------------------------"

function review {

  cp -uv . $FOR -R # copy files to path

  if [ -e $TMP ];
    then
      mv -f $TMP $BKP
  fi
  for i in `find`; # or 'ls' to only folders and not subfolders (not recommended)
    do
      echo $i >> $TMP
  done
}

# function for verify if the files returns a true compare
function compare {
  while read line
    do
      if [ -e $line ];
        then
          echo $line >> /tmp/not_function.txt
        else
          echo -e " \033[0;31m Deleted: $FOR$line \033[0m"
          rm -rf $FOR$line
      fi
  done < $BKP$TMP_FILE
}

# echo "------------------------------------------------------"
# echo "| Created By: Junior L. Botelho | GitHub: @CosmoDoze |"
# echo "------------------------------------------------------"

while true; do
  sleep 1
  # compare with preview default
  NEW=`ls -c -l -g -R --ignore=$APP.sh`
  if [ "$NEW" != "$LAST" ];
    then
      review # history function
      compare # compare files deleted function

      LAST="$NEW"
  fi
done
