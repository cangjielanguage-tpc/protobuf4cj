#! /bin/bash

cd `dirname $0`

if [ "$1" = "clean" ]; then
    rm *.cjo *.a *.so *.bin *.json *.gcno *.gcda serialize deserialize -f
    rm foo/ -rf
    exit 0
fi

FLAG="--coverage -lprotobuf-cj"

if [ "$*" != "" ]; then
    FLAG=$*
fi

protoc --cj_out=. -I. example.proto

cjc -p foo/ --output-type=dylib

cjc serialize.cj -L. -lfoo -o serialize $FLAG
./serialize

exit 0
