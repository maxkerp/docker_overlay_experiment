#! /usr/bin/bash

mount -t overlay overlay -o lowerdir=/parent/mod/:/parent/app/ /parent/merged/

echo ""
echo "File contents of app_dir"
echo ""
cat /parent/app/kept_file.txt
cat /parent/app/overlayed_file.txt

echo ""
echo "File contents of mod_dir"
echo ""
cat /parent/mod/kept_file.txt
cat /parent/mod/overlayed_file.txt

echo ""
echo "File contents of merged_dir"
echo ""
cat /parent/merged/kept_file.txt
cat /parent/merged/overlayed_file.txt
echo ""

tree /parent
