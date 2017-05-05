#!/bin/bash
if [ $# -eq 0 ]; then
  echo "Usage: deploy.sh [action] [start] [end] [operating systen] "
  echo "Example: deploy.sh create 0 10 centos - creates 11 instances of centos environment (i.e. stundent0 - student10)"
  echo "Example: deploy.sh destroy 0 10 - destroys environments 0 - 10"
  exit 1
fi
action=${1:-"create"}
statedir="state"
seq_start=${2:-0}
seq_end=${3:-0}
os=${4:-"ubuntu"}
start=`date +%s`

echo "====$(date)====$action $seq_start $seq_end $os" >> student-info
for i in `seq $seq_start $seq_end`;
do
  student="student$i"
  echo 
  if [ "x$action" = "xcreate" ]; then
    echo "Creating $student..."
    password=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c8)
    terraform apply -state=$statedir/$student -var prefix=$student -var password=$password -var os=$os -var user=$os
  fi
  if [ "x$action" = "xdestroy" ]; then
    echo "Destroying  $student..."
    terraform destroy -state=$statedir/$student -var prefix=$student -force
  fi
done
end=`date +%s`
echo "Students applied:  $seq_start - $seq_end"
echo "Total time: $((end-start)) seconds"
