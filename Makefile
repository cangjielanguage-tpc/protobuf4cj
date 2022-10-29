# 安装选项
LIB_DESTDIR		= /usr/local/lib
CANGJIE_DESTDIR	= $(CANGJIE_PATH)

# 构建输出选项
OUTPUT			= ./output

# 编译选项
CJC_FLAGS		= -g -O2

# lib 选项
# lib 类型, "dy" or "static"
LIB_TYPE		= static
# lib 后缀
ifeq ($(LIB_TYPE), static)
	LIB_POSTFIX	= a
	FFI_TYPECAST= ffi-typecast.o
	FFI_GCCOPT	= -fPIE
else
	LIB_POSTFIX = so
	FFI_TYPECAST= libffi-typecast.so
	FFI_GCCOPT	= -fPIC -shared
endif

LIB_NAME_PB		= protobuf-cj

# ---- 目标
TARGET			= $(OUTPUT)/protoc-gen-cj
CJO_PROTOBUF	= $(OUTPUT)/protobuf/protobuf.cjo
LIB_PROTOBUF	= $(OUTPUT)/protobuf/lib$(LIB_NAME_PB).$(LIB_POSTFIX)

all: build

# 检查环境变量
env-%:
	@ if [ "${${*}}" = "" ]; then \
		echo "Environment variable $* not set"; \
		exit 1; \
	fi

# 安装
install: env-CANGJIE_DESTDIR
	make -C third_party/json install OUTPUT=$(abspath $(OUTPUT)) LIB_DESTDIR=$(LIB_DESTDIR) CANGJIE_DESTDIR=$(CANGJIE_DESTDIR)
	-cp -a $(OUTPUT)/protobuf/lib$(LIB_NAME_PB).* $(LIB_DESTDIR)
	install -d $(CANGJIE_DESTDIR)/protobuf
	-cp -a $(OUTPUT)/protobuf/*.cjo $(CANGJIE_DESTDIR)/protobuf

# 构建目标
build: protobuf

protobuf: json $(CJO_PROTOBUF) $(LIB_PROTOBUF)
$(CJO_PROTOBUF) $(LIB_PROTOBUF): src/protobuf/*.cj $(OUTPUT)/$(FFI_TYPECAST)
	install -d $(OUTPUT)/protobuf
	cjc $(CJC_FLAGS) -p src/protobuf --output-type=$(LIB_TYPE)lib --module-name protobuf --import-path $(OUTPUT) --output-dir $(OUTPUT)/protobuf -o lib$(LIB_NAME_PB).$(LIB_POSTFIX)
	@ if [ "$(LIB_TYPE)" = "static" ]; then \
		echo "ar r $(LIB_PROTOBUF) $(OUTPUT)/$(FFI_TYPECAST)"; \
		ar r $(LIB_PROTOBUF) $(OUTPUT)/$(FFI_TYPECAST); \
	fi

$(OUTPUT)/$(FFI_TYPECAST): src/protobuf/typecast.ffi.c
	gcc -g -c $(FFI_GCCOPT) $^ -o $@

json:
	make -C third_party/json json OUTPUT=$(abspath $(OUTPUT)) CJC_FLAGS="$(CJC_FLAGS)" LIB_TYPE=$(LIB_TYPE)

clean:
	-rm -rf $(OUTPUT)

.PHONY: all build protobuf json install clean env-CANGJIE_DESTDIR