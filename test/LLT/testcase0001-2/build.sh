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

if [ -f deserialize.cj ]; then
    if [ -f ./pb_java_idea/pb_java2cj.bin ]; then
        cjc deserialize.cj -L. -lfoo -o deserialize $FLAG
        ./deserialize
    else
        echo "Deserialize testcase is not ready."
    fi
fi

exit 0
