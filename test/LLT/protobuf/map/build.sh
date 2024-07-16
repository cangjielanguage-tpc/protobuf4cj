#! /bin/bash

cd `dirname $0`

if [ "$1" = "clean" ]; then
    rm *.cjo *.a *.so *.bin *.json *.gcno *.gcda serialize deserialize -f
    exit 0
fi

FLAG="--coverage -lprotobuf-cj"

if [ "$*" != "" ]; then
    FLAG=$*
fi

cjc serialize.cj -L. -o serialize $FLAG
./serialize

if [ -f deserialize.cj ]; then
    if [ -f ./pb_java_idea/pb_java2cj.bin ]; then
        cjc deserialize.cj -L. -o deserialize $FLAG
        ./deserialize
    else
        echo "Deserialize testcase is not ready."
    fi
fi

exit 0
