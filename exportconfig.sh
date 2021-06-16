#!/usr/bin/env bash

declare -a resources=(
  configmap
  secret
  route
);

namespace="nexus2";
namespace2="somenexus2";
DIR="BACKUP";
ACTION=$1;

function backup {
  mkdir -p $DIR;
  cd $DIR;

  for resource in "${resources[@]}";
  do

    mkdir -p $resource;

    echo "Backing up ${resource}s";

    for item in `oc get $resource -n $namespace --no-headers |awk '{print $1}'`;
    do

      exportfile="$resource/$item.yml";
      echo "Exporting $item -> $exportfile";
      oc get $resource $item -n $namespace  -o yaml > $exportfile;

    done
    echo "EXPORTING: ${resource}s COMPLETE";
    echo "===============================================";

  done;
}
function restore {

  for resource in "${resources[@]}";
  do
    echo "Trying to restore ${resource}s";

    for item in `ls $DIR/$resource/*`;
    do

      echo "Restoring $item";
      oc apply --namespace=$namespace2 -f $item;

    done

    echo "RESTORE: ${resource}s COMPLETE";
    echo "===============================================";

  done;
}

function main {
  echo $ACTION;
  case $ACTION in
    backup)
      echo "Action: \"backup\"."
      backup;
      echo "*******************************";
      ;;

    restore)
      echo "Action: \"restore\"."
      restore;
      echo "*******************************";
      ;;

    *)
      echo "ERROR: Unknown action $ACTION. Choose backup or restore";
      ;;
  esac
}

main;
