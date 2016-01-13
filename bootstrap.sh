#!/bin/sh

BKP_TYPE=incremental

BKP_SNAPSHOT=$BKP_STORAGE/$BKP_SNAPSHOT

if [ "$1" = "full" ]; then
    BKP_TYPE=full
    rm -f $BKP_SNAPSHOT
fi
if [ ! -f $BKP_SNAPSHOT ]; then
    BKP_TYPE=full
fi

echo "Performing $BKP_TYPE backup:"

BKP_TIMESTAMP=$(date --utc +"%Y%m%d-%H%M")
BKP_SUFFIX=tgz

cd $BKP_STORAGE
rm -f $BKP_PREFIX-*.$BKP_SUFFIX

BKP_FILE=$BKP_STORAGE/$BKP_PREFIX-$BKP_TIMESTAMP-$BKP_TYPE.$BKP_SUFFIX

echo "Collecting data ..."
cd $BKP_CONTENT
tar --listed-incremental="$BKP_SNAPSHOT" -czf "$BKP_FILE" *

# echo $BKP_TIMESTAMP
# ls -al $BKP_STORAGE

if [ -n "$BKP_LOCATION" ]; then
    echo "Uploading backup archive ..."
    curl -o /dev/zero -T $BKP_FILE $BKP_LOCATION
fi

echo "Finished!"
