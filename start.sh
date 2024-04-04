#!/usr/bin/env bash
SOURCE_CSV=sets.csv
SOURCE_GZ=$SOURCE_CSV.gz
URL=https://cdn.rebrickable.com/media/downloads/$SOURCE_GZ
UNSORTED=processed_UNSORTED_$SOURCE_CSV
SORTED=processed_$SOURCE_CSV
BACKUP=backup_$SOURCE_GZ

echo "Downloaded $URL to $SOURCE_GZ"
rm $BACKUP $SORTED $UNSORTED
if [ -f $SOURCE_GZ ]; then
  mv $SOURCE_GZ $BACKUP
fi
curl $URL --output $SOURCE_GZ

echo "unzip..."
rm $SOURCE_CSV
gunzip $SOURCE_GZ

echo "rewrite csv to: $UNSORTED"
caf lego-sets-csv-rewrite.caf >$UNSORTED

echo "sorting..."
(head -n 1 $UNSORTED && tail -n +2 $UNSORTED | sort -t, -k1,1n) >$SORTED
echo "done: $SORTED"
