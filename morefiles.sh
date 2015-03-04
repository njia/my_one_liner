#!/usr/bin/env bash

if [[ $# != 2 ]]; then
  echo "Need two directory names"
  exit 1
fi

if [[ -d $1 ]]; then
  dir1=$1
else
  echo "Directory $1 does not exist"
  exit 1
fi

if [[ -d $2 ]]; then
  dir2=$2
else
  echo "Directory $2 does not exist"
  exit 1
fi

if [[ -r $dir1 ]]; then
  fn1=$(ls -la $dir1 2>/dev/null | wc -l)
else 
  echo "Could  not read $dir1 set number of files to 0"
  fn1=0
fi

if [[ -r $dir2 ]]; then
  fn2=$(ls -la $dir2 2>/dev/null | wc -l)
else
  echo "Count not read $dir2 set number of files to 0"
  fn2=0
fi

if [[ $fn1 -gt $fn2 ]]; then
  echo "Directory $dir1 has more files than $dir2"
elif [[ $fn1 -eq $fn2 ]]; then
  echo "There are same number of files in directory $dir1 and $dir2"
else
  echo "Directory $dir2 has more files than $dir1"
fi

exit 0
