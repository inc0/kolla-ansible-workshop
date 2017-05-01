#!/bin/bash
action=${1:-"create"}
statedir="state"
echo "====$(date)====$action" >> accounts.txt
for i in `seq ${2:-0} ${3:-0}`;
do
  student="student$i"
  echo 
  if [ "x$action" = "xcreate" ]; then
    echo "Creating $student..."
    password=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32})
    terraform apply -state=$statedir/$student -var prefix=$student -var password=$password
    echo "$student - $password" >> accounts.txt
    exit 0
  fi
  if [ "x$action" = "xdestroy" ]; then
    echo "Destroying  $student..."
    terraform destroy -state=$statedir/$student -var prefix=$student -force
    exit 0
  fi
  echo "$1 is not a valid command"
done
