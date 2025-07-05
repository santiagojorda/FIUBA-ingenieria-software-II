
#/bin/bash

TARGET_HOST=$1
VERSION=$2

TARGET_URL="$TARGET_HOST/version"

i="0"

while [ $i -lt 3 ]
do
  echo "Smoke test"
  result=`curl  $TARGET_URL | grep $VERSION`
  if [ "$?" = "0" ];
  then
  	echo "Test:OK"
  	exit 0
  fi
  i=$(( $i+1 ))
  sleep 20
done

echo "Test:FAIL"
exit 1
