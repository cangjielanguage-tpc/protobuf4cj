#! /bin/bash

git subtree push -P src/protobuf . sub_protobuf
git subtree push -P src/google . sub_google
git subtree push -P src/protoc . sub_protoc