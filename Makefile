# 安装选项
LIB_DESTDIR		= /usr/local/lib
BIN_DESTDIR		= /usr/local/bin
CANGJIE_DESTDIR	= $(CANGJIE_PATH)

# 构建输出选项
OUTPUT			= ./output

# 编译选项
CJC_FLAGS		= -g -O2

# lib 选项
# lib 类型, "dy" or "static"
LIB_TYPE		= static

all: submodules build

# 检查submodules
submodules:
	@ if git submodule status | egrep -q '^[-]|^[+]' ; then \
		echo "INFO: Need to reinitialize git submodules"; \
		git submodule update --init; \
	fi

# 构建
build: protoc-gen-cj

protoc-gen-cj: protobuf
	make -C src/google google OUTPUT=$(abspath $(OUTPUT)) CJC_FLAGS="$(CJC_FLAGS)"
	make -C src/protoc protoc OUTPUT=$(abspath $(OUTPUT)) CJC_FLAGS="$(CJC_FLAGS)"

protobuf: json
	make -C src/protobuf protobuf OUTPUT=$(abspath $(OUTPUT)) CJC_FLAGS="$(CJC_FLAGS)" LIB_TYPE=$(LIB_TYPE)

json:
	make -C third_party/json json OUTPUT=$(abspath $(OUTPUT)) CJC_FLAGS="$(CJC_FLAGS)" LIB_TYPE=$(LIB_TYPE)

# 安装
install:
	make -C third_party/json install OUTPUT=$(abspath $(OUTPUT)) LIB_DESTDIR=$(LIB_DESTDIR) CANGJIE_DESTDIR=$(CANGJIE_DESTDIR)
	make -C src/protobuf install OUTPUT=$(abspath $(OUTPUT)) LIB_DESTDIR=$(LIB_DESTDIR) CANGJIE_DESTDIR=$(CANGJIE_DESTDIR)
	make -C src/protoc install OUTPUT=$(abspath $(OUTPUT)) BIN_DESTDIR=$(BIN_DESTDIR)

clean:
	-rm -rf $(OUTPUT)

.PHONY: all submodules build protoc-gen-cj protobuf json install clean

# 检查环境变量
env-%:
	@ if [ "${${*}}" = "" ]; then \
		echo "Environment variable $* not set"; \
		exit 1; \
	fi

# 移除已安装
purge: env-CANGJIE_DESTDIR
	-rm -rf $(CANGJIE_PATH)/protobuf
	-rm -rf $(CANGJIE_PATH)/json
	-rm -f $(LIB_DESTDIR)/libprotobuf-cj.*
	-rm -f $(LIB_DESTDIR)/libjson.*
	-rm -f $(BIN_DESTDIR)/protoc-gen-cj

.PHONY: purge env-CANGJIE_PATH

# 依赖的.proto文件
proto_files :=  src/google/protobuf/descriptor.proto \
				src/google/protobuf/compiler/plugin.proto

# 编译.proto文件生成.pb.cj代码
gencode: $(proto_files)
	protoc --cj_out=./src --plugin=$(OUTPUT)/protoc-gen-cj -Isrc $^

.PHONY: gencode